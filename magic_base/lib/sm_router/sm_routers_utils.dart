import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SmRoutersUtils{
  factory SmRoutersUtils()=>_getInstance();
  static SmRoutersUtils get instance => _getInstance();
  static SmRoutersUtils? _instance;
  static SmRoutersUtils _getInstance(){
    _instance??=SmRoutersUtils._internal();
    return _instance!;

  }

  SmRoutersUtils._internal();

  toNextPage({required String routersName,Map<String, dynamic>? arguments,Function(Map<String,dynamic>)? backCall})async{
    var result=await Get.toNamed(routersName,arguments: arguments);
    if(null!=result&&null!=backCall){
      backCall.call(result);
    }
  }

  toNextPageAndOffCurrent({required String routersName}){
    Get.offNamed(routersName);
  }

  offPage({Map<String,dynamic>? params}) {
    Get.back(result: params);
  }

  showDialog({required Widget widget,dynamic arguments, bool? barrierDismissible, Color? barrierColor}){
    Get.dialog(
      widget,
      arguments: arguments,
      barrierColor: barrierColor,
      barrierDismissible: barrierDismissible ?? false,
    );
  }

  Map<String, dynamic> getParams() {
    try {
      return Get.arguments as Map<String, dynamic>;
    } catch (e) {
      return {};
    }
  }
}