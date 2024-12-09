import 'package:flutter/material.dart';
import 'package:magic_b/utils/b_sql/play_info_bean.dart';
import 'package:magic_b/utils/b_storage/b_storage_hep.dart';
import 'package:magic_b/utils/guide/guide_step.dart';
import 'package:magic_base/sm_router/all_routers_name.dart';
import 'package:magic_base/sm_router/sm_routers_utils.dart';
import 'package:magic_base/utils/event/event_code.dart';
import 'package:magic_base/utils/event/event_info.dart';

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

  checkGuide(){
    switch(currentGuideStep.read()){
      case GuideStep.showFirstPlayGuide:
        EventInfo(eventCode: EventCode.showFirstPlayGuide);
        break;
      case GuideStep.showFruitFingerGuide:
        SmRoutersUtils.instance.toNextPage(
          routersName: AllRoutersName.playB,
          arguments: {
            "showFruitFingerGuide":true,
            "playType":PlayType.playfruit,
          },
        );
        break;
    }
  }

  updateGuideStep(String step){
    currentGuideStep.write(step);
    checkGuide();
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