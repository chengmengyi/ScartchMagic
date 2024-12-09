import 'package:magic_base/base_widget/sm_base_controller.dart';
import 'package:magic_base/sm_router/sm_routers_utils.dart';
import 'package:magic_base/utils/sm_extension.dart';
import 'package:magic_normal/utils/info_hep.dart';
import 'package:magic_normal/utils/normal_ad/normal_ad_utils.dart';
import 'package:magic_normal/utils/normal_sql/normal_sql_utils.dart';
import 'package:magic_normal/utils/normal_sql/play_info_bean.dart';
import 'package:magic_normal/utils/normal_storage/normal_storage_hep.dart';

class UnlockDialogController extends SmBaseController{

  spendMoneyUnlock(String playType)async{
    if(coins.read()<5000){
      showToast("Insufficient gold coins");
      return;
    }
    InfoHep.instance.updateCoins(-5000);
    await NormalSqlUtils.instance.unlockNextPlay(playType);
    SmRoutersUtils.instance.offPage();
  }

  watchAdUnlock(String playType)async{
    NormalAdUtils.instance.showAd(
      onAdHiddenCallback: ()async{
        await NormalSqlUtils.instance.unlockNextPlay(playType);
        SmRoutersUtils.instance.offPage();
      }
    );
  }
}