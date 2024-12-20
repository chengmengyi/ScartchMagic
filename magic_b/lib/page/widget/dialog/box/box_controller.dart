import 'package:magic_b/utils/b_ad/show_ad_utils.dart';
import 'package:magic_b/utils/b_value/b_value_hep.dart';
import 'package:magic_b/utils/info_hep.dart';
import 'package:magic_base/base_widget/sm_base_controller.dart';
import 'package:magic_base/sm_router/sm_routers_utils.dart';
import 'package:magic_base/utils/b_ad/load_ad.dart';
import 'package:magic_base/utils/tba/ad_pos.dart';
import 'package:magic_base/utils/tba/tba_utils.dart';

class BoxController extends SmBaseController{
  int reward=BValueHep.instance.getBoxReward();
  @override
  void onInit() {
    super.onInit();
    TbaUtils.instance.pointEvent(pointType: PointType.box_double_pop);
  }

  clickDouble(Function() dismiss){
    TbaUtils.instance.pointEvent(pointType: PointType.box_double_pop_c);
    ShowAdUtils.instance.showAd(
        adPos: AdPos.stmag_box_rv,
        adType: AdType.reward,
        closeAd: (showFail){
          if(!showFail){
            _closeDialog(reward*2,dismiss);
          }
        }
    );
  }

  clickSingle(Function() dismiss,){
    TbaUtils.instance.pointEvent(pointType: PointType.box_double_pop_close);
    ShowAdUtils.instance.showAd(
        adPos: AdPos.stmag_box_int,
        adType: AdType.interstitial,
        closeAd: (showFail){
          _closeDialog(reward,dismiss);
        }
    );
  }

  _closeDialog(int money,Function() dismiss){
    SmRoutersUtils.instance.offPage();
    InfoHep.instance.updateCoins(money);
    dismiss.call();
  }
}