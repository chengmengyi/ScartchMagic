import 'package:flutter/material.dart';
import 'package:magic_b/page/widget/dialog/incent/incent_controller.dart';
import 'package:magic_b/page/widget/watch_video_btn_widget/watch_video_btn_widget.dart';
import 'package:magic_base/base_widget/sm_base_dialog.dart';
import 'package:magic_base/base_widget/sm_gradient_text_widget.dart';
import 'package:magic_base/base_widget/sm_image_widget.dart';
import 'package:magic_base/base_widget/sm_text_widget.dart';
import 'package:magic_base/utils/sm_export.dart';
import 'package:magic_base/utils/sm_extension.dart';

class IncentDialog extends SmBaseDialog<IncentController>{
  int money;
  Function(int addNum) dismissDialog;
  IncentDialog({
    required this.money,
    required this.dismissDialog,
});

  @override
  IncentController setController() => IncentController();

  @override
  Widget contentWidget() => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      _rewardWidget(),
      SizedBox(height: 10.h,),
      _bottomWidget(),
    ]
  );

  _rewardWidget()=>Stack(
    alignment: Alignment.center,
    children: [
      SmImageWidget(imageName: "incent1",width: 320.w,height: 320.h,),
      SmImageWidget(imageName: "incent2",width: 290.w,height: 290.h,),
      Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SmImageWidget(imageName: "incent3",width: 280.w,height: 192.h,),
          Container(
            margin: EdgeInsets.only(bottom: 6.h),
            child: SmGradientTextWidget(
              text: "\$$money",
              size: 32.sp,
              fontWeight: FontWeight.w700,
              colors: ["#FFFB04".toSmColor(),"#FF7B00".toSmColor()],
              shadows: [
                Shadow(
                    color: "#690800".toSmColor(),
                    blurRadius: 2.w,
                    offset: Offset(0,0.5.w)
                )
              ],
            ),
          )
        ],
      )
    ],
  );

  _bottomWidget()=>Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      WatchVideoBtnWidget(
        money: money,
        onTap: (){
          smController.clickDouble(money, dismissDialog);
        },
      ),
      SizedBox(height: 8.h,),
      InkWell(
        onTap: (){
          smController.clickSingle(money, dismissDialog);
        },
        child: SmTextWidget(
          text: "\$$money",
          size: 14.sp,
          color: "#FFFFFF",
          fontWeight: FontWeight.w700,
        ),
      )
    ],
  );
}