import 'package:flutter/material.dart';
import 'package:magic_b/page/widget/bubble/bubble_widget_controller.dart';
import 'package:magic_base/base_widget/sm_base_widget.dart';
import 'package:magic_base/base_widget/sm_image_widget.dart';
import 'package:magic_base/utils/sm_export.dart';

class BubbleWidget extends SmBaseWidget<BubbleWidgetController>{
  @override
  BubbleWidgetController setController() => BubbleWidgetController();

  @override
  Widget contentWidget() => SizedBox(
    width: double.infinity,
    height: double.infinity,
    child: Stack(
      children: [
        Positioned(
          child: SmImageWidget(imageName: "bubble",width: 64.w,height: 64.w,),
        )
      ],
    ),
  );
}