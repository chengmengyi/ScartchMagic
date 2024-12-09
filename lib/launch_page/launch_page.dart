import 'package:flutter/material.dart';
import 'package:magic_base/base_widget/sm_base_page.dart';
import 'package:magic_base/base_widget/sm_image_widget.dart';
import 'package:magic_base/base_widget/sm_text_widget.dart';
import 'package:magic_base/utils/sm_export.dart';
import 'package:scratch_magic/launch_page/launch_page_controller.dart';

class LaunchPage extends SmBasePage<LaunchPageController>{
  @override
  String backgroundName() => "launch_bg";

  @override
  LaunchPageController setController() => LaunchPageController();

  @override
  Widget? topTitleWidget() => null;

  @override
  Widget contentWidget() => Column(
    children: [
      _logoWidget(),
      const Spacer(),
      _progressWidget(),
      SizedBox(height: 120.h,),
    ],
  );

  _logoWidget()=>Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      SizedBox(height: 120.h,),
      SmImageWidget(imageName: "logo",width: 140.w,height: 140.h,),
      SmTextWidget(text: "Scratch Magic", size: 16.sp, color: "#FFFFFF",fontWeight: FontWeight.w600,),
    ],
  );

  _progressWidget()=>Stack(
    alignment: Alignment.centerLeft,
    children: [
      SmImageWidget(imageName: "pro_bg",width: 180.w,height: 12.h,),
      Container(
        margin: EdgeInsets.only(left: 2.w,right: 2.w),
        child: GetBuilder<LaunchPageController>(
          id: "progress",
          builder: (_)=>ClipRect(
            child: Align(
              alignment: Alignment.centerLeft,
              widthFactor: smController.controller.value,
              child: SmImageWidget(imageName: "pro_sel",width: 176.w,height: 8.h,),
            ),
          ),
        ),
      )
    ],
  );
}