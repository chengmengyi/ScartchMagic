import 'package:flutter/material.dart';
import 'package:magic_base/base_widget/sm_base_dialog.dart';
import 'package:magic_base/base_widget/sm_gradient_text_widget.dart';
import 'package:magic_base/base_widget/sm_image_widget.dart';
import 'package:magic_base/base_widget/sm_text_widget.dart';
import 'package:magic_base/sm_router/sm_routers_utils.dart';
import 'package:magic_base/utils/sm_export.dart';
import 'package:magic_base/utils/sm_extension.dart';
import 'package:magic_b/page/widget/dialog/up_level_dialog/up_level_dialog_controller.dart';

class UpLevelDialog extends SmBaseDialog<UpLevelDialogController>{
  int addNum;
  int level;
  Function() call;
  UpLevelDialog({
    required this.addNum,
    required this.level,
    required this.call,
  });

  @override
  UpLevelDialogController setController() => UpLevelDialogController();

  @override
  Widget contentWidget() => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      SizedBox(
        width: 280.w,
        height: 195.h,
        child: Stack(
          children: [
            SmImageWidget(
              imageName: "up_level",
              width: 280.w,
              height: 195.h,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.only(bottom: 6.h),
                child: SmTextWidget(
                  text: "+$addNum",
                  size: 28.sp,
                  color: "#FFFFFF",
                  fontWeight: FontWeight.w700,
                  shadows: [
                    Shadow(
                        color: "#FFE465".toSmColor(),
                        blurRadius: 2.w,
                        offset: Offset(0,0.5.w)
                    )
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: EdgeInsets.only(top: 20.h),
                child: SmGradientTextWidget(
                  text: "$level",
                  size: 60.sp,
                  fontWeight: FontWeight.w800,
                  colors: ["#FFA43F".toSmColor(),"#FBF35A".toSmColor(),"#F68D1A".toSmColor()],
                ),
              ),
            )
          ],
        ),
      ),
      SizedBox(height: 40.h,),
      InkWell(
        onTap: (){
          SmRoutersUtils.instance.offPage();
          call.call();
        },
        child: SmImageWidget(imageName: "continue_btn",width: 208.w,height: 56.h,),
      )
    ],
  );
}