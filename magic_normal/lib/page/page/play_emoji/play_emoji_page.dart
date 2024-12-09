import 'package:flutter/material.dart';
import 'package:magic_base/base_widget/sm_base_page.dart';
import 'package:magic_base/base_widget/sm_gradient_text_widget.dart';
import 'package:magic_base/base_widget/sm_image_widget.dart';
import 'package:magic_base/base_widget/sm_text_widget.dart';
import 'package:magic_base/utils/sm_export.dart';
import 'package:magic_base/utils/sm_extension.dart';
import 'package:magic_base/utils/voice/voice_utils.dart';
import 'package:magic_normal/enums/play_result_status.dart';
import 'package:magic_normal/page/page/play_emoji/play_emoji_controller.dart';
import 'package:magic_normal/page/widget/left_up_level_widget/left_up_level_widget.dart';
import 'package:magic_normal/page/widget/play_bottom_widget/play_bottom_widget.dart';
import 'package:magic_normal/page/widget/play_fail_widget/play_fail_widget.dart';
import 'package:magic_normal/page/widget/play_top_widget/play_top_widget.dart';
import 'package:magic_normal/page/widget/win_up_widget/win_up_widget.dart';
import 'package:magic_normal/utils/normal_sql/play_info_bean.dart';

class PlayEmojiPage extends SmBasePage<PlayEmojiController>{
  @override
  String backgroundName() => "emoji1";

  @override
  PlayEmojiController setController() => PlayEmojiController();

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
    child: Scratcher(
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
        VoiceUtils.instance.playVoiceMp3();
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
              child: GetBuilder<PlayEmojiController>(
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
                    return Container(
                      width: double.infinity,
                      height: 86.h,
                      alignment: Alignment.center,
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          SmImageWidget(imageName: bean.icon,width: 64.w,height: 64.h,),
                          Visibility(
                            visible: bean.icon=="emoji6",
                            child: SmGradientTextWidget(
                              text: "${bean.reward}",
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
                      ),
                    );
                  },
                  staggeredTileBuilder: (int index) => const StaggeredTile.fit(1),
                ),
              ),
            ),
            GetBuilder<PlayEmojiController>(
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
          ],
        ),
      ),
    ),
  );

  _bottomDescWidget()=>Container(
    width: double.infinity,
    margin: EdgeInsets.only(bottom: 8.h),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        //Reveal Three 😊 in same row，column，or
        // diagonal to win
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

  _goldWidget()=>GetBuilder<PlayEmojiController>(
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