import 'package:flutter/material.dart';
import 'package:magic_b/page/widget/dialog/input_account/input_account_controller.dart';
import 'package:magic_base/base_widget/sm_base_dialog.dart';
import 'package:magic_base/base_widget/sm_gradient_text_widget.dart';
import 'package:magic_base/base_widget/sm_image_widget.dart';
import 'package:magic_base/base_widget/sm_text_widget.dart';
import 'package:magic_base/utils/sm_export.dart';
import 'package:magic_base/utils/sm_extension.dart';

class InputAccountDialog extends SmBaseDialog<InputAccountController>{
  int cashNum;
  Function(String account) dismiss;
  InputAccountDialog({
    required this.cashNum,
    required this.dismiss,
});

  @override
  InputAccountController setController() => InputAccountController();

  @override
  Widget contentWidget() => Container(
    width: double.infinity,
    height: 308.h,
    margin: EdgeInsets.only(left: 36.w,right: 36.w),
    child: Stack(
      alignment: Alignment.center,
      children: [
        SmImageWidget(imageName: "input1",width: double.infinity,height: 308.h, boxFit: BoxFit.fill,),
        Container(
          margin: EdgeInsets.only(left: 20.w,right: 20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _titleWidget(),
              _inputWidget(),
              _bottomWidget(),
            ],
          ),
        ),
      ],
    ),
  );

  _titleWidget()=>Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      SmGradientTextWidget(
        text: "Congratulations",
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
      SmTextWidget(text: "\$$cashNum", size: 36.sp, color: "#FFFFFF",fontWeight: FontWeight.w700,)
    ],
  );

  _inputWidget()=>Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SmTextWidget(text: "Confirm your account:", size: 12.sp, color: "#FF8E5E"),
      SizedBox(height: 6.h,),
      Container(
        width: double.infinity,
        height: 40.h,
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: "#2D090E".toSmColor(),
          borderRadius: BorderRadius.circular(8.w),
        ),
        child:  TextField(
          enabled: true,
          maxLength: 20,
          textAlign: TextAlign.center,
          controller: smController.textEditingController,
          keyboardType: TextInputType.number,
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.white,
          ),
          decoration: InputDecoration(
            counterText: '',
            isCollapsed: true,
            hintText: 'Please input your account',
            hintStyle: TextStyle(
              fontSize: 14.sp,
              color: "#836165".toSmColor(),
            ),
            border: InputBorder.none,
          ),
        ),
      )
    ],
  );

  _bottomWidget()=>Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      SizedBox(height: 12.h,),
      SmTextWidget(text: "Your cash will arrive in your account within 3-7 business days. \nPlease keep an eye on your account!", size: 12.sp, color: "#C29FA2",),
      SizedBox(height: 12.h,),
      InkWell(
        onTap: (){
          smController.clickCash(dismiss);
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            SmImageWidget(imageName: "btn3",width: 200.w,height: 36.h,boxFit: BoxFit.fill,),
            SmTextWidget(
              text: "Withdraw Now",
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
  );
}