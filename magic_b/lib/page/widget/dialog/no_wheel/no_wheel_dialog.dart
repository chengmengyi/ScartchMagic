import 'package:flutter/material.dart';
import 'package:magic_b/page/widget/btn_widget/btn_widget.dart';
import 'package:magic_b/page/widget/dialog/no_wheel/no_wheel_controller.dart';
import 'package:magic_base/base_widget/sm_base_dialog.dart';
import 'package:magic_base/base_widget/sm_gradient_text_widget.dart';
import 'package:magic_base/base_widget/sm_image_widget.dart';
import 'package:magic_base/base_widget/sm_text_widget.dart';
import 'package:magic_base/utils/sm_export.dart';
import 'package:magic_base/utils/sm_extension.dart';

class NoWheelDialog extends SmBaseDialog<NoWheelController>{
  bool fromHome;
  NoWheelDialog({required this.fromHome});

  @override
  NoWheelController setController() => NoWheelController();

  @override
  Widget contentWidget() => Container(
    width: double.infinity,
    height: 264.h,
    margin: EdgeInsets.only(left: 36.w,right: 36.w),
    child: Stack(
      alignment: Alignment.center,
      children: [
        SmImageWidget(imageName: "old3",width: double.infinity,height: 264.h, boxFit: BoxFit.fill,),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SmGradientTextWidget(
              text: "Not Enough Keys to\nUnlock Spin",
              size: 24.sp,
              fontWeight: FontWeight.w700,
              textAlign: TextAlign.center,
              colors: ["#FFF6A9".toSmColor(),"#FFDF51".toSmColor()],
              shadows: [
                Shadow(
                    color: "#8E5602".toSmColor(),
                    blurRadius: 2.w,
                    offset: Offset(0,0.5.w)
                )
              ],
            ),
            SizedBox(height: 16.h,),
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                SmImageWidget(imageName: "wheel6",width: 80.w,height: 80.w,),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SmImageWidget(imageName: "wheel7",width: 24.w,height: 24.w,),
                    SmTextWidget(text: "x0", size: 12.sp, color: "#FFFFFF"),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16.h,),
            BtnWidget(
              text: "Find It",
              onTap: (){
                smController.clickFind(fromHome);
              },
            )
          ],
        ),

      ],
    ),
  );
}