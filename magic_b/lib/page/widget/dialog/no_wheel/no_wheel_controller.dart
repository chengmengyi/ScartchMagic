import 'package:magic_base/base_widget/sm_base_controller.dart';
import 'package:magic_base/sm_router/sm_routers_utils.dart';
import 'package:magic_base/utils/event/event_code.dart';
import 'package:magic_base/utils/event/event_info.dart';

class NoWheelController extends SmBaseController{
  clickFind(bool fromHome){
    SmRoutersUtils.instance.offPage();
    EventInfo(eventCode: EventCode.updateHomeTabIndex,intValue: 0);
  }
}