import 'package:flutter/material.dart';
import 'package:magic_b/utils/b_ad/show_ad_utils.dart';
import 'package:magic_b/utils/local_notification/local_notification_utils.dart';
import 'package:magic_base/base_widget/sm_base_controller.dart';
import 'package:magic_base/sm_router/all_routers_name.dart';
import 'package:magic_base/sm_router/sm_routers_utils.dart';
import 'package:magic_base/utils/b_ad/load_ad.dart';
import 'package:magic_base/utils/check_user/check_user_utils.dart';
import 'package:magic_base/utils/sm_export.dart';

class LaunchPageController extends SmBaseController with GetSingleTickerProviderStateMixin{
  late AnimationController controller;
  late Animation animation;

  @override
  void onInit() {
    super.onInit();
    controller=AnimationController(duration: const Duration(seconds: 12),vsync: this)..addListener(() {
      update(["progress"]);
    })..addStatusListener((status) {
      if(status==AnimationStatus.completed){
        _checkUser();
      }
    });
    animation=Tween<double>(begin: 0,end: 1).chain(CurveTween(curve: Curves.ease)).animate(controller);
    LocalNotificationUtils.instance.checkFromNotificationLaunchApp();
  }

  @override
  void onReady() {
    super.onReady();
    controller.forward();
  }

  _checkUser(){
    CheckUserUtils.instance.checkUser();
    if(CheckUserUtils.instance.buyUser){
      ShowAdUtils.instance.showOpen(
        closeAd: (){
          _toHomePage();
        },
      );
    }else{
      _toHomePage();
    }
  }

  _toHomePage(){
    SmRoutersUtils.instance.toNextPageAndOffCurrent(routersName: CheckUserUtils.instance.buyUser?AllRoutersName.homePageB:AllRoutersName.homePageA);
  }

  @override
  void onClose() {
    super.onClose();
    controller.dispose();
  }
}