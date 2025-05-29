import 'package:magic_b/utils/b_ad/show_ad_utils.dart';
import 'package:magic_b/utils/b_storage/b_storage_hep.dart';
import 'package:magic_b/utils/guide/guide_step.dart';
import 'package:magic_base/base_widget/sm_base_controller.dart';
import 'package:magic_base/sm_router/sm_routers_utils.dart';
import 'package:magic_base/utils/b_ad/load_ad.dart';
import 'package:magic_base/utils/tba/ad_pos.dart';
import 'package:magic_base/utils/tba/tba_utils.dart';

class CashwinController extends SmBaseController{

  @override
  void onInit() {
    super.onInit();
    TbaUtils.instance.pointEvent(pointType: PointType.sm_cashwin_pop);
  }

  clickSingle(int addNum,Function(int addNum) call){
    TbaUtils.instance.pointEvent(pointType: PointType.sm_cashwin_c);
    ShowAdUtils.instance.showAd(
        adPos: AdPos.stmag_cashwin_int,
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