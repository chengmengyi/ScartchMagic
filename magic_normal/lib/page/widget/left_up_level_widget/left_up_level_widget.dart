import 'package:flutter/material.dart';
import 'package:magic_base/base_widget/sm_base_widget.dart';
import 'package:magic_base/base_widget/sm_image_widget.dart';
import 'package:magic_base/base_widget/sm_text_widget.dart';
import 'package:magic_base/utils/sm_export.dart';
import 'package:magic_normal/page/widget/left_up_level_widget/left_up_level_controller.dart';

class LeftUpLevelWidget extends SmBaseWidget<LeftUpLevelController>{
  @override
  LeftUpLevelController setController() => LeftUpLevelController();

  @override
  Widget contentWidget() => Stack(
    alignment: Alignment.center,
    children: [
      SmImageWidget(imageName: "level_bg2",width: 238.w,height: 34.h,),
      GetBuilder<LeftUpLevelController>(
        id: "num",
        builder: (_)=>SmTextWidget(text: "Scratch ${smController.upLevelNum} cards left to level up", size: 14.sp, color: "#FFFFFF",fontWeight: FontWeight.w500,),
      ),
    ],
  );
}