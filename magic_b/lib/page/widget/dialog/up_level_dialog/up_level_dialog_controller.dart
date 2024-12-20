import 'package:magic_b/utils/b_ad/show_ad_utils.dart';
import 'package:magic_b/utils/info_hep.dart';
import 'package:magic_base/base_widget/sm_base_controller.dart';
import 'package:magic_base/sm_router/sm_routers_utils.dart';
import 'package:magic_base/utils/b_ad/load_ad.dart';
import 'package:magic_base/utils/tba/ad_pos.dart';
import 'package:magic_base/utils/tba/tba_utils.dart';

class UpLevelDialogController extends SmBaseController{
  var sourceFrom="";

  @override
  void onInit() {
    super.onInit();
    sourceFrom=SmRoutersUtils.instance.getParams()["sourceFrom"];
    TbaUtils.instance.pointEvent(pointType: PointType.sm_level_pop,data: {"source_from":sourceFrom});
  }

  clickDouble(int money,Function() call){
    TbaUtils.instance.pointEvent(pointType: PointType.sm_level_pop_c,data: {"source_from":sourceFrom});
    ShowAdUtils.instance.showAd(
        adPos: AdPos.stmag_level_rv,
        adType: AdType.reward,
        closeAd: (showFail){
          if(!showFail){
            _closeDialog(money*2, call);
          }
        }
    );
  }

  clickSingle(int money,Function() call){
    TbaUtils.instance.pointEvent(pointType: PointType.sm_level_pop_close,data: {"source_from":sourceFrom});
    ShowAdUtils.instance.showAd(
        adPos: AdPos.stmag_level_int,
        adType: AdType.interstitial,
        closeAd: (showFail){
          _closeDialog(money, call);
        }
    );
  }

  _closeDialog(int money,Function() call){
    InfoHep.instance.updateCoins(money);
    SmRoutersUtils.instance.offPage();
    call.call();
  }
}