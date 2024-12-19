import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:magic_base/base_widget/sm_base_controller.dart';

abstract class SmBaseWidget<T extends SmBaseController> extends StatelessWidget{
  late T smController;

  @override
  Widget build(BuildContext context) {
    smController=Get.put(setController());
    smController.smContext=context;
    return contentWidget();
  }

  T setController();

  Widget contentWidget();
}