import 'package:magic_base/base_widget/sm_base_controller.dart';
import 'package:magic_base/utils/event/event_code.dart';
import 'package:magic_base/utils/event/event_info.dart';

class PlayTopController extends SmBaseController{

  toCash(){
    EventInfo(eventCode: EventCode.toCashChild);
  }
}