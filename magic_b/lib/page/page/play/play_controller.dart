import 'package:flutter/material.dart';
import 'package:magic_b/page/page/home/child/cash/cash_child.dart';
import 'package:magic_b/page/page/home/child/wheel/wheel_child.dart';
import 'package:magic_b/page/page/home/home/home_bottom_bean.dart';
import 'package:magic_b/page/page/play/play_child/play_child.dart';
import 'package:magic_b/utils/b_sql/play_info_bean.dart';
import 'package:magic_b/utils/b_storage/b_storage_hep.dart';
import 'package:magic_b/utils/guide/guide_step.dart';
import 'package:magic_b/utils/guide/guide_utils.dart';
import 'package:magic_b/utils/local_notification/local_notification_utils.dart';
import 'package:magic_base/base_widget/sm_base_controller.dart';
import 'package:magic_base/sm_router/sm_routers_utils.dart';
import 'package:magic_base/utils/event/event_code.dart';
import 'package:magic_base/utils/event/event_info.dart';
import 'package:magic_base/utils/sm_export.dart';

class PlayController extends SmBaseController with GetTickerProviderStateMixin{
  var tabIndex=0,showCashFingerGuide=false,canClick=true,showMoneyLottie=false,_addNum=0;
  PlayType playType=PlayType.playfruit;
  List<HomeBottomBean> bottomList=[
    HomeBottomBean(unsIcon: "card_uns", selIcon: "card_sel", text: "Card"),
    HomeBottomBean(unsIcon: "wheel_uns", selIcon: "wheel_sel", text: "Wheel"),
    HomeBottomBean(unsIcon: "cash_uns", selIcon: "cash_sel", text: "Cash"),
  ];
  List<Widget> pageList=[WheelChild(home: false,),CashChild(home: false,)];
  late AnimationController moneyLottieController;

  @override
  void onInit() {
    super.onInit();
    var map = SmRoutersUtils.instance.getParams();
    playType=map["playType"];
    pageList.insert(0, PlayChild(playType: playType));
    LocalNotificationUtils.instance.playPageShowing=true;

    moneyLottieController=AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..addStatusListener((status) {
      if(status==AnimationStatus.completed){
        showMoneyLottie=false;
        moneyLottieController.stop();
        update(["money_lottie"]);
        EventInfo(eventCode: EventCode.updateCoins,intValue: _addNum);
      }
    });
  }

  @override
  void onReady() {
    super.onReady();
    print("kk===PlayController===onReady");
    GuideUtils.instance.checkGuide();
  }

  clickTab(index){
    if(!canClick){
      return;
    }
    if(index==tabIndex){
      return;
    }
    tabIndex=index;
    if(tabIndex==2&&showCashFingerGuide){
      showCashFingerGuide=false;
      update(["cashFingerGuide"]);
      GuideUtils.instance.updateGuideStep(GuideStep.showRevealAllFinger);
    }
    update(["page"]);
  }

  clickRevealAllFinger(){
    if(!canClick){
      return;
    }
    EventInfo(eventCode: EventCode.clickRevealAll);
  }

  @override
  bool smRegisterEvent() => true;

  @override
  smEventReceived(EventInfo eventInfo) {
    switch(eventInfo.eventCode){
      case EventCode.showCashFingerGuide:
        showCashFingerGuide=true;
        update(["cashFingerGuide"]);
        break;
      case EventCode.updatePlayPageTabIndex:
        clickTab(eventInfo.intValue??0);
        break;
      case EventCode.canClickOtherBtn:
        canClick=eventInfo.boolValue??true;
        break;
      case EventCode.showMoneyGetLottie:
        _addNum=eventInfo.intValue??0;
        showMoneyLottie=true;
        update(["money_lottie"]);
        moneyLottieController..reset()..forward();
        break;
    }
  }

  @override
  void onClose() {
    moneyLottieController.dispose();
    LocalNotificationUtils.instance.playPageShowing=false;
    super.onClose();
  }
}