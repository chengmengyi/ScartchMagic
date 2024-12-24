import 'package:magic_b/page/widget/dialog/incent/incent_dialog.dart';
import 'package:magic_b/utils/b_ad/show_ad_utils.dart';
import 'package:magic_b/utils/b_storage/b_storage_hep.dart';
import 'package:magic_b/utils/guide/guide_step.dart';
import 'package:magic_b/utils/guide/guide_utils.dart';
import 'package:magic_b/utils/info_hep.dart';
import 'package:magic_base/base_widget/sm_base_controller.dart';
import 'package:magic_base/sm_router/sm_routers_utils.dart';
import 'package:magic_base/utils/b_ad/load_ad.dart';
import 'package:magic_base/utils/tba/ad_pos.dart';
import 'package:magic_base/utils/tba/tba_utils.dart';

class IncentController extends SmBaseController{
  var sourceFrom="";

  @override
  void onInit() {
    super.onInit();
    sourceFrom=SmRoutersUtils.instance.getParams()["sourceFrom"];
    TbaUtils.instance.pointEvent(pointType: PointType.sm_coin_pop,data: {"source_from":sourceFrom});
    if(currentGuideStep.read()==GuideStep.firstGetReward){
      TbaUtils.instance.pointEvent(pointType: PointType.sm_card_coin_guide_pop);
    }
  }

  clickDouble(IncentType incentType,int money,Function(int addNum) call){
    TbaUtils.instance.pointEvent(pointType: PointType.sm_coin_pop_c,data: {"source_from":sourceFrom});
    if(currentGuideStep.read()==GuideStep.firstGetReward){
      TbaUtils.instance.pointEvent(pointType: PointType.sm_card_coin_guide_pop_c);
    }
    ShowAdUtils.instance.showAd(
      adPos: incentType==IncentType.card?AdPos.stmag_card_rv:AdPos.stmag_wheel_rv,
      adType: AdType.reward,
      closeAd: (showFail){
        if(!showFail){
          _closeDialog(money*2, call);
        }
      }
    );
  }

  clickSingle(IncentType incentType,int money,Function(int addNum) call){
    TbaUtils.instance.pointEvent(pointType: PointType.sm_coin_pop_close,data: {"source_from":sourceFrom});
    ShowAdUtils.instance.showAd(
        adPos: incentType==IncentType.card?AdPos.stmag_card_int:AdPos.stmag_wheel_int,
        adType: AdType.interstitial,
        closeAd: (showFail){
          _closeDialog(money, call);
        }
    );
  }

  _closeDialog(int money,Function(int addNum) call){
    SmRoutersUtils.instance.offPage();
    if(currentGuideStep.read()==GuideStep.firstGetReward){
      GuideUtils.instance.updateGuideStep(GuideStep.showCashFingerGuide);
    }
    call.call(money);
  }
}