import 'dart:async';
import 'package:magic_b/page/widget/dialog/incent/incent_dialog.dart';
import 'package:magic_b/page/widget/dialog/no_wheel/no_wheel_dialog.dart';
import 'package:magic_b/page/widget/dialog/old_user_double_reward/old_user_double_reward_dialog.dart';
import 'package:magic_b/utils/b_storage/b_storage_hep.dart';
import 'package:magic_b/utils/b_value/b_value_hep.dart';
import 'package:magic_b/utils/info_hep.dart';
import 'package:magic_base/base_widget/sm_base_controller.dart';
import 'package:magic_base/sm_router/sm_routers_utils.dart';
import 'package:magic_base/utils/b_ad/ad_utils.dart';
import 'package:magic_base/utils/event/event_code.dart';
import 'package:magic_base/utils/event/event_info.dart';
import 'package:magic_base/utils/sm_extension.dart';

class WheelChildController extends SmBaseController{
  var currentWheelAngle=0.0,_looping=false;
  Timer? _wheelTimer;

  @override
  void onInit() {
    super.onInit();
    print("kk===WheelChildController=onInit");
  }
  @override
  void onReady() {
    super.onReady();
    print("kk===WheelChildController=onReady");
  }

  startWheel(bool fromHome,{bool fromOldGuide=false,}){
    if(wheelChanceNum.read()<=0){
      SmRoutersUtils.instance.showDialog(widget: NoWheelDialog(fromHome: fromHome));
      return;
    }
    if(_looping){
      return;
    }
    _looping=true;
    EventInfo(eventCode: EventCode.startOrStopWheel,boolValue: true);
    var wheelAddNum = BValueHep.instance.getWheelAddNum();
    var addAngel = _getAddAngelByNum(wheelAddNum);
    var totalAngel=720+addAngel;
    currentWheelAngle=0;
    update(["wheel"]);
    _wheelTimer=Timer.periodic(const Duration(milliseconds: 1), (t){
      currentWheelAngle++;
      update(["wheel"]);
      if(currentWheelAngle>=totalAngel){
        _stopWheel(wheelAddNum,fromOldGuide);
      }
    });
  }

  _stopWheel(wheelAddNum,fromOldGuide){
    _wheelTimer?.cancel();
    _looping=false;
    EventInfo(eventCode: EventCode.startOrStopWheel,boolValue: false);
    wheelChanceNum.add(-1);
    update(["wheel_num"]);
    AdUtils.instance.showAd(
      closeAd: (){
        if(fromOldGuide){
          SmRoutersUtils.instance.showDialog(
            widget: OldUserDoubleRewardDialog(
              wheelReward: wheelAddNum,
              signReward: BValueHep.instance.getSignReward(),
            ),
          );
        }else{
          SmRoutersUtils.instance.showDialog(
            widget: IncentDialog(
              money: wheelAddNum,
              dismissDialog: (add){
                InfoHep.instance.updateCoins(wheelAddNum);
              },
            )
          );
        }
      },
    );
  }

  int _getAddAngelByNum(wheelAddNum){
    switch(wheelAddNum){
      case 20: return [-18,-162,-306].random();
      case 50: return [-90,-198].random();
      case 80: return [-54,-234].random();
      default: return 0;
    }
  }

  @override
  bool smRegisterEvent() => true;

  @override
  smEventReceived(EventInfo eventInfo) {
    switch(eventInfo.eventCode){
      case EventCode.showWheelTab:
        if(eventInfo.boolValue==true){
          startWheel(false);
        }
        break;
      case EventCode.keyAnimatorEnd:
        update(["wheel_num"]);
        break;
    }
  }
}