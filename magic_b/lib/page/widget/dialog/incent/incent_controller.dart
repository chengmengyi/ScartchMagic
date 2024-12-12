import 'package:magic_b/utils/b_ad/ad_utils.dart';
import 'package:magic_b/utils/b_storage/b_storage_hep.dart';
import 'package:magic_b/utils/guide/guide_step.dart';
import 'package:magic_b/utils/guide/guide_utils.dart';
import 'package:magic_b/utils/info_hep.dart';
import 'package:magic_base/base_widget/sm_base_controller.dart';
import 'package:magic_base/sm_router/sm_routers_utils.dart';

class IncentController extends SmBaseController{

  clickDouble(int money,Function(int addNum) call){
    AdUtils.instance.showAd(
      closeAd: (){
        _closeDialog(money*2, call);
      }
    );
  }

  clickSingle(int money,Function(int addNum) call){
    AdUtils.instance.showAd(
        closeAd: (){
          _closeDialog(money, call);
        }
    );
  }

  _closeDialog(int money,Function(int addNum) call){
    SmRoutersUtils.instance.offPage();
    InfoHep.instance.updateCoins(money);
    if(currentGuideStep.read()==GuideStep.firstGetReward){
      GuideUtils.instance.updateGuideStep(GuideStep.showCashFingerGuide);
    }
    call.call(money);
  }
}