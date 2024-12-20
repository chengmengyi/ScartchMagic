import 'package:flutter/material.dart';
import 'package:magic_b/page/page/home/child/card/card_child.dart';
import 'package:magic_b/page/page/home/child/cash/cash_child.dart';
import 'package:magic_b/page/page/home/child/wheel/wheel_child.dart';
import 'package:magic_b/page/page/home/home/home_bottom_bean.dart';
import 'package:magic_b/utils/b_storage/b_storage_hep.dart';
import 'package:magic_b/utils/info_hep.dart';
import 'package:magic_b/utils/local_notification/local_notification_utils.dart';
import 'package:magic_base/base_widget/sm_base_controller.dart';
import 'package:magic_base/utils/event/event_code.dart';
import 'package:magic_base/utils/event/event_info.dart';
import 'package:magic_base/utils/tba/ad_pos.dart';
import 'package:magic_base/utils/tba/tba_utils.dart';
import 'package:magic_base/utils/voice/voice_utils.dart';

class HomeController extends SmBaseController{
  var tabIndex=0,_startedWheel=false,wheelChance=0;
  List<HomeBottomBean> bottomList=[
    HomeBottomBean(unsIcon: "card_uns", selIcon: "card_sel", text: "Card"),
    HomeBottomBean(unsIcon: "wheel_uns", selIcon: "wheel_sel", text: "Wheel"),
    HomeBottomBean(unsIcon: "cash_uns", selIcon: "cash_sel", text: "Cash"),
  ];
  List<Widget> pageList=[CardChild(),WheelChild(home: true,),CashChild(home: true,)];

  @override
  void onInit() {
    super.onInit();
    wheelChance=wheelChanceNum.read();
  }

  @override
  void onReady() {
    super.onReady();
    LocalNotificationUtils.instance.initLocalNotification();
    VoiceUtils.instance.playBgMp3();
    InfoHep.instance.notFirstLaunchAppShowCommentDialog();
    LocalNotificationUtils.instance.checkClickNotificationShowTab();
  }

  clickTab(index,{fromOldUser=false}){
    if(index==tabIndex||_startedWheel){
      return;
    }
    if(index==0){
      TbaUtils.instance.pointEvent(pointType: PointType.sm_home_page);
    }
    if(index==1){
      TbaUtils.instance.pointEvent(pointType: PointType.sm_wheel_c,data: {"source_from":"home"});
      TbaUtils.instance.pointEvent(pointType: PointType.sm_wheel_page,data: {"source_from":fromOldUser?"oldpop":"home"});
    }
    if(index==2){
      TbaUtils.instance.pointEvent(pointType: PointType.sm_cash_page);
    }
    tabIndex=index;
    update(["page"]);
  }

  @override
  bool smRegisterEvent() => true;

  @override
  smEventReceived(EventInfo eventInfo) {
    switch(eventInfo.eventCode){
      case EventCode.showWheelTab:
        clickTab(1,fromOldUser: true);
        break;
      case EventCode.startOrStopWheel:
        _startedWheel=eventInfo.boolValue??false;
        break;
      case EventCode.updateHomeTabIndex:
        clickTab(eventInfo.intValue??0);
        break;
      case EventCode.keyAnimatorEnd:
        wheelChance=wheelChanceNum.read();
        update(["bottom"]);
        break;
    }
  }


}