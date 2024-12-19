import 'package:flutter/material.dart';
import 'package:magic_b/page/widget/btn_widget/btn_widget.dart';
import 'package:magic_b/page/widget/dialog/no_money/no_money_controller.dart';
import 'package:magic_base/base_widget/sm_base_dialog.dart';
import 'package:magic_base/base_widget/sm_gradient_text_widget.dart';
import 'package:magic_base/base_widget/sm_image_widget.dart';
import 'package:magic_base/base_widget/sm_text_widget.dart';
import 'package:magic_base/utils/sm_export.dart';
import 'package:magic_base/utils/sm_extension.dart';

class NoMoneyDialog extends SmBaseDialog<NoMoneyController>{
  @override
  NoMoneyController setController() => NoMoneyController();

  @override
  Widget contentWidget() => Container(
    width: double.infinity,
    height: 208.h,
    margin: EdgeInsets.only(left: 36.w,right: 36.w),
    child: Stack(
      alignment: Alignment.center,
      children: [
        SmImageWidget(imageName: "no_money1",width: double.infinity,height: 208.h, boxFit: BoxFit.fill,),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SmGradientTextWidget(
              text: "Insufficient balance",
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
            SizedBox(height: 10.h,),
            Container(
              margin: EdgeInsets.only(left: 24.w,right: 24.w),
              child: SmTextWidget(text: "Your account balance is insufficient and withdrawal is temporarily unavailable.Go and earn cash！", size: 14.sp, color: "#FFFFFF",textAlign: TextAlign.center,),
            ),
            SizedBox(height: 10.h,),
            InkWell(
              onTap: (){
                smController.clickEarn();
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SmImageWidget(imageName: "btn3",width: 200.w,height: 36.h,boxFit: BoxFit.fill,),
                  SmTextWidget(
                    text: "Earn More Cash",
                    size: 16.sp,
                    color: "#FFFFFF",
                    shadows: [
                      Shadow(
                          color: "#825400".toSmColor(),
                          blurRadius: 2.w,
                          offset: Offset(0,0.5.w)
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),

      ],
    ),
  );
}