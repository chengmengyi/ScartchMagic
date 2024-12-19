import 'package:magic_base/utils/b_ad/ad_utils.dart';
import 'package:magic_b/utils/b_value/b_value_hep.dart';
import 'package:magic_b/utils/info_hep.dart';
import 'package:magic_base/base_widget/sm_base_controller.dart';
import 'package:magic_base/sm_router/sm_routers_utils.dart';

class BoxController extends SmBaseController{
  int reward=BValueHep.instance.getBoxReward();

  clickDouble(Function() dismiss){
    AdUtils.instance.showAd(
        closeAd: (){
          _closeDialog(reward*2,dismiss);
        }
    );
  }

  clickSingle(Function() dismiss,){
    AdUtils.instance.showAd(
        closeAd: (){
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