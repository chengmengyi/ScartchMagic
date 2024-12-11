import 'package:flutter/material.dart';
import 'package:magic_b/page/widget/btn_widget/btn_widget.dart';
import 'package:magic_b/page/widget/dialog/old_user_dialog/old_user_controller.dart';
import 'package:magic_base/base_widget/sm_base_dialog.dart';
import 'package:magic_base/base_widget/sm_gradient_text_widget.dart';
import 'package:magic_base/base_widget/sm_image_widget.dart';
import 'package:magic_base/base_widget/sm_text_widget.dart';
import 'package:magic_base/utils/sm_export.dart';
import 'package:magic_base/utils/sm_extension.dart';

class OldUserDialog extends SmBaseDialog<OldUserController>{

  @override
  OldUserController setController() => OldUserController();

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
            SmTextWidget(text: "spin the wheel daily for prize!", size: 14.sp, color: "#FFFFFF"),
            SizedBox(height: 16.h,),
            SmImageWidget(imageName: "old2",width: 120.w,height: 120.h,),
            SizedBox(height: 16.h,),
            BtnWidget(
              text: "Spin",
              onTap: (){
                smController.clickSpin();
              },
            )
          ],
        )
      ],
    ),
  );
}