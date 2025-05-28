import 'package:magic_b/utils/b_ad/show_ad_utils.dart';
import 'package:magic_b/utils/b_sql/play_info_bean.dart';
import 'package:magic_base/base_widget/sm_base_controller.dart';
import 'package:magic_base/sm_router/sm_routers_utils.dart';
import 'package:magic_base/utils/b_ad/load_ad.dart';
import 'package:magic_base/utils/tba/ad_pos.dart';
import 'package:magic_base/utils/tba/tba_utils.dart';

class AddChanceController extends SmBaseController{

  @override
  void onInit() {
    super.onInit();
    TbaUtils.instance.pointEvent(pointType: PointType.more_card_pop);
  }

  clickClose(){
    ShowAdUtils.instance.showAd(
      adPos: AdPos.stmag_close_int,
      adType: AdType.interstitial,
      closeAd: (showFail){
        SmRoutersUtils.instance.offPage();
      },
    );
  }

  clickGet(PlayType playType, Function() dismiss){
    TbaUtils.instance.pointEvent(pointType: PointType.more_card_pop_c);
    ShowAdUtils.instance.showAd(
      adPos: AdPos.stmag_getcard_rv,
      adType: AdType.reward,
      closeAd: (showFail){
        if(!showFail){
          SmRoutersUtils.instance.offPage();
          dismiss.call();
        }
      },
    );
  }
}