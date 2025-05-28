import 'package:flutter/material.dart';
import 'package:magic_b/page/widget/btn_widget/btn_widget.dart';
import 'package:magic_b/page/widget/dialog/add_chance_dialog/add_chance_controller.dart';
import 'package:magic_b/page/widget/watch_video_btn_widget/watch_video_btn_widget.dart';
import 'package:magic_b/utils/b_sql/play_info_bean.dart';
import 'package:magic_base/base_widget/sm_base_dialog.dart';
import 'package:magic_base/base_widget/sm_gradient_text_widget.dart';
import 'package:magic_base/base_widget/sm_image_widget.dart';
import 'package:magic_base/base_widget/sm_text_widget.dart';
import 'package:magic_base/utils/sm_export.dart';
import 'package:magic_base/utils/sm_extension.dart';

class AddChanceDialog extends SmBaseDialog<AddChanceController>{
  PlayType playType;
  Function() dismiss;
  AddChanceDialog({required this.playType,required this.dismiss});

  @override
  AddChanceController setController() => AddChanceController();

  @override
  Widget contentWidget() => Container(
    width: double.infinity,
    height: 308.h,
    margin: EdgeInsets.only(left: 36.w,right: 36.w),
    child: Stack(
      alignment: Alignment.center,
      children: [
        SmImageWidget(imageName: "old1",width: double.infinity,height: 308.h,boxFit: BoxFit.fill,),
        Align(
          alignment: Alignment.topRight,
          child: InkWell(
            onTap: (){
              smController.clickClose();
            },
            child: SmImageWidget(imageName: "close",width: 32.w,height: 32.h,),
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SmGradientTextWidget(
              text: "More Cards",
              size: 24.sp,
              fontWeight: FontWeight.w700,
              colors: ["#FFF6A9".toSmColor(),"#FFDF51".toSmColor()],
              shadows: [
                Shadow(
                    color: "#8E5602".toSmColor(),
                    blurRadius: 2.w,
                    offset: Offset(0,0.5.w)
                )
              ],
            ),
            SizedBox(height: 16.h,),
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                SmImageWidget(imageName: "more_card",width: 100.w,height: 100.h,),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SmImageWidget(imageName: "more_card2",width: 32.w,height: 32.w,),
                    SmTextWidget(text: "+5", size: 20.sp, color: "#FFFFFF",fontWeight: FontWeight.bold,),
                  ],
                )
              ],
            ),
            SizedBox(height: 16.h,),
            WatchVideoBtnWidget(
              text: "Get",
              onTap: (){
                smController.clickGet(playType,dismiss);
              },
            ),
          ],
        )
      ],
    ),
  );
}