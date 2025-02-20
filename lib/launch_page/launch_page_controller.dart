import 'package:flutter/material.dart';
import 'package:magic_base/base_widget/sm_base_controller.dart';
import 'package:magic_base/sm_router/all_routers_name.dart';
import 'package:magic_base/sm_router/sm_routers_utils.dart';
import 'package:magic_base/utils/sm_export.dart';

class LaunchPageController extends SmBaseController with GetSingleTickerProviderStateMixin{
  late AnimationController controller;
  late Animation animation;

  @override
  void onInit() {
    super.onInit();
    controller=AnimationController(duration: const Duration(seconds: 3),vsync: this)..addListener(() {
      update(["progress"]);
    })..addStatusListener((status) {
      if(status==AnimationStatus.completed){
        SmRoutersUtils.instance.toNextPageAndOffCurrent(routersName: AllRoutersName.homePageA);
      }
    });
    animation=Tween<double>(begin: 0,end: 1).chain(CurveTween(curve: Curves.ease)).animate(controller);
  }

  @override
  void onReady() {
    super.onReady();
    controller.forward();
  }

  @override
  void onClose() {
    super.onClose();
    controller.dispose();
  }
}