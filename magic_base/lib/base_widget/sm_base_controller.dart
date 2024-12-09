import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:magic_base/utils/event/event_info.dart';

abstract class SmBaseController extends GetxController{
  late BuildContext smContext;
  int _counter = 0;
  late StreamSubscription<EventInfo>? _ss;

  @override
  void onInit() {
    super.onInit();
    if(smRegisterEvent()){
      _ss=eventBus.on<EventInfo>().listen((event) {
        smEventReceived(event);
      });
    }
    _incrementCounter();
    _decrementCounter();
  }

  bool smRegisterEvent()=>false;

  smEventReceived(EventInfo eventInfo){

  }

  void _incrementCounter() {
    _counter++;
  }

  void _decrementCounter() {
    _counter--;
  }

  @override
  void onClose() {
    super.onClose();
    if(smRegisterEvent()){
      _ss?.cancel();
    }
  }
}