import 'package:magic_b/utils/b_ad/show_ad_utils.dart';
import 'package:magic_b/utils/guide/guide_step.dart';
import 'package:magic_b/utils/guide/guide_utils.dart';
import 'package:magic_b/utils/info_hep.dart';
import 'package:magic_base/base_widget/sm_base_controller.dart';
import 'package:magic_base/sm_router/sm_routers_utils.dart';
import 'package:magic_base/utils/b_ad/load_ad.dart';
import 'package:magic_base/utils/tba/ad_pos.dart';
import 'package:magic_base/utils/tba/tba_utils.dart';

class OldUserDoubleRewardController extends SmBaseController{
  @override
  void onInit() {
    super.onInit();
    TbaUtils.instance.pointEvent(pointType: PointType.sm_daily_wheel_pop);
  }

  clickDouble(wheelReward,signReward){
    TbaUtils.instance.pointEvent(pointType: PointType.sm_daily_wheel_pop_c);
    ShowAdUtils.instance.showAd(
      adPos: AdPos.stmag_olduser_wheel_rv,
      adType: AdType.reward,
      closeAd: (showFail){
        if(showFail){
          return;
        }
        SmRoutersUtils.instance.offPage();
        InfoHep.instance.updateCoins((wheelReward+signReward)*2);
        GuideUtils.instance.updateOldStep(OldGuideStep.completed);
      }
    );
  }

  clickSingle(wheelReward,signReward){
    ShowAdUtils.instance.showAd(
      adPos: AdPos.stmag_olduser_wheel_int,
      adType: AdType.interstitial,
      closeAd: (showFail){
        SmRoutersUtils.instance.offPage();
        InfoHep.instance.updateCoins(wheelReward+signReward);
        GuideUtils.instance.updateOldStep(OldGuideStep.completed);
      },
    );
  }


  clickClose(){
    SmRoutersUtils.instance.offPage();
    GuideUtils.instance.updateOldStep(OldGuideStep.completed);
  }
}