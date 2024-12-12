import 'package:magic_base/utils/event/event_code.dart';
import 'package:magic_base/utils/event/event_info.dart';
import 'package:magic_b/utils/b_storage/b_storage_hep.dart';

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

  updatePlayedCardNum(){
    playedCardNum.add(1);
    var num = playedCardNum.read();
    if(num==2){
      EventInfo(eventCode: EventCode.showRevealAllFingerGuide);
    }
    if(num==3){
      EventInfo(eventCode: EventCode.showBubble);
    }
  }

  updateBoxProgress(){
    if(currentBoxProgress.read()<5){
      currentBoxProgress.add(1);
    }
    EventInfo(eventCode: EventCode.updateBoxProgress);
  }
}