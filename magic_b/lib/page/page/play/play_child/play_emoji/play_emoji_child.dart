import 'package:flutter/material.dart';
import 'package:magic_b/page/page/play/play_child/play_emoji/play_emoji_child_controller.dart';
import 'package:magic_base/base_widget/sm_base_widget.dart';
import 'package:magic_base/base_widget/sm_gradient_text_widget.dart';
import 'package:magic_base/base_widget/sm_image_widget.dart';
import 'package:magic_base/base_widget/sm_text_widget.dart';
import 'package:magic_base/utils/event/event_code.dart';
import 'package:magic_base/utils/event/event_info.dart';
import 'package:magic_base/utils/sm_export.dart';
import 'package:magic_base/utils/sm_extension.dart';
import 'package:magic_base/utils/voice/voice_utils.dart';
import 'package:magic_b/enums/play_result_status.dart';
import 'package:magic_b/page/widget/left_up_level_widget/left_up_level_widget.dart';
import 'package:magic_b/page/widget/play_bottom_widget/play_bottom_widget.dart';
import 'package:magic_b/page/widget/play_fail_widget/play_fail_widget.dart';
import 'package:magic_b/page/widget/win_up_widget/win_up_widget.dart';
import 'package:magic_b/utils/b_sql/play_info_bean.dart';

class PlayEmojiChild extends SmBaseWidget<PlayEmojiChildController>{

  @override
  PlayEmojiChildController setController() => PlayEmojiChildController();

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
      alignment: Alignment.topCenter,
      children: [
        SmImageWidget(imageName: "emoji2",width: double.infinity,height: double.infinity,),
        Container(
          margin: EdgeInsets.only(top: 5.h),
          child: WinUpWidget(playType: PlayType.playemoji,),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _scratcherWidget(),
              SizedBox(height: 60.h,),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: _bottomDescWidget(),
        )
      ],
    ),
  );


  _scratcherWidget()=>Container(
    width: double.infinity,
    height: 260.h,
    key: smController.globalKey,
    margin: EdgeInsets.only(left: 20.w,right: 20.w,),
    child: Stack(
      children: [
        Scratcher(
          key: smController.key,
          enabled: true,
          brushSize: 40,
          threshold: 70,
          color: Colors.transparent,
          image: Image.asset('magic_file/magic_image/emoji3.webp',fit: BoxFit.fill,),
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
              alignment: Alignment.center,
              children: [
                SmImageWidget(imageName: "emoji4",width: double.infinity,height: double.infinity, boxFit: BoxFit.fill,),
                Container(
                  margin: EdgeInsets.only(left: 20.w,right: 20.w),
                  child: GetBuilder<PlayEmojiChildController>(
                    id: "list",
                    builder: (_)=>StaggeredGridView.countBuilder(
                      padding: const EdgeInsets.all(0),
                      itemCount: smController.emojiList.length,
                      shrinkWrap: true,
                      crossAxisCount: 3,
                      mainAxisSpacing: 0.h,
                      crossAxisSpacing: 0.w,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context,index){
                        var bean = smController.emojiList[index];
                        var w = Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            SmImageWidget(imageName: bean.icon,width: 64.w,height: 64.h,),
                            Visibility(
                              visible: bean.icon=="emoji6",
                              child: SmGradientTextWidget(
                                text: "\$${bean.reward}",
                                size: 14.sp,
                                fontWeight: FontWeight.w900,
                                colors: ["#FFFFFF".toSmColor(),"#FFD11B".toSmColor()],
                                shadows: [
                                  Shadow(
                                      color: "#6B3D0C".toSmColor(),
                                      blurRadius: 2.w,
                                      offset: Offset(0,2.w)
                                  )
                                ],
                              ),
                            ),
                          ],
                        );
                        return Container(
                          width: double.infinity,
                          height: 86.h,
                          alignment: Alignment.center,
                          key: bean.hasKey==true?smController.keyGlobalKey:null,
                          child:
                          bean.hasKey==true?
                          (smController.hideKeyIcon?
                          SizedBox(width: 60.w,height: 60.h):
                          Lottie.asset("magic_file/magic_lottie/key.json",width: 60.w,height: 60.h)):
                          smController.win&&bean.icon=="emoji6"?
                          ScaleTransition(
                            scale: smController.scaleController,
                            child: w,
                          ):
                          w,
                        );
                      },
                      staggeredTileBuilder: (int index) => const StaggeredTile.fit(1),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        GetBuilder<PlayEmojiChildController>(
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
        _goldWidget(),
      ],
    ),
  );

  _bottomDescWidget()=>Container(
    width: double.infinity,
    margin: EdgeInsets.only(bottom: 8.h),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SmTextWidget(text: "Reveal Three ", size: 12, color: "#0B4267"),
            SmImageWidget(imageName: "emoji6",width: 14.w,height: 14.h,),
            SmTextWidget(text: " in same row，column，or", size: 12, color: "#0B4267"),
          ],
        ),
        SmTextWidget(text: "diagonal to win", size: 12, color: "#0B4267"),
      ],
    ),
  );

  _goldWidget()=>GetBuilder<PlayEmojiChildController>(
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