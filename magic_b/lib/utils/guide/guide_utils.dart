import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:magic_b/page/widget/dialog/old_user_dialog/old_user_dialog.dart';
import 'package:magic_b/page/widget/dialog/old_user_single_reward/old_user_single_reward_dialog.dart';
import 'package:magic_b/utils/b_sql/play_info_bean.dart';
import 'package:magic_b/utils/b_storage/b_storage_hep.dart';
import 'package:magic_b/utils/b_value/b_value_hep.dart';
import 'package:magic_b/utils/guide/guide_step.dart';
import 'package:magic_base/sm_router/all_routers_name.dart';
import 'package:magic_base/sm_router/sm_routers_utils.dart';
import 'package:magic_base/utils/event/event_code.dart';
import 'package:magic_base/utils/event/event_info.dart';
import 'package:magic_base/utils/sm_extension.dart';

class GuideUtils{
  factory GuideUtils()=>_getInstance();
  static GuideUtils get instance => _getInstance();
  static GuideUtils? _instance;
  static GuideUtils _getInstance(){
    _instance??=GuideUtils._internal();
    return _instance!;
  }

  GuideUtils._internal();

  OverlayEntry? _overlayEntry;

  checkGuide({bool checkOldGuide=false}){
    print("k====checkGuide=${currentGuideStep.read()}");

    switch(currentGuideStep.read()){
      case GuideStep.showFirstPlayGuide:
        EventInfo(eventCode: EventCode.showFirstPlayGuide);
        break;
      case GuideStep.showFruitFingerGuide:
        SmRoutersUtils.instance.toNextPage(
          routersName: AllRoutersName.playB,
          arguments: {
            "playType":PlayType.playfruit,
          },
        );
        break;
      case GuideStep.firstGetReward:

        break;
      case GuideStep.showCashFingerGuide:
        EventInfo(eventCode: EventCode.showCashFingerGuide);
        break;
      case GuideStep.showRevealAllFinger:
        EventInfo(eventCode: EventCode.showRevealAllFingerGuide);
        break;
      case GuideStep.showBubble:
        if(playedCardNum.read()>=3){
          EventInfo(eventCode: EventCode.showBubble);
        }
        if(checkOldGuide){
          _checkOldGuide();
        }
        break;
    }
  }

  _checkOldGuide(){
    if(getTodayTime()==newUserGuideCompletedTimer.read()){
      return;
    }
    var oldUserStep = _getOldUserStep();
    print("kkk==_checkOldGuide==${oldUserStep}");
    switch(oldUserStep){
      case OldGuideStep.showOldUserDialog:
        SmRoutersUtils.instance.showDialog(
          widget: OldUserDialog()
        );
        break;
      case OldGuideStep.showWheelTab:
        EventInfo(eventCode: EventCode.showWheelTab,boolValue: true);
        break;
      case OldGuideStep.showSingleRewardDialog:
        SmRoutersUtils.instance.showDialog(
            widget: OldUserSingleRewardDialog(signReward: BValueHep.instance.getSignReward())
        );
        break;
    }
  }

  updateGuideStep(String step){
    currentGuideStep.write(step);
    if(step==GuideStep.showBubble){
      newUserGuideCompletedTimer.write(getTodayTime());
    }
    checkGuide();
  }

  updateOldStep(String step){
    oldUserGuideStep.write("${getTodayTime()}_$step");
    _checkOldGuide();
  }

  clickRevealAll(){
    if(playedCardNum.read()==2&&currentGuideStep.read()==GuideStep.showRevealAllFinger){
      updateGuideStep(GuideStep.showBubble);
    }
  }

  String _getOldUserStep(){
    try{
      var s = oldUserGuideStep.read();
      var list = s.split("_");
      if(list.first==getTodayTime()){
        return list.last;
      }
      return OldGuideStep.showOldUserDialog;
    }catch(e){
      return OldGuideStep.showOldUserDialog;
    }
  }

  showOver({
    required BuildContext context,
    required Widget widget,
  }){
    _overlayEntry=OverlayEntry(builder: (_)=>widget);
    Overlay.of(context).insert(_overlayEntry!);
  }

  hideOver(){
    _overlayEntry?.remove();
    _overlayEntry=null;
  }
}