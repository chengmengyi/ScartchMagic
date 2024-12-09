import 'package:flutter/material.dart';
import 'package:magic_base/base_widget/sm_base_widget.dart';
import 'package:magic_base/base_widget/sm_text_widget.dart';
import 'package:magic_base/utils/sm_export.dart';
import 'package:magic_base/utils/sm_extension.dart';
import 'package:magic_normal/page/widget/play_fail_widget/play_fail_widget_controller.dart';

class PlayFailWidget extends SmBaseWidget<PlayFailController>{
  double width;
  double height;
  BorderRadiusGeometry? borderRadius;
  // Function() timeOut;
  PlayFailWidget({
    required this.width,
    required this.height,
    this.borderRadius,
    // required this.timeOut,
  });

  @override
  PlayFailController setController() => PlayFailController();

  // @override
  // initView() {
  //   smController.timeOut=timeOut;
  // }
  
  @override
  Widget contentWidget() => WillPopScope(
    child: Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: borderRadius??BorderRadius.circular(2.w),
          color: "#000000".toSmColor().withOpacity(0.6)
      ),
      child: SmTextWidget(text: "No wins，please try again", size: 16.sp, color: "#FFFFFF"),
    ),
    onWillPop: ()async{
      return false;
    },
  );
}