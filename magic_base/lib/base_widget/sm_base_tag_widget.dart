import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:magic_base/base_widget/sm_base_controller.dart';

abstract class SmBaseTagWidget<T extends SmBaseController> extends StatelessWidget{
  late T smController;

  @override
  Widget build(BuildContext context) {
    var c = setController();
    var tag = controllerTag();
    Get.put(c,tag: tag);
    smController=Get.find<T>(tag: tag);
    smController.smContext=context;
    initView();
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: contentWidget(),
    );
  }

  T setController();

  String controllerTag();

  Widget contentWidget();

  initView(){}
}