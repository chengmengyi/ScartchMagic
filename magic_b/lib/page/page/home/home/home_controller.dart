import 'package:flutter/material.dart';
import 'package:magic_b/page/page/home/child/card/card_child.dart';
import 'package:magic_b/page/page/home/child/cash/cash_child.dart';
import 'package:magic_b/page/page/home/child/wheel/wheel_child.dart';
import 'package:magic_b/page/page/home/home/home_bottom_bean.dart';
import 'package:magic_base/base_widget/sm_base_controller.dart';
import 'package:magic_base/utils/voice/voice_utils.dart';

class HomeController extends SmBaseController{
  var tabIndex=0;
  List<HomeBottomBean> bottomList=[
    HomeBottomBean(unsIcon: "card_uns", selIcon: "card_sel", text: "Card"),
    HomeBottomBean(unsIcon: "wheel_uns", selIcon: "wheel_sel", text: "Wheel"),
    HomeBottomBean(unsIcon: "cash_uns", selIcon: "cash_sel", text: "Cash"),
  ];
  List<Widget> pageList=[CardChild(),WheelChild(home: true,),CashChild(home: true,)];

  @override
  void onReady() {
    super.onReady();
    VoiceUtils.instance.playBgMp3();
  }

  clickTab(index){
    if(index==tabIndex){
      return;
    }
    tabIndex=index;
    update(["page"]);
  }
}