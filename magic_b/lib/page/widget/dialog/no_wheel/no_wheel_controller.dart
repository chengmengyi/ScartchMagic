import 'package:magic_base/base_widget/sm_base_controller.dart';
import 'package:magic_base/sm_router/sm_routers_utils.dart';
import 'package:magic_base/utils/event/event_code.dart';
import 'package:magic_base/utils/event/event_info.dart';

class NoWheelController extends SmBaseController{
  clickFind(bool fromHome){
    SmRoutersUtils.instance.offPage();
    if(fromHome){
      EventInfo(eventCode: EventCode.updateHomeTabIndex,intValue: 0);
    }else{
      EventInfo(eventCode: EventCode.updatePlayPageTabIndex,intValue: 0);
    }
  }
}