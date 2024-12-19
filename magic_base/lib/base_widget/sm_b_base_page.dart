import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:magic_base/base_widget/sm_base_controller.dart';
import 'package:magic_base/base_widget/sm_image_widget.dart';

abstract class SmBaseBPage<T extends SmBaseController> extends StatelessWidget{
  late T smController;

  @override
  Widget build(BuildContext context) {
    smController=Get.put(setController());
    smController.smContext=context;
    return Scaffold(
      body: contentWidget(),
      resizeToAvoidBottomInset: false,
    );
  }

  T setController();

  Widget contentWidget();
}