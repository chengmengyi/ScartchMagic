import 'package:flutter/material.dart';
import 'package:magic_b/page/page/play/play_child/play_tiger/play_tiger_child_controller.dart';
import 'package:magic_base/base_widget/sm_base_widget.dart';
import 'package:magic_base/base_widget/sm_gradient_text_widget.dart';
import 'package:magic_base/base_widget/sm_image_widget.dart';
import 'package:magic_base/base_widget/sm_stroke_text_widget.dart';
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

class PlayTigerChild extends SmBaseWidget<PlayTigerChildController>{

  @override
  PlayTigerChildController setController() => PlayTigerChildController();

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
        SmImageWidget(imageName: "tiger1",width: double.infinity,height: double.infinity,boxFit: BoxFit.fill,),
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            margin: EdgeInsets.only(top: 4.h),
            child: WinUpWidget(playType: PlayType.playtiger,),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _tigerAndWinWidget(),
              SizedBox(height: 4.h,),
              _findPrizeWidget(),
              _scratcherWidget(),
            ],
          ),
        )
      ],
    ),
  );

  _tigerAndWinWidget()=>Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      SmStrokeTextWidget(
        text: "Find Tiger",
        fontSize: 20.sp,
        textColor: Colors.white,
        strokeColor: "#370000".toSmColor(),
        fontWeight: FontWeight.w400,
      ),
      SizedBox(width: 4.w,),
      SmImageWidget(imageName: "tiger6",width: 24.w,height: 24.h,),
      SizedBox(width: 4.w,),
      SmStrokeTextWidget(
        text: "And Win",
        fontSize: 20.sp,
        textColor: Colors.white,
        strokeColor: "#370000".toSmColor(),
        fontWeight: FontWeight.w400,
      ),
    ],
  );

  _findPrizeWidget()=>Container(
    width: double.infinity,
    height: 108.h,
    margin: EdgeInsets.only(left: 20.w,right: 20.w),
    child: Stack(
      alignment: Alignment.topCenter,
      children: [
        SmImageWidget(imageName: "tiger5",width: double.infinity,height: double.infinity,boxFit: BoxFit.fill,),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 8.h,),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SmGradientTextWidget(
                  text: "Find",
                  size: 20.sp,
                  colors: [
                    "#FFD85A".toSmColor(),
                    "#FF9E17".toSmColor(),
                  ],
                  fontWeight: FontWeight.w400,
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                SizedBox(width: 2.w,),
                SmStrokeTextWidget(
                  text: "Prize",
                  fontSize: 20.sp,
                  textColor: Colors.white,
                  strokeColor: "#370000".toSmColor(),
                  fontWeight: FontWeight.w400,
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(left: 14.w,right: 14.w),
              child: GetBuilder<PlayTigerChildController>(
                id: "prize_list",
                builder: (_)=>StaggeredGridView.countBuilder(
                  padding: const EdgeInsets.all(0),
                  itemCount: smController.prizeList.length,
                  shrinkWrap: true,
                  crossAxisCount: 7,
                  mainAxisSpacing: 0.h,
                  crossAxisSpacing: 0.w,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context,index){
                    var bean = smController.prizeList[index];
                    return Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.w),
                          border: smController.prizeBorderIndex==bean.num?Border.all(
                              width: 1.w,
                              color: "#F9DF02".toSmColor()
                          ):null
                      ),
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          SmStrokeTextWidget(
                            text: "${bean.num}",
                            fontSize: 20.sp,
                            textColor: "#F9DF02".toSmColor(),
                            strokeColor: "#000000".toSmColor(),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 20.h),
                            child: SmStrokeTextWidget(
                              text: "x${bean.multiple}",
                              fontSize: 12.sp,
                              textColor: "#FFFFFF".toSmColor(),
                              strokeColor: "#000000".toSmColor(),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 33.h),
                            child: SmStrokeTextWidget(
                              text: "Bet",
                              fontSize: 12.sp,
                              textColor: "#FFFFFF".toSmColor(),
                              strokeColor: "#000000".toSmColor(),
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
          ],
        )
      ],
    ),
  );

  _scratcherWidget()=>Container(
    width: double.infinity,
    height: 192.h,
    key: smController.globalKey,
    margin: EdgeInsets.only(left: 20.w,right: 20.w,bottom: 26.h),
    child: Stack(
      children: [
        Scratcher(
          key: smController.key,
          enabled: true,
          brushSize: 40,
          threshold: 70,
          color: Colors.transparent,
          image: Image.asset('magic_file/magic_image/tiger2.webp',fit: BoxFit.fill,),
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
                SmImageWidget(imageName: "tiger3",width: double.infinity,height: double.infinity, boxFit: BoxFit.fill,),
                Container(
                  margin: EdgeInsets.only(left: 12.w,right: 12.w),
                  child: GetBuilder<PlayTigerChildController>(
                    id: "your_list",
                    builder: (_)=>StaggeredGridView.countBuilder(
                      padding: const EdgeInsets.all(0),
                      itemCount: smController.yourList.length,
                      shrinkWrap: true,
                      crossAxisCount: 4,
                      mainAxisSpacing: 8.h,
                      crossAxisSpacing: 26.w,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context,index){
                        var bean = smController.yourList[index];
                        return bean.hasKey==true?
                        (smController.hideKeyIcon?
                        SizedBox(
                          width: 52.w,
                          height: 52.h,
                        ):
                        Lottie.asset("magic_file/magic_lottie/key.json",width: 52.w,height: 52.h,key: smController.keyGlobalKey)):
                        Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            SmImageWidget(imageName: bean.icon,width: 52.w,height: 52.w,),
                            Offstage(
                              offstage: bean.reward==0,
                              child: SmGradientTextWidget(
                                text: "${bean.reward}",
                                size: 16.sp,
                                fontWeight: FontWeight.w400,
                                colors: ["#F9DF02".toSmColor(),"#EF8000".toSmColor()],
                                shadows: [
                                  Shadow(
                                      color: "#221002".toSmColor(),
                                      blurRadius: 2.w,
                                      offset: Offset(0,2.w)
                                  )
                                ],
                              ),
                            ),
                            Visibility(
                              visible: smController.win&&bean.reward==0&&smController.prizeBorderIndex!=-1,
                              child: Container(
                                width: 52.w,
                                height: 52.w,
                                decoration: BoxDecoration(
                                    color: "#000000".toSmColor().withOpacity(0.6),
                                    borderRadius: BorderRadius.circular(26.w)
                                ),
                              ),
                            )
                          ],
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
        GetBuilder<PlayTigerChildController>(
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

  _goldWidget()=>GetBuilder<PlayTigerChildController>(
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