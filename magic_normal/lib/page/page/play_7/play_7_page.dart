import 'package:flutter/material.dart';
import 'package:magic_base/base_widget/sm_base_page.dart';
import 'package:magic_base/base_widget/sm_gradient_text_widget.dart';
import 'package:magic_base/base_widget/sm_image_widget.dart';
import 'package:magic_base/base_widget/sm_text_widget.dart';
import 'package:magic_base/utils/sm_export.dart';
import 'package:magic_base/utils/sm_extension.dart';
import 'package:magic_base/utils/voice/voice_utils.dart';
import 'package:magic_normal/enums/play_result_status.dart';
import 'package:magic_normal/page/page/play_7/play_7_controller.dart';
import 'package:magic_normal/page/widget/left_up_level_widget/left_up_level_widget.dart';
import 'package:magic_normal/page/widget/play_bottom_widget/play_bottom_widget.dart';
import 'package:magic_normal/page/widget/play_fail_widget/play_fail_widget.dart';
import 'package:magic_normal/page/widget/play_top_widget/play_top_widget.dart';
import 'package:magic_normal/page/widget/win_up_widget/win_up_widget.dart';
import 'package:magic_normal/utils/normal_sql/play_info_bean.dart';

class Play7Page extends SmBasePage<Play7Controller>{
  @override
  String backgroundName() => "play71";

  @override
  Play7Controller setController() => Play7Controller();

  @override
  Widget? topTitleWidget() => PlayTopWidget();

  @override
  Widget contentWidget() => Stack(
    key: smController.contentGlobalKey,
    children: [
      Column(
        children: [
          SizedBox(height: 16.h,),
          LeftUpLevelWidget(),
          SizedBox(height: 90.h,),
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
        SmImageWidget(imageName: "play72",width: double.infinity,height: double.infinity,boxFit: BoxFit.fill,),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 50.h,),
            WinUpWidget(playType: PlayType.play7,),
            SizedBox(height: 10.h,),
            SmTextWidget(
              text: "Hot 77 Game",
              size: 20.sp,
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
            SizedBox(height: 10.h,),
            _scratcherWidget(),
            SizedBox(height: 10.h,),
            _descTextWidget(),
          ],
        )
      ],
    ),
  );

  _scratcherWidget()=>Container(
    width: double.infinity,
    height: 192.h,
    key: smController.globalKey,
    margin: EdgeInsets.only(left: 20.w,right: 20.w,),
    child: Scratcher(
      key: smController.key,
      enabled: true,
      brushSize: 40,
      threshold: 70,
      color: Colors.transparent,
      image: Image.asset('magic_file/magic_image/play73.webp',fit: BoxFit.fill,),
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
            SmImageWidget(imageName: "play74",width: double.infinity,height: double.infinity, boxFit: BoxFit.fill,),
            GetBuilder<Play7Controller>(
              id: "your_list",
              builder: (_)=>StaggeredGridView.countBuilder(
                padding: const EdgeInsets.all(0),
                itemCount: smController.yourList.length,
                shrinkWrap: true,
                crossAxisCount: 4,
                mainAxisSpacing: 0,
                crossAxisSpacing: 0,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context,index){
                  var play7bean = smController.yourList[index];
                  return Container(
                    width: double.infinity,
                    height: 64.h,
                    alignment: Alignment.center,
                    child: play7bean.icon.isNotEmpty?
                    Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        SmImageWidget(imageName: play7bean.icon,width: 52.w,height: 52.h,),
                        SmGradientTextWidget(
                          text: "${play7bean.reward}",
                          size: 16.sp,
                          fontWeight: FontWeight.w900,
                          colors: ["#F9DF02".toSmColor(),"#EF8000".toSmColor()],
                          shadows: [
                            Shadow(
                                color: "#221002".toSmColor(),
                                blurRadius: 2.w,
                                offset: Offset(0,2.w)
                            )
                          ],
                        ),
                      ],
                    ):
                    SmTextWidget(text: "63", size: 36.sp, color: "#8B3022",fontWeight: FontWeight.w700,),
                  );
                },
                staggeredTileBuilder: (int index) => const StaggeredTile.fit(1),
              ),
            ),
            GetBuilder<Play7Controller>(
              id: "cover",
              builder: (_)=>Visibility(
                visible: smController.win,
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: "#000000".toSmColor().withOpacity(0.5),
                    ),
                    StaggeredGridView.countBuilder(
                      padding: const EdgeInsets.all(0),
                      itemCount: smController.yourList.length,
                      shrinkWrap: true,
                      crossAxisCount: 4,
                      mainAxisSpacing: 0,
                      crossAxisSpacing: 0,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context,index){
                        var play7bean = smController.yourList[index];
                        return Container(
                          width: double.infinity,
                          height: 64.h,
                          alignment: Alignment.center,
                          child: play7bean.icon.isNotEmpty?
                          Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              SmImageWidget(imageName: play7bean.icon,width: 52.w,height: 52.h,),
                              SmGradientTextWidget(
                                text: "${play7bean.reward}",
                                size: 16.sp,
                                fontWeight: FontWeight.w900,
                                colors: ["#F9DF02".toSmColor(),"#EF8000".toSmColor()],
                                shadows: [
                                  Shadow(
                                      color: "#221002".toSmColor(),
                                      blurRadius: 2.w,
                                      offset: Offset(0,2.w)
                                  )
                                ],
                              ),
                            ],
                          ):
                          Container(),
                        );
                      },
                      staggeredTileBuilder: (int index) => const StaggeredTile.fit(1),
                    )
                  ],
                ),
              ),
            ),
            GetBuilder<Play7Controller>(
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

  _descTextWidget()=>Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SmTextWidget(text: "Reveal", size: 12, color: "#FFFFFF"),
          SmImageWidget(imageName: "play75",width: 20.w,height: 20.h,),
          SmTextWidget(text: "symbol,win shown prize", size: 12, color: "#FFFFFF"),
        ],
      ),
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SmTextWidget(text: "Reveal", size: 12, color: "#FFFFFF"),
          SmImageWidget(imageName: "play76",width: 20.w,height: 20.h,),
          SmTextWidget(text: "symbol,win the double prize", size: 12, color: "#FFFFFF"),
        ],
      ),
    ],
  );
  _goldWidget()=>GetBuilder<Play7Controller>(
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