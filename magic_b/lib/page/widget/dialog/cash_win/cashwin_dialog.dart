import 'package:flutter/material.dart';
import 'package:magic_b/page/widget/dialog/cash_win/cashwin_controller.dart';
import 'package:magic_base/base_widget/sm_base_dialog.dart';
import 'package:magic_base/base_widget/sm_gradient_text_widget.dart';
import 'package:magic_base/base_widget/sm_image_widget.dart';
import 'package:magic_base/base_widget/sm_text_widget.dart';
import 'package:magic_base/utils/sm_export.dart';
import 'package:magic_base/utils/sm_extension.dart';

class CashwinDialog extends SmBaseDialog<CashwinController>{
  int addNum;
  Function(int addNum) dismissDialog;
  CashwinDialog({
    required this.addNum,
    required this.dismissDialog,
  });

  @override
  CashwinController setController() => CashwinController();

  @override
  Widget contentWidget() => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _rewardWidget(),
        SizedBox(height: 30.h,),
        _bottomWidget(),
      ]
  );

  _rewardWidget()=>Stack(
    alignment: Alignment.bottomCenter,
    children: [
      SmImageWidget(imageName: "cashwin",width: 280.w,height: 192.h,),
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Lottie.asset("magic_file/magic_lottie/cashwin.json",height: 160.h,fit: BoxFit.fitHeight),
          Stack(
            alignment: Alignment.center,
            children: [
              SmImageWidget(imageName: "incent4",width: 240.w,height: 60.h,),
              Container(
                margin: EdgeInsets.only(bottom: 6.h),
                child: SmGradientTextWidget(
                  text: "\$$addNum",
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
        ],
      )
    ],
  );

  _bottomWidget()=>InkWell(
    onTap: (){
      smController.clickSingle(addNum, dismissDialog);
    },
    child: SizedBox(
      width: 208.w,
      height: 56.h,
      child: Stack(
        children: [
          SmImageWidget(imageName: "btn",width: 208.w,height: 56.h,),
          Align(
            alignment: Alignment.center,
            child: SmTextWidget(text: "\$$addNum", size: 18.sp, color: "#FFFFFF",fontWeight: FontWeight.w700,),
          ),
        ],
      ),
    ),
  );
}