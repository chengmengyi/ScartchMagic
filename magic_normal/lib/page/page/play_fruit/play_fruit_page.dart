import 'package:flutter/material.dart';
import 'package:magic_base/base_widget/sm_base_page.dart';
import 'package:magic_base/base_widget/sm_gradient_text_widget.dart';
import 'package:magic_base/base_widget/sm_image_widget.dart';
import 'package:magic_base/base_widget/sm_text_widget.dart';
import 'package:magic_base/utils/sm_export.dart';
import 'package:magic_base/utils/sm_extension.dart';
import 'package:magic_base/utils/voice/voice_utils.dart';
import 'package:magic_normal/enums/play_result_status.dart';
import 'package:magic_normal/page/page/play_fruit/play_fruit_controller.dart';
import 'package:magic_normal/page/widget/left_up_level_widget/left_up_level_widget.dart';
import 'package:magic_normal/page/widget/play_bottom_widget/play_bottom_widget.dart';
import 'package:magic_normal/page/widget/play_fail_widget/play_fail_widget.dart';
import 'package:magic_normal/page/widget/play_top_widget/play_top_widget.dart';
import 'package:magic_normal/page/widget/win_up_widget/win_up_widget.dart';
import 'package:magic_normal/utils/normal_sql/normal_sql_utils.dart';
import 'package:magic_normal/utils/normal_sql/play_info_bean.dart';

class PlayFruitPage extends SmBasePage<PlayFruitController>{
  @override
  String backgroundName() => "fruit_bg";

  @override
  PlayFruitController setController() => PlayFruitController();

  @override
  Widget? topTitleWidget() => PlayTopWidget();

  @override
  Widget contentWidget() => Stack(
    key: smController.contentGlobalKey,
    children: [
      Column(
        children: [
          SizedBox(height: 20.h,),
          LeftUpLevelWidget(),
          const Spacer(),
          _contentWidget(),
          SizedBox(height: 20.h,),
          PlayBottomWidget(
            revealAll: (){
              smController.clickOpen();
            },
          ),
        ],
      ),
      _goldWidget(),
    ],
  );

  _contentWidget()=>Container(
    width: double.infinity,
    height: 430.h,
    margin: EdgeInsets.only(left: 4.w,right: 4.w),
    child: Stack(
      children: [
        SmImageWidget(imageName: "play_fruit_bg",width: double.infinity,height: double.infinity,),
        _playWidget(),
        _winUpToWidget(),
      ],
    ),
  );

  _playWidget()=>Align(
    alignment: Alignment.bottomCenter,
    child: Container(
      width: double.infinity,
      height: 252.h,
      key: smController.globalKey,
      margin: EdgeInsets.only(left: 19.w,right: 19.w,bottom: 31.h),
      child: Stack(
        children: [
          Scratcher(
            key: smController.key,
            enabled: true,
            brushSize: 40,
            threshold: 60,
            color: Colors.transparent,
            image: Image.asset('magic_file/magic_image/play_fruit_bg3.webp',fit: BoxFit.fill,),
            onThreshold: (){
              smController.key.currentState?.reveal();
              smController.onThreshold();
            },
            onScratchStart: (){
              VoiceUtils.instance.playVoiceMp3();
            },
            onScratchUpdate: (details){
              smController.updateIconOffset(details);
            },
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Stack(
                children: [
                  SmImageWidget(imageName: "play_fruit_bg2",width: double.infinity,height: 252.h,),
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(left: 78.w),
                    child: GetBuilder<PlayFruitController>(
                      id: "list",
                      builder: (_)=>StaggeredGridView.countBuilder(
                        padding: const EdgeInsets.all(0),
                        itemCount: smController.rewardList.length,
                        shrinkWrap: true,
                        crossAxisCount: 3,
                        mainAxisSpacing: 2.h,
                        crossAxisSpacing: 6.w,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context,index){
                          return Container(
                            width: double.infinity,
                            height: 82.h,
                            alignment: Alignment.center,
                            child: SmImageWidget(imageName: smController.rewardList[index],width: 72.w,height: 72.h,),
                          );
                        },
                        staggeredTileBuilder: (int index) => const StaggeredTile.fit(1),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          GetBuilder<PlayFruitController>(
            id: "result_fail",
            builder: (_)=>Visibility(
              visible: smController.playResultStatus==PlayResultStatus.fail,
              child: PlayFailWidget(
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          )
        ],
      )
    ),
  );

  _winUpToWidget()=>Align(
    alignment: Alignment.topCenter,
    child: Container(
      margin: EdgeInsets.only(top: 22.h),
      child: WinUpWidget(playType: PlayType.playfruit,),
    ),
  );

  _goldWidget()=>GetBuilder<PlayFruitController>(
    id: "gold_icon",
    builder: (_){
      var left=null==smController.iconOffset?0.0:smController.iconOffset?.dx??0.0;
      var top=null==smController.iconOffset?0.0:smController.iconOffset?.dy??0.0;
      return null==smController.iconOffset?
      Container():
      Container(
        margin: EdgeInsets.only(left: left<0?0:left,top: top<0?0:top),
        child: Image.asset("magic_file/magic_image/gold.png",width: 40,height: 40),
      );
    },
  );
}