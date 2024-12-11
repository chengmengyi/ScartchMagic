import 'package:magic_base/base_widget/sm_base_controller.dart';
import 'package:magic_base/utils/event/event_code.dart';
import 'package:magic_base/utils/event/event_info.dart';

class PlayChildController extends SmBaseController{
  var showBubble=false;

  @override
  bool smRegisterEvent() => true;

  @override
  smEventReceived(EventInfo eventInfo) {
    switch(eventInfo.eventCode){
      case EventCode.showBubble:
        showBubble=true;
        update(["showBubble"]);
        break;
    }
  }
}