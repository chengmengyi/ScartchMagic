import 'package:magic_base/base_widget/sm_base_controller.dart';
import 'package:magic_base/sm_router/sm_routers_utils.dart';
import 'package:magic_base/utils/b_ad/ad_utils.dart';
import 'package:magic_base/utils/b_ad/load_ad.dart';
import 'package:magic_base/utils/b_ad/max_ad_bean.dart';
import 'package:magic_base/utils/b_ad/show_ad_result_listener.dart';
import 'package:magic_base/utils/sm_export.dart';
import 'package:magic_base/utils/sm_extension.dart';
import 'package:magic_normal/utils/info_hep.dart';
import 'package:magic_normal/utils/normal_sql/normal_sql_utils.dart';
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
    if(AdUtils.instance.checkHasCache(AdType.reward)){
      AdUtils.instance.showAd(
        adType: AdType.reward,
        showAdResultListener: ShowAdResultListener(
          onAdDisplayedCallback: (MaxAd maxAd,MaxAdBean? maxAdBean){
          },
          onAdHiddenCallback: (MaxAd ad)async{
            await NormalSqlUtils.instance.unlockNextPlay(playType);
            SmRoutersUtils.instance.offPage();
          },
          onAdDisplayFailedCallback: (MaxAd ad, MaxError error){
            showToast("show ad fail, please try again");
          },
        ),
      );
    }else{
      showToast("Failed to obtain advertisement, please try again later");
    }
  }
}