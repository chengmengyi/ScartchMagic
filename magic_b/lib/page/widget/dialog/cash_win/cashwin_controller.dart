import 'package:magic_b/page/widget/dialog/incent/incent_dialog.dart';
import 'package:magic_b/utils/b_ad/show_ad_utils.dart';
import 'package:magic_b/utils/b_storage/b_storage_hep.dart';
import 'package:magic_b/utils/b_value/b_value_hep.dart';
import 'package:magic_b/utils/guide/guide_step.dart';
import 'package:magic_b/utils/guide/guide_utils.dart';
import 'package:magic_b/utils/info_hep.dart';
import 'package:magic_base/base_widget/sm_base_controller.dart';
import 'package:magic_base/sm_router/sm_routers_utils.dart';
import 'package:magic_base/utils/b_ad/load_ad.dart';
import 'package:magic_base/utils/tba/ad_pos.dart';
import 'package:magic_base/utils/tba/tba_utils.dart';

class CashwinController extends SmBaseController{

  @override
  void onInit() {
    super.onInit();
    TbaUtils.instance.pointEvent(pointType: PointType.sm_bigwin_pop);
  }

  clickDouble(int addNum,Function(int addNum) call){
    TbaUtils.instance.pointEvent(pointType: PointType.sm_bigwin_c);
    if(currentGuideStep.read()==GuideStep.firstGetReward){
      TbaUtils.instance.pointEvent(pointType: PointType.sm_card_coin_guide_pop_c);
    }
    ShowAdUtils.instance.showAd(
      adPos: AdPos.stmag_bigwin_rv,
      adType: AdType.reward,
      closeAd: (showFail){
        if(!showFail){
          _closeDialog(addNum*2, call);
        }
      }
    );
  }

  clickSingle(int addNum,Function(int addNum) call){
    TbaUtils.instance.pointEvent(pointType: PointType.sm_bigwin_pop_close);
    ShowAdUtils.instance.showAd(
        adPos: AdPos.stmag_bigwin_int,
        adType: AdType.interstitial,
        closeAd: (showFail){
          _closeDialog(addNum, call);
        }
    );
  }

  _closeDialog(int money,Function(int addNum) call){
    SmRoutersUtils.instance.offPage();
    call.call(money);
  }
}