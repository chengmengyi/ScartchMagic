import 'package:flutter/material.dart';
import 'package:magic_b/enums/play_result_status.dart';
import 'package:magic_b/page/page/play/play_child/play_8/play_8_child_controller.dart';
import 'package:magic_b/page/widget/play_fail_widget/play_fail_widget.dart';
import 'package:magic_base/base_widget/sm_base_widget.dart';
import 'package:magic_base/base_widget/sm_gradient_text_widget.dart';
import 'package:magic_base/base_widget/sm_image_widget.dart';
import 'package:magic_base/base_widget/sm_text_widget.dart';
import 'package:magic_base/utils/event/event_code.dart';
import 'package:magic_base/utils/event/event_info.dart';
import 'package:magic_base/utils/sm_export.dart';
import 'package:magic_base/utils/sm_extension.dart';
import 'package:magic_base/utils/voice/voice_utils.dart';
import 'package:magic_b/page/widget/left_up_level_widget/left_up_level_widget.dart';
import 'package:magic_b/page/widget/play_bottom_widget/play_bottom_widget.dart';
import 'package:magic_b/utils/b_sql/play_info_bean.dart';
import 'package:magic_b/utils/b_value/b_value_hep.dart';

class Play8Child extends SmBaseWidget<Play8ChildController>{

  @override
  Play8ChildController setController() => Play8ChildController();

  @override
  Widget contentWidget() => Column(
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
  );

  _contentWidget()=>Container(
    width: double.infinity,
    height: 430.h,
    margin: EdgeInsets.only(left: 4.w,right: 4.w),
    child: Stack(
      children: [
        SmImageWidget(imageName: "play82",width: double.infinity,height: double.infinity,),
        _winUpWidget(),
        _scratcherWidget(),
        _bottomTextWidget(),
      ],
    ),
  );

  _winUpWidget()=>Align(
    alignment: Alignment.topCenter,
    child: Stack(
      alignment: Alignment.topCenter,
      children: [
        SmGradientTextWidget(
          text: "${BValueHep.instance.getMaxWin(PlayType.play8.name)}",
          size: 36.sp,
          colors: [
            "#27E4FF".toSmColor(),
            "#BBF4FF".toSmColor(),
            "#1FC7FF".toSmColor(),
          ],
          fontWeight: FontWeight.w700,
          shadows: [
            Shadow(
                color: "#006BE2".toSmColor(),
                blurRadius: 2.w,
                offset: Offset(0,0.5.w)
            )
          ],
        ),
        Container(
          margin: EdgeInsets.only(top: 36.h),
          child: SmTextWidget(
            text: "Win Up To",
            size: 14.sp,
            color: "#FFFFFF",
            fontWeight: FontWeight.w600,
            shadows: [
              Shadow(
                  color: "#000000".toSmColor(),
                  blurRadius: 2.w,
                  offset: Offset(0,0.5.w)
              )
            ],
          ),
        ),
      ],
    ),
  );

  _scratcherWidget()=>Align(
    alignment: Alignment.topCenter,
    child: Container(
      width: double.infinity,
      margin: EdgeInsets.only(left: 16.w,right: 16.w,top: 62.h),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 292.h,
            key: smController.globalKey,
            margin: EdgeInsets.only(top: 16.h),
            child: Stack(
              children: [
                Scratcher(
                  key: smController.key,
                  enabled: true,
                  brushSize: 40,
                  threshold: 70,
                  color: Colors.transparent,
                  image: Image.asset('magic_file/magic_image/play83.webp',fit: BoxFit.fill,),
                  onThreshold: (){
                    smController.key.currentState?.reveal();
                    smController.onThreshold();
                  },
                  onScratchUpdate: (details){
                    smController.updateIconOffset(details);
                  },
                  onScratchStart: (){
                    EventInfo(eventCode: EventCode.canClickOtherBtn,boolValue: false);
                    VoiceUtils.instance.playVoiceMp3();
                  },
                  onScratchEnd: (){
                    smController.onScratchEnd();
                  },
                  child: SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        SmImageWidget(imageName: "play84",width: double.infinity,height: double.infinity, boxFit: BoxFit.fill,),
                        Container(
                          margin: EdgeInsets.only(left: 8.w,right: 8.w),
                          child: GetBuilder<Play8ChildController>(
                            id: "list",
                            builder: (_)=>StaggeredGridView.countBuilder(
                              padding: const EdgeInsets.all(0),
                              itemCount: smController.yourList.length,
                              shrinkWrap: true,
                              crossAxisCount: 5,
                              mainAxisSpacing: 20.h,
                              crossAxisSpacing: 0.w,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context,index){
                                var play8bean = smController.yourList[index];
                                var w = Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    SmImageWidget(imageName: play8bean.icon,width: 64.w,height: 64.h,),
                                    Offstage(
                                      offstage: play8bean.reward==0,
                                      child: SmGradientTextWidget(
                                        text: "\$${play8bean.reward}",
                                        size: 14.sp,
                                        colors: [
                                          "#FFFFFF".toSmColor(),
                                          "#FFEE90".toSmColor(),
                                        ],
                                        fontWeight: FontWeight.w700,
                                        shadows: [
                                          Shadow(
                                              color: "#F6AC00".toSmColor(),
                                              blurRadius: 2.w,
                                              offset: Offset(0,0.5.w)
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                );
                                return Container(
                                  width: double.infinity,
                                  height: 60.h,
                                  alignment: Alignment.center,
                                  key: play8bean.hasKey==true?smController.keyGlobalKey:null,
                                  child:
                                  play8bean.hasKey==true?
                                  (smController.hideKeyIcon?
                                  SizedBox(width: 60.w,height: 60.h):
                                  Lottie.asset("magic_file/magic_lottie/key.json",width: 60.w,height: 60.h)):
                                  play8bean.reward!=0?
                                  ScaleTransition(
                                    scale: smController.scaleController,
                                    child: w,
                                  ):w,
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
                GetBuilder<Play8ChildController>(
                  id: "result_fail",
                  builder: (_)=>Visibility(
                    visible: smController.playResultStatus==PlayResultStatus.fail,
                    child: PlayFailWidget(
                      width: double.infinity,
                      height: double.infinity,
                      borderRadius: BorderRadius.circular(4.w),
                    ),
                  ),
                ),
                _goldWidget()
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SmImageWidget(imageName: "play85",width: 140.w,height: 36.h,),
                    SmTextWidget(
                      text: "Lucky 8 Rich",
                      size: 20.sp,
                      color: "#FFFFFF",
                      fontWeight: FontWeight.w600,
                      shadows: [
                        Shadow(
                            color: "#218080".toSmColor(),
                            blurRadius: 2.w,
                            offset: Offset(0,0.5.w)
                        )
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SmTextWidget(
                      text: "Reveal",
                      size: 13.sp,
                      color: "#FFFFFF",
                      shadows: [
                        Shadow(
                            color: "#2953AF".toSmColor(),
                            blurRadius: 2.w,
                            offset: Offset(0,0.5.w)
                        )
                      ],
                    ),
                    SizedBox(width: 2.w,),
                    SmImageWidget(imageName: "play86",width: 14.w,height: 20.h,),
                    SizedBox(width: 2.w,),
                    SmTextWidget(
                      text: "win the X8 Bet Prize!",
                      size: 13.sp,
                      color: "#FFFFFF",
                      shadows: [
                        Shadow(
                            color: "#2953AF".toSmColor(),
                            blurRadius: 2.w,
                            offset: Offset(0,0.5.w)
                        )
                      ],
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    ),
  );

  _bottomTextWidget()=>Align(
    alignment: Alignment.bottomCenter,
    child: Container(
      margin: EdgeInsets.only(bottom: 20.h),
      child: SmTextWidget(
        text: "Match 3 symbols to win the shown prize",
        size: 12.sp,
        color: "#FFFFFF",
        fontWeight: FontWeight.w700,
        shadows: [
          Shadow(
              color: "#625990".toSmColor(),
              blurRadius: 3.w,
              offset: Offset(0,0.5.w)
          )
        ],
      ),
    ),
  );


  _goldWidget()=>GetBuilder<Play8ChildController>(
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