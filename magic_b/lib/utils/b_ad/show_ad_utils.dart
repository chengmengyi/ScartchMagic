import 'package:magic_b/utils/b_value/b_value_hep.dart';
import 'package:magic_base/utils/b_ad/ad_utils.dart';
import 'package:magic_base/utils/b_ad/load_ad.dart';
import 'package:magic_base/utils/b_ad/max_ad_bean.dart';
import 'package:magic_base/utils/b_ad/show_ad_result_listener.dart';
import 'package:magic_base/utils/sm_export.dart';
import 'package:magic_base/utils/sm_extension.dart';
import 'package:magic_base/utils/tba/ad_pos.dart';
import 'package:magic_base/utils/tba/tba_utils.dart';

class ShowAdUtils{
  factory ShowAdUtils()=>_getInstance();
  static ShowAdUtils get instance => _getInstance();
  static ShowAdUtils? _instance;
  static ShowAdUtils _getInstance(){
    _instance??=ShowAdUtils._internal();
    return _instance!;
  }

  ShowAdUtils._internal();

  int lastClickTimer=0;
  
  showAd({
    required AdPos adPos,
    required AdType adType,
    required Function(bool showFail) closeAd,
  }){
    var epoch = DateTime.now().millisecondsSinceEpoch;
    if(epoch-lastClickTimer<1000){
      return;
    }
    lastClickTimer=epoch;
    if(!BValueHep.instance.checkShowIntAd(adType)){
      closeAd.call(false);
      return;
    }
    TbaUtils.instance.pointEvent(pointType: PointType.stmag_ad_chance);
    if(AdUtils.instance.checkHasCache(adType)){
      AdUtils.instance.showAd(
        adType: adType,
        showAdResultListener: ShowAdResultListener(
          onAdDisplayedCallback: (MaxAd maxAd,MaxAdBean? maxAdBean){
            TbaUtils.instance.adEvent(maxAd, maxAdBean, adPos);
            TbaUtils.instance.pointEvent(pointType: PointType.stmag_ad_impression);
          },
          onAdHiddenCallback: (MaxAd ad){
            closeAd.call(false);
          },
          onAdDisplayFailedCallback: (MaxAd ad, MaxError error){
            showToast("show ad fail, please try again");
            closeAd.call(true);
            TbaUtils.instance.pointEvent(pointType: PointType.stmag_ad_impression_fail);
          },
        ),
      );
      return;
    }
    TbaUtils.instance.pointEvent(pointType: PointType.stmag_ad_impression_fail);
    AdUtils.instance.loadAd(adType);
    showToast("Load ad fail, please try again");
    closeAd.call(true);
  }

  showOpen({required Function() closeAd,}){
    TbaUtils.instance.pointEvent(pointType: PointType.stmag_ad_chance);
    if(AdUtils.instance.checkHasCache(AdType.interstitial)){
      AdUtils.instance.showAd(
        adType: AdType.interstitial,
        showAdResultListener: ShowAdResultListener(
          onAdDisplayedCallback: (MaxAd maxAd,MaxAdBean? maxAdBean){
            TbaUtils.instance.adEvent(maxAd, maxAdBean, AdPos.stmag_launch);
            TbaUtils.instance.pointEvent(pointType: PointType.stmag_ad_impression);
          },
          onAdHiddenCallback: (MaxAd ad){
            closeAd.call();
          },
          onAdDisplayFailedCallback: (MaxAd ad, MaxError error){
            TbaUtils.instance.pointEvent(pointType: PointType.stmag_ad_impression_fail);
            closeAd.call();
          },
        ),
      );
      return;
    }
    TbaUtils.instance.pointEvent(pointType: PointType.stmag_ad_impression_fail);
    closeAd.call();
  }
}