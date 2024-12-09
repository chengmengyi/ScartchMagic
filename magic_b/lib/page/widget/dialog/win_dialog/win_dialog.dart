import 'package:flutter/material.dart';
import 'package:magic_base/base_widget/sm_base_dialog.dart';
import 'package:magic_base/base_widget/sm_image_widget.dart';
import 'package:magic_base/base_widget/sm_text_widget.dart';
import 'package:magic_base/sm_router/sm_routers_utils.dart';
import 'package:magic_base/utils/sm_export.dart';
import 'package:magic_base/utils/sm_extension.dart';
import 'package:magic_b/page/widget/dialog/win_dialog/win_dialog_controller.dart';

class WinDialog extends SmBaseDialog<WinDialogController>{
  int addNum;
  Function() timeOut;
  WinDialog({
    required this.addNum,
    required this.timeOut,
  });

  @override
  WinDialogController setController() => WinDialogController();

  @override
  initView() {
    smController.timeOut=timeOut;
  }

  @override
  Widget contentWidget() => Stack(
    alignment: Alignment.topCenter,
    children: [
      Container(
        margin: EdgeInsets.only(top: 60.h),
        child: Stack(
          alignment: Alignment.center,
          children: [
            SmImageWidget(imageName: "win1",width: 276.w,height: 164.h,),
            SmTextWidget(
              text: "$addNum",
              size: 24.sp,
              color: "#FFFB04",
              fontWeight: FontWeight.w600,
              shadows: [
                Shadow(
                    color: "#690800".toSmColor(),
                    blurRadius: 2.w,
                    offset: Offset(0,0.5.w)
                )
              ],
            )
          ],
        ),
      ),
      SmImageWidget(imageName: "win2",width: 224.w,height: 100.h,),
    ],
  );
}