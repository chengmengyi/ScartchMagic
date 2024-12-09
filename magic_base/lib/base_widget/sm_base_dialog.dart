import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:magic_base/base_widget/sm_base_controller.dart';

abstract class SmBaseDialog<T extends SmBaseController> extends StatelessWidget{
  late T smController;

  @override
  Widget build(BuildContext context) {
    smController=Get.put(setController());
    smController.smContext=context;
    initView();
    return WillPopScope(
      child: Material(
        type: MaterialType.transparency,
        child: Center(
          child: contentWidget(),
        ),
      ),
      onWillPop: ()async{
        return false;
      },
    );
  }

  T setController();

  Widget contentWidget();

  initView(){}
}