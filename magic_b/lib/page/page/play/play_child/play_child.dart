import 'package:flutter/material.dart';
import 'package:magic_b/page/page/play/play_child/play_big/play_big_child.dart';
import 'package:magic_b/page/page/play/play_child/play_child_controller.dart';
import 'package:magic_b/page/page/play/play_child/play_fruit/play_fruit_child.dart';
import 'package:magic_b/page/widget/bubble/bubble_widget.dart';
import 'package:magic_b/page/widget/finger_widget/finger_lottie.dart';
import 'package:magic_b/page/widget/play_top_widget/play_top_widget.dart';
import 'package:magic_b/utils/b_sql/play_info_bean.dart';
import 'package:magic_base/base_widget/sm_base_widget.dart';
import 'package:magic_base/base_widget/sm_image_widget.dart';
import 'package:magic_base/base_widget/sm_text_widget.dart';
import 'package:magic_base/utils/sm_export.dart';
import 'package:magic_base/utils/sm_extension.dart';

class PlayChild extends SmBaseWidget<PlayChildController>{
  PlayType  playType;
  PlayChild({
    required this.playType,
});
  @override
  PlayChildController setController() => PlayChildController();

  @override
  Widget contentWidget() => Stack(
    children: [
      GetBuilder<PlayChildController>(
        id: "bg",
        builder: (_)=>SmImageWidget(imageName: smController.getBgRes(playType),width: double.infinity,height: double.infinity,),
      ),
      Column(
        children: [
          PlayTopWidget(),
          Expanded(
            child: GetBuilder<PlayChildController>(
              id: "child_page",
              builder: (_)=>smController.getChildPage(playType),
            ),
          ),
        ],
      ),
      _bubbleWidget(),
      _boxWidget(),
      _boxFingerWidget(),
      _keyAnimatorWidget(),
    ],
  );

  _bubbleWidget()=>GetBuilder<PlayChildController>(
    id: "showBubble",
    builder: (_)=>smController.showBubble?BubbleWidget():Container(),
  );

  _boxWidget()=>Positioned(
    top: 138.h,
    left: 10.w,
    child: InkWell(
      onTap: (){
        smController.clickBox();
      },
      child: GetBuilder<PlayChildController>(
        id: "box",
        builder: (_)=>Stack(
          key: smController.boxGlobalKey,
          alignment: Alignment.bottomCenter,
          children: [
            SmImageWidget(imageName: "icon_box",width: 60.w,height: 60.w,),
            SizedBox(
              width: 60.w,
              height: 60.w,
              child: CircularProgressIndicator(
                value: smController.currentBox/5,
                color: "#FFD631".toSmColor(),
                backgroundColor: "#7E0F03".toSmColor(),
              ),
            ),
            SmTextWidget(
              text: "${smController.currentBox}/5",
              size: 14.sp,
              color: "#FFD91C",
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                    color: "#000000".toSmColor(),
                    blurRadius: 2.w,
                    offset: Offset(0,0.5.w)
                )
              ],
            )
          ],
        ),
      ),
    ),
  );

  _boxFingerWidget()=>GetBuilder<PlayChildController>(
    id: "box_finger",
    builder: (_){
      var dx = (smController.boxFingerOffset?.dx??0)+20.w;
      var dy = (smController.boxFingerOffset?.dy??0)+20.h;
      return Visibility(
        visible: smController.showBoxFinger,
        child: Positioned(
          left: dx,
          top: dy,
          child: InkWell(
            onTap: (){
              smController.clickBox();
            },
            child: FingerLottie(),
          ),
        ),
        // child: Container(
        //   margin: EdgeInsets.only(left: dx,top: dy),
        //   child: InkWell(
        //     onTap: (){
        //       smController.clickBox();
        //     },
        //     child: FingerLottie(),
        //   ),
        // ),
      );
    },
  );

  _keyAnimatorWidget() => GetBuilder<PlayChildController>(
    id: "key",
    builder: (_){
      var value = smController.keyAnimation?.value;
      var dx = value?.dx??0;
      var dy = value?.dy??0;
      return Visibility(
        visible: !smController.canClick,
        child: Container(
          margin: EdgeInsets.only(left: dx<=0?0:dx,top: dy<=0?0:dy),
          child: Lottie.asset("magic_file/magic_lottie/key.json",width: 80.w,height: 80.h),
        ),
      );
    },
  );
}