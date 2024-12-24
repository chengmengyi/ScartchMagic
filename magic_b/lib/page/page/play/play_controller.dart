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
import 'package:magic_b/utils/utils.dart';
import 'package:magic_base/base_widget/sm_base_controller.dart';
import 'package:magic_base/sm_router/sm_routers_utils.dart';
import 'package:magic_base/utils/event/event_code.dart';
import 'package:magic_base/utils/event/event_info.dart';
import 'package:magic_base/utils/sm_export.dart';
import 'package:magic_base/utils/tba/ad_pos.dart';
import 'package:magic_base/utils/tba/tba_utils.dart';

class PlayController extends SmBaseController with GetTickerProviderStateMixin{
  var tabIndex=0,showCashFingerGuide=false,wheelChance=0,canClick=true,showMoneyLottie=false,_addNum=0,showWheelFinger=false;
  PlayType playType=PlayType.playfruit;
  List<HomeBottomBean> bottomList=[
    HomeBottomBean(unsIcon: "card_sel", selIcon: "card_sel", text: "Card"),
    HomeBottomBean(unsIcon: "wheel_uns", selIcon: "wheel_sel", text: "Wheel"),
    HomeBottomBean(unsIcon: "cash_sel", selIcon: "cash_sel", text: "Cash"),
  ];
  List<Widget> pageList=[WheelChild(home: false,),CashChild(home: false,)];
  late AnimationController moneyLottieController;

  @override
  void onInit() {
    super.onInit();
    wheelChance=wheelChanceNum.read();
    var map = SmRoutersUtils.instance.getParams();
    playType=map["playType"];
    pageList.insert(0, PlayChild(playType: playType));
    LocalNotificationUtils.instance.playPageShowing=true;
    _pointCardShowEvent();
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
    showWheelFinger=false;
    update(["wheelFingerGuide"]);
    if(!canClick){
      return;
    }
    if(index==tabIndex){
      return;
    }
    if(index==0){
      _pointCardShowEvent();
    }
    if(index==1){
      TbaUtils.instance.pointEvent(pointType: PointType.sm_wheel_c,data: {"source_from":"detail"});
    }
    if(index==2){
      TbaUtils.instance.pointEvent(pointType: PointType.sm_cash_page);
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
      case EventCode.keyAnimatorEnd:
      case EventCode.reduceWheelChance:
        wheelChance=wheelChanceNum.read();
        showWheelFinger=wheelChance>0;
        update(["bottom","wheelFingerGuide"]);
        break;
    }
  }

  _pointCardShowEvent(){
    TbaUtils.instance.pointEvent(pointType: PointType.sm_card_detail_page,data: {"page_from":Utils.getSourceFromByPlayType(playType)});
  }

  @override
  void onClose() {
    moneyLottieController.dispose();
    LocalNotificationUtils.instance.playPageShowing=false;
    super.onClose();
  }
}