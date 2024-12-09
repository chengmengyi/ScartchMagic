import 'package:magic_base/base_widget/sm_base_controller.dart';
import 'package:magic_base/sm_router/sm_routers_utils.dart';
import 'package:magic_base/utils/sm_extension.dart';
import 'package:magic_b/utils/info_hep.dart';
import 'package:magic_b/utils/normal_ad/normal_ad_utils.dart';
import 'package:magic_b/utils/b_sql/b_sql_utils.dart';
import 'package:magic_b/utils/b_sql/play_info_bean.dart';
import 'package:magic_b/utils/b_storage/b_storage_hep.dart';

class UnlockDialogController extends SmBaseController{

  spendMoneyUnlock(String playType)async{
    if(coins.read()<5000){
      showToast("Insufficient gold coins");
      return;
    }
    InfoHep.instance.updateCoins(-5000);
    await BSqlUtils.instance.unlockNextPlay(playType);
    SmRoutersUtils.instance.offPage();
  }

  watchAdUnlock(String playType)async{
    NormalAdUtils.instance.showAd(
      onAdHiddenCallback: ()async{
        await BSqlUtils.instance.unlockNextPlay(playType);
        SmRoutersUtils.instance.offPage();
      }
    );
  }
}