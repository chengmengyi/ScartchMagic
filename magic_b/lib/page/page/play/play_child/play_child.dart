import 'package:flutter/material.dart';
import 'package:magic_b/page/page/play/play_child/play_child_controller.dart';
import 'package:magic_b/utils/b_sql/play_info_bean.dart';
import 'package:magic_base/base_widget/sm_base_widget.dart';

class PlayChild extends SmBaseWidget<PlayChildController>{
  PlayType  playType;
  bool showFruitFingerGuide;
  PlayChild({
    required this.playType,
    required this.showFruitFingerGuide,
});
  @override
  PlayChildController setController() => PlayChildController();

  @override
  Widget contentWidget() {
    if(playType==PlayType.playfruit){
      return Container();
    }
    return Container();
  }
}