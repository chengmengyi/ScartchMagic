import 'package:magic_b/utils/b_ad/ad_utils.dart';
import 'package:magic_b/utils/guide/guide_step.dart';
import 'package:magic_b/utils/guide/guide_utils.dart';
import 'package:magic_b/utils/info_hep.dart';
import 'package:magic_base/base_widget/sm_base_controller.dart';
import 'package:magic_base/sm_router/sm_routers_utils.dart';

class OldUserDoubleRewardController extends SmBaseController{

  clickDouble(wheelReward,signReward){
    AdUtils.instance.showAd(
      closeAd: (){
        SmRoutersUtils.instance.offPage();
        InfoHep.instance.updateCoins((wheelReward+signReward)*2);
        GuideUtils.instance.updateOldStep(OldGuideStep.completed);
      }
    );
  }

  clickSingle(wheelReward,signReward){
    AdUtils.instance.showAd(
        closeAd: (){
          SmRoutersUtils.instance.offPage();
          InfoHep.instance.updateCoins(wheelReward+signReward);
          GuideUtils.instance.updateOldStep(OldGuideStep.completed);
        }
    );
  }


  clickClose(){
    SmRoutersUtils.instance.offPage();
    GuideUtils.instance.updateOldStep(OldGuideStep.completed);
  }
}