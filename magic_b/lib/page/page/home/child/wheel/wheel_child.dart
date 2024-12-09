import 'package:flutter/material.dart';
import 'package:magic_b/page/page/home/child/wheel/wheel_child_controller.dart';
import 'package:magic_base/base_widget/sm_base_tag_widget.dart';

class WheelChild extends SmBaseTagWidget<WheelChildController>{
  bool home;
  WheelChild({required this.home});

  @override
  String controllerTag() => "WheelChildController$home";

  @override
  WheelChildController setController() => WheelChildController();

  @override
  Widget contentWidget() => Column(
    children: [

    ],
  );
}