import 'package:flutter/material.dart';
import 'package:magic_b/page/page/home/child/cash/cash_child_controller.dart';
import 'package:magic_base/base_widget/sm_base_tag_widget.dart';

class CashChild extends SmBaseTagWidget<CashChildController>{
  bool home;
  CashChild({required this.home});

  @override
  String controllerTag() => "CashChildController$home";

  @override
  CashChildController setController() => CashChildController();

  @override
  Widget contentWidget() => Column(
    children: [

    ],
  );
}