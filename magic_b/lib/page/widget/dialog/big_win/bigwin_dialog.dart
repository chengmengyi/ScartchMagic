import 'package:flutter/material.dart';
import 'package:magic_b/page/widget/dialog/big_win/bigwin_controller.dart';
import 'package:magic_b/page/widget/watch_video_btn_widget/watch_video_btn_widget.dart';
import 'package:magic_base/base_widget/sm_base_dialog.dart';
import 'package:magic_base/base_widget/sm_gradient_text_widget.dart';
import 'package:magic_base/base_widget/sm_image_widget.dart';
import 'package:magic_base/base_widget/sm_text_widget.dart';
import 'package:magic_base/utils/sm_export.dart';
import 'package:magic_base/utils/sm_extension.dart';

class BigwinDialog extends SmBaseDialog<BigwinController>{
  int addNum;
  Function(int addNum) dismissDialog;
  BigwinDialog({
    required this.addNum,
    required this.dismissDialog,
  });

  @override
  BigwinController setController() => BigwinController();

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
      Lottie.asset("magic_file/magic_lottie/big.json",height: 160.h,fit: BoxFit.fitHeight),
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
  );

  _bottomWidget()=>Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      WatchVideoBtnWidget(
        text: "Claim \$${addNum*2}",
        onTap: (){
          smController.clickDouble(addNum,dismissDialog);
        },
      ),
      SizedBox(height: 8.h,),
      InkWell(
        onTap: (){
          smController.clickSingle(addNum,dismissDialog);
        },
        child: SmTextWidget(
          text: "\$$addNum",
          size: 14.sp,
          color: "#FFFFFF",
          fontWeight: FontWeight.w700,
        ),
      )
    ],
  );
}