import 'package:magic_b/utils/b_ad/show_ad_utils.dart';
import 'package:magic_b/utils/guide/guide_step.dart';
import 'package:magic_b/utils/guide/guide_utils.dart';
import 'package:magic_base/base_widget/sm_base_controller.dart';
import 'package:magic_base/sm_router/sm_routers_utils.dart';
import 'package:magic_base/utils/b_ad/load_ad.dart';
import 'package:magic_base/utils/tba/ad_pos.dart';
import 'package:magic_base/utils/tba/tba_utils.dart';

class OldUserController extends SmBaseController{

  @override
  void onInit() {
    super.onInit();
    TbaUtils.instance.pointEvent(pointType: PointType.sm_old_user_pop);
  }

  clickClose(){
    ShowAdUtils.instance.showAd(
      adPos: AdPos.stmag_close_int,
      adType: AdType.interstitial,
      closeAd: (showFail){
        SmRoutersUtils.instance.offPage();
        GuideUtils.instance.updateOldStep(OldGuideStep.showSingleRewardDialog);
      },
    );
  }

  clickSpin(){
    TbaUtils.instance.pointEvent(pointType: PointType.sm_old_user_pop_c);
    SmRoutersUtils.instance.offPage();
    GuideUtils.instance.updateOldStep(OldGuideStep.showWheelTab);
  }
}