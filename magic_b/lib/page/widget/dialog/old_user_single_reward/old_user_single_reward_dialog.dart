import 'package:flutter/material.dart';
import 'package:magic_b/page/widget/dialog/old_user_single_reward/old_user_single_reward_controller.dart';
import 'package:magic_b/page/widget/watch_video_btn_widget/watch_video_btn_widget.dart';
import 'package:magic_base/base_widget/sm_base_dialog.dart';
import 'package:magic_base/base_widget/sm_gradient_text_widget.dart';
import 'package:magic_base/base_widget/sm_image_widget.dart';
import 'package:magic_base/base_widget/sm_text_widget.dart';
import 'package:magic_base/utils/sm_export.dart';
import 'package:magic_base/utils/sm_extension.dart';

class OldUserSingleRewardDialog extends SmBaseDialog<OldUserSingleRewardController>{
  int signReward;
  OldUserSingleRewardDialog({
    required this.signReward,
});

  @override
  OldUserSingleRewardController setController() => OldUserSingleRewardController();

  @override
  Widget contentWidget() => Container(
    width: double.infinity,
    height: 360.h,
    margin: EdgeInsets.only(left: 36.w,right: 36.w),
    child: Stack(
      alignment: Alignment.center,
      children: [
        SmImageWidget(imageName: "old3",width: double.infinity,height: 360.h,boxFit: BoxFit.fill,),
        Align(
          alignment: Alignment.topRight,
          child: InkWell(
            onTap: (){
              smController.clickClose();
            },
            child: SmImageWidget(imageName: "close",width: 32.w,height: 32.h,),
          ),
        ),
        _contentWidget(),
      ],
    ),
  );

  _contentWidget()=>Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      SmGradientTextWidget(
        text: "Daily Bonus",
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
      Container(
        margin: EdgeInsets.only(left: 16.w,right: 16.w),
        child: SmTextWidget(text: "Come back tomorrow to claim the 5x reward", size: 14.sp, color: "#FFFFFF",textAlign: TextAlign.center,),
      ),
      SizedBox(height: 16.h,),
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SmImageWidget(imageName: "old4",width: 80.w,height: 80.w,),
          SizedBox(height: 4.h,),
          SmTextWidget(text: "Daily check reward", size: 10.sp, color: "#FFFFFF"),
          SizedBox(height: 4.h,),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SmImageWidget(imageName: "b_coins",width: 20.w,height: 20.w,),
              SizedBox(width: 3.w,),
              SmTextWidget(text: "+\$$signReward", size: 16.sp, color: "#FFE646",fontWeight: FontWeight.bold,)
            ],
          )
        ],
      ),
      SizedBox(height: 20.h,),
      WatchVideoBtnWidget(
        text: "Double Claim",
        onTap: (){
          smController.clickDouble(signReward);
        },
      ),
      SizedBox(height: 4.h,),
      InkWell(
        onTap: (){
          smController.clickSingle(signReward);
        },
        child: SmTextWidget(text: "Claim", size: 14.sp, color: "#FFFFFF",fontWeight: FontWeight.bold,),
      )
    ],
  );
}