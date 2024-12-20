import 'package:magic_base/base_widget/sm_base_controller.dart';
import 'package:magic_base/sm_router/sm_routers_utils.dart';
import 'package:magic_base/utils/event/event_code.dart';
import 'package:magic_base/utils/event/event_info.dart';
import 'package:magic_base/utils/tba/ad_pos.dart';
import 'package:magic_base/utils/tba/tba_utils.dart';

class NoWheelController extends SmBaseController{
  @override
  void onInit() {
    super.onInit();
    TbaUtils.instance.pointEvent(pointType: PointType.sm_wheel_not_key);
  }
  clickFind(bool fromHome){
    TbaUtils.instance.pointEvent(pointType: PointType.sm_wheel_not_key_c);
    SmRoutersUtils.instance.offPage();
    if(fromHome){
      EventInfo(eventCode: EventCode.updateHomeTabIndex,intValue: 0);
    }else{
      EventInfo(eventCode: EventCode.updatePlayPageTabIndex,intValue: 0);
    }
  }
}