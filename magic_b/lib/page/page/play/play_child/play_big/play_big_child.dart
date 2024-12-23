import 'package:flutter/material.dart';
import 'package:magic_b/enums/play_result_status.dart';
import 'package:magic_b/page/page/play/play_child/play_big/play_big_child_controller.dart';
import 'package:magic_b/page/widget/left_up_level_widget/left_up_level_widget.dart';
import 'package:magic_b/page/widget/play_bottom_widget/play_bottom_widget.dart';
import 'package:magic_b/page/widget/play_fail_widget/play_fail_widget.dart';
import 'package:magic_b/page/widget/win_up_widget/win_up_widget.dart';
import 'package:magic_b/utils/b_sql/play_info_bean.dart';
import 'package:magic_base/base_widget/sm_base_widget.dart';
import 'package:magic_base/base_widget/sm_image_widget.dart';
import 'package:magic_base/base_widget/sm_stroke_text_widget.dart';
import 'package:magic_base/base_widget/sm_text_widget.dart';
import 'package:magic_base/utils/event/event_code.dart';
import 'package:magic_base/utils/event/event_info.dart';
import 'package:magic_base/utils/sm_export.dart';
import 'package:magic_base/utils/sm_extension.dart';
import 'package:magic_base/utils/voice/voice_utils.dart';

class PlayBigChild extends SmBaseWidget<PlayBigChildController>{
  @override
  PlayBigChildController setController() => PlayBigChildController();
  
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
        SmImageWidget(imageName: "big_bg2",width: double.infinity,height: double.infinity,),
        _winUpToWidget(),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: EdgeInsets.only(left: 20.w,right: 20.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _winningNumWidget(),
                SizedBox(height: 6.h,),
                _yourNumWidget(),
              ],
            ),
          ),
        ),
      ],
    ),
  );

  _yourNumWidget()=>Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      SmTextWidget(text: "Your Numbers", size: 14.sp, color: "#FFFFFF",fontWeight: FontWeight.w800,),
      SizedBox(
          width: double.infinity,
          height: 180.h,
          key: smController.globalKey,
          child: Stack(
            children: [
              Scratcher(
                key: smController.key,
                enabled: true,
                brushSize: 40,
                threshold: 70,
                color: Colors.transparent,
                image: Image.asset('magic_file/magic_image/big_bg4.webp',fit: BoxFit.fill,),
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
                    children: [
                      SmImageWidget(imageName: "big_bg5",width: double.infinity,height: double.infinity,),
                      GetBuilder<PlayBigChildController>(
                        id: "your_num",
                        builder: (_)=>StaggeredGridView.countBuilder(
                          padding: const EdgeInsets.all(0),
                          itemCount: smController.yourNumList.length,
                          shrinkWrap: true,
                          crossAxisCount: 4,
                          mainAxisSpacing: 0.h,
                          crossAxisSpacing: 0.w,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context,index){
                            var bean = smController.yourNumList[index];
                            var selected = smController.winningNumList.contains(bean.num);
                            var w = Stack(
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: SmStrokeTextWidget(
                                    text: "${bean.num}",
                                    fontSize: 32.sp,
                                    textColor: selected?"#FFD622".toSmColor():"#52180E".toSmColor(),
                                    strokeColor: "#52180E".toSmColor(),
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: SmTextWidget(text: "${bean.reward}", size: 15.sp, color: selected?"#F15825":"#D2910E",),
                                ),
                              ],
                            );
                            return Container(
                              width: double.infinity,
                              height: 60.h,
                              alignment: Alignment.center,
                              key: bean.hasKey==true?smController.keyGlobalKey:null,
                              child:
                              bean.hasKey==true?
                              (smController.hideKeyIcon?
                              Container():
                              Lottie.asset("magic_file/magic_lottie/key.json",width: 60.w,height: 60.h)):
                              selected?ScaleTransition(
                                scale: smController.scaleController,
                                child: w,
                              ):
                              w,
                            );
                          },
                          staggeredTileBuilder: (int index) => const StaggeredTile.fit(1),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GetBuilder<PlayBigChildController>(
                id: "result_fail",
                builder: (_)=>Visibility(
                  visible: smController.playResultStatus==PlayResultStatus.fail,
                  child: PlayFailWidget(
                    width: double.infinity,
                    height: double.infinity,
                    borderRadius: BorderRadius.circular(14.w),
                  ),
                ),
              ),
              _goldWidget(),
            ],
          )
      ),
      Container(
        margin: EdgeInsets.only(left: 40.w,right: 40.w,bottom: 18.h,top: 8.h),
        child: SmTextWidget(text: "Match winning numbers to any of your numbersto win prize", size: 12.sp, color: "#FFFFFF",textAlign: TextAlign.center,),
      ),
    ],
  );

  _winningNumWidget()=>Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      SmTextWidget(text: "Winning Numbers", size: 14.sp, color: "#FFFFFF",fontWeight: FontWeight.w800,),
      Stack(
        alignment: Alignment.center,
        children: [
          SmImageWidget(imageName: "big_bg3",width: double.infinity,height: 52.h,),
          GetBuilder<PlayBigChildController>(
            id: "winning_num",
            builder: (_)=>Row(
              children: List.generate(smController.winningNumList.length, (index) => Expanded(
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: SmTextWidget(text: "${smController.winningNumList[index]}", size: 32.sp, color: "#FFD622",fontWeight: FontWeight.w800,height: 0,),
                ),
              )),
            ),
          )
        ],
      )
    ],
  );

  _winUpToWidget()=>Align(
    alignment: Alignment.topCenter,
    child: Container(
      margin: EdgeInsets.only(top: 10.h),
      child: WinUpWidget(playType: PlayType.playbig,),
    ),
  );

  _goldWidget()=>GetBuilder<PlayBigChildController>(
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