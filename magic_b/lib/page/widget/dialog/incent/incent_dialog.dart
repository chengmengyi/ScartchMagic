import 'package:flutter/material.dart';
import 'package:magic_b/page/widget/dialog/incent/incent_controller.dart';
import 'package:magic_b/page/widget/watch_video_btn_widget/watch_video_btn_widget.dart';
import 'package:magic_base/base_widget/sm_base_dialog.dart';
import 'package:magic_base/base_widget/sm_gradient_text_widget.dart';
import 'package:magic_base/base_widget/sm_image_widget.dart';
import 'package:magic_base/base_widget/sm_text_widget.dart';
import 'package:magic_base/utils/sm_export.dart';
import 'package:magic_base/utils/sm_extension.dart';

enum IncentType{
  card,wheel,
}

class IncentDialog extends SmBaseDialog<IncentController>{
  IncentType incentType;
  int money;
  Function(int addNum) dismissDialog;
  IncentDialog({
    required this.incentType,
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
    alignment: Alignment.bottomCenter,
    children: [
      Lottie.asset("magic_file/magic_lottie/you_win.json",height: 300.h,fit: BoxFit.fitHeight),
      Container(
        margin: EdgeInsets.only(bottom: 80.h),
        child: Stack(
          alignment: Alignment.center,
          children: [
            SmImageWidget(imageName: "incent4",width: 240.w,height: 60.h,),
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
        ),
      )
    ],
  );

  _bottomWidget()=>Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      WatchVideoBtnWidget(
        text: "Claim \$${money*2}",
        onTap: (){
          smController.clickDouble(incentType,money, dismissDialog);
        },
      ),
      SizedBox(height: 8.h,),
      InkWell(
        onTap: (){
          smController.clickSingle(incentType,money, dismissDialog);
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