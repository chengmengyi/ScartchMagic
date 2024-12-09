import 'package:magic_base/utils/event/event_code.dart';
import 'package:magic_base/utils/event/event_info.dart';
import 'package:magic_normal/utils/normal_storage/normal_storage_hep.dart';

class InfoHep{
  factory InfoHep()=>_getInstance();
  static InfoHep get instance => _getInstance();
  static InfoHep? _instance;
  static InfoHep _getInstance(){
    _instance??=InfoHep._internal();
    return _instance!;
  }

  InfoHep._internal();

  updateCoins(int addNum){
    coins.add(addNum);
    EventInfo(eventCode: EventCode.updateCoins,intValue: addNum);
  }
}