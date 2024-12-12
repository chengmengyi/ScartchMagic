import 'package:flutter/material.dart';
import 'package:magic_b/page/widget/dialog/box/box_dialog.dart';
import 'package:magic_b/utils/b_storage/b_storage_hep.dart';
import 'package:magic_b/utils/guide/box_guide_overlay.dart';
import 'package:magic_b/utils/guide/guide_utils.dart';
import 'package:magic_base/base_widget/sm_base_controller.dart';
import 'package:magic_base/sm_router/sm_routers_utils.dart';
import 'package:magic_base/utils/event/event_code.dart';
import 'package:magic_base/utils/event/event_info.dart';
import 'package:magic_base/utils/sm_extension.dart';

class PlayChildController extends SmBaseController{
  var showBubble=false,currentBox=currentBoxProgress.read();
  GlobalKey boxGlobalKey=GlobalKey();

  clickBox(){
    var current = currentBoxProgress.read();
    if(current<5){
      showToast("${5-current} scratch cards left to complete");
      return;
    }
    SmRoutersUtils.instance.showDialog(widget: BoxDialog());
  }

  @override
  bool smRegisterEvent() => true;

  @override
  smEventReceived(EventInfo eventInfo) {
    switch(eventInfo.eventCode){
      case EventCode.showBubble:
        showBubble=true;
        update(["showBubble"]);
        break;
      case EventCode.updateBoxProgress:
        _updateBoxProgress();
        break;
    }
  }

  _updateBoxProgress(){
    currentBox = currentBoxProgress.read();
    update(["box"]);
    if(currentBox>=5){
      _showBoxGuide();
    }
  }

  _showBoxGuide(){
    if(firstShowBoxGuide.read()){
      var renderBox = boxGlobalKey.currentContext!.findRenderObject() as RenderBox;
      var offset = renderBox.localToGlobal(Offset.zero);
      GuideUtils.instance.showOver(
        context: smContext,
        widget: BoxGuideOverlay(
          offset: offset,
          dismiss: (){
            clickBox();
          },
        ),
      );
      return;
    }
  }
}