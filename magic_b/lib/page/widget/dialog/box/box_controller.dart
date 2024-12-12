import 'package:magic_b/utils/b_ad/ad_utils.dart';
import 'package:magic_b/utils/info_hep.dart';
import 'package:magic_base/base_widget/sm_base_controller.dart';
import 'package:magic_base/sm_router/sm_routers_utils.dart';

class BoxController extends SmBaseController{
  int reward=80;

  clickDouble(){
    AdUtils.instance.showAd(
        closeAd: (){
          _closeDialog(reward*2);
        }
    );
  }

  clickSingle(){
    AdUtils.instance.showAd(
        closeAd: (){
          _closeDialog(reward);
        }
    );
  }

  _closeDialog(int money,){
    SmRoutersUtils.instance.offPage();
    InfoHep.instance.updateCoins(money);
  }
}