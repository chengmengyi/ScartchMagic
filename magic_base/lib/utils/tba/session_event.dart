import 'package:magic_base/utils/sm_extension.dart';
import 'package:magic_base/utils/tba/base_event.dart';

class SessionEvent extends BaseEvent{

  upload()async{
    var baseMap = await getBaseMap();
    baseMap["pietism"]={};
    var result = await request(TbaType.session, baseMap);
    logPrint("tba--->tba type:${TbaType.session}--->result:${result.success}");
  }
}