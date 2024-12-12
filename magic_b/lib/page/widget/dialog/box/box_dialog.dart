import 'package:flutter/material.dart';
import 'package:magic_b/page/widget/dialog/box/box_controller.dart';
import 'package:magic_b/page/widget/watch_video_btn_widget/watch_video_btn_widget.dart';
import 'package:magic_base/base_widget/sm_base_dialog.dart';
import 'package:magic_base/base_widget/sm_gradient_text_widget.dart';
import 'package:magic_base/base_widget/sm_text_widget.dart';
import 'package:magic_base/utils/sm_export.dart';
import 'package:magic_base/utils/sm_extension.dart';

class BoxDialog extends SmBaseDialog<BoxController>{
  @override
  BoxController setController() => BoxController();

  @override
  Widget contentWidget() => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      SmGradientTextWidget(
        text: "Congratulation",
        size: 24.sp,
        fontWeight: FontWeight.w700,
        colors: ["#FCFEFF".toSmColor(),"#FBE40A".toSmColor()],
      ),
      SmTextWidget(text: "+\$${smController.reward}", size: 32.sp, color: "#FFE646",fontWeight: FontWeight.bold,),
      WatchVideoBtnWidget(
        text: "Claim \$${smController.reward*2}",
        onTap: (){
          smController.clickDouble();
        },
      ),
      SizedBox(height: 4.h,),
      InkWell(
        onTap: (){
          smController.clickSingle();
        },
        child: SmTextWidget(
          text: "\$${smController.reward}",
          size: 14.sp,
          color: "#FFFFFF",
          fontWeight: FontWeight.bold,
          withOpacity: 0.6,
        ),
      )
    ],
  );
}