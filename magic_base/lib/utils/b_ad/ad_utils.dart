import 'dart:convert';

import 'package:applovin_max/applovin_max.dart';
import 'package:magic_base/utils/b_ad/conf_ad_bean.dart';
import 'package:magic_base/utils/b_ad/load_ad.dart';
import 'package:magic_base/utils/b_ad/max_ad_bean.dart';
import 'package:magic_base/utils/b_ad/show_ad_result_listener.dart';
import 'package:magic_base/utils/data.dart';
import 'package:magic_base/utils/firebase/firebase_utils.dart';
import 'package:magic_base/utils/sm_extension.dart';
import 'package:magic_base/utils/storage/storage_hep.dart';

StorageHep<String> todayShowAdNum=StorageHep<String>(key: "todayShowAdNum", defaultValue: "");
StorageHep<String> todayClickAdNum=StorageHep<String>(key: "todayClickAdNum", defaultValue: "");
StorageHep<String> adConf=StorageHep<String>(key: "adConf", defaultValue: "");

class AdUtils{
  factory AdUtils()=>_getInstance();
  static AdUtils get instance => _getInstance();
  static AdUtils? _instance;
  static AdUtils _getInstance(){
    _instance??=AdUtils._internal();
    return _instance!;
  }

  AdUtils._internal(){
    _setMaxAdListener();
  }

  LoadAd? _oneLoadAd;
  LoadAd? _twoLoadAd;

  var adShowing=false;
  ShowAdResultListener? _showAdResultListener;

  initAd()async{
    await AppLovinMAX.initialize(maxKeyBase64.base64());
    
    // var json = jsonDecode(localAdStr.base64());
    // var showNum = json["idnmrhft"]??100;
    // var clickNum = json["owmdhdfr"]??100;
    // List<MaxAdBean> intOneList=[];
    // for(var value in json["stmag_int_one"]){
    //   var bean = MaxAdBean.fromJson(value);
    //   intOneList.add(bean);
    // }
    // List<MaxAdBean> intTwoList=[];
    // for(var value in json["stmag_int_two"]){
    //   var bean = MaxAdBean.fromJson(value);
    //   intTwoList.add(bean);
    // }
    //
    // List<MaxAdBean> rewardOneList=[];
    // for(var value in json["stmag_rv_one"]){
    //   var bean = MaxAdBean.fromJson(value);
    //   rewardOneList.add(bean);
    // }
    // List<MaxAdBean> rewardTwoList=[];
    // for(var value in json["stmag_rv_two"]){
    //   var bean = MaxAdBean.fromJson(value);
    //   rewardTwoList.add(bean);
    // }


    var data = _parseAdData();

    _oneLoadAd=LoadAd(one: true, maxShowNum: data.idnmrhft??100,maxClickNum: data.owmdhdfr??100, intList: data.stmagIntOne??[], rewardList: data.stmagRvOne??[]);
    _twoLoadAd=LoadAd(one: false,maxShowNum: data.idnmrhft??100,maxClickNum: data.owmdhdfr??100, intList: data.stmagIntTwo??[], rewardList: data.stmagRvTwo??[]);

    _oneLoadAd?.loadAd(AdType.reward);
    _oneLoadAd?.loadAd(AdType.interstitial);
    _twoLoadAd?.loadAd(AdType.reward);
    _twoLoadAd?.loadAd(AdType.interstitial);
  }

  _setMaxAdListener(){
    AppLovinMAX.setRewardedAdListener(
      RewardedAdListener(
        onAdLoadedCallback: (MaxAd ad){
          _oneLoadAd?.loadMaxAdSuccess(AdType.reward,ad);
          _twoLoadAd?.loadMaxAdSuccess(AdType.reward,ad);
        },
        onAdLoadFailedCallback: (String adUnitId, MaxError error){
          _oneLoadAd?.loadMaxAdFail(AdType.reward, adUnitId, error);
          _twoLoadAd?.loadMaxAdFail(AdType.reward, adUnitId, error);
        },
        onAdDisplayedCallback: (MaxAd ad){
          adShowing=true;
          _removeAdById(ad.adUnitId);
          _updateTodayShowNum();
          _showAdResultListener?.onAdDisplayedCallback.call(ad,_getMaxAdBeanById(AdType.reward,ad.adUnitId));
        },
        onAdDisplayFailedCallback: (MaxAd ad, MaxError error){
          adShowing=false;
          _removeAdById(ad.adUnitId);
          _showAdResultListener?.onAdDisplayFailedCallback.call(ad,error);
          loadAd(AdType.reward);
          loadAd(AdType.interstitial);
        },
        onAdClickedCallback: (MaxAd ad){
          _updateTodayClickNum();
        },
        onAdHiddenCallback: (MaxAd ad){
          adShowing=false;
          loadAd(AdType.reward);
          loadAd(AdType.interstitial);
          _showAdResultListener?.onAdHiddenCallback.call(ad);
        },
        onAdReceivedRewardCallback: (MaxAd ad, MaxReward reward){

        },
      )
    );
    AppLovinMAX.setInterstitialListener(
        InterstitialListener(
          onAdLoadedCallback: (MaxAd ad){
            _oneLoadAd?.loadMaxAdSuccess(AdType.interstitial,ad);
            _twoLoadAd?.loadMaxAdSuccess(AdType.interstitial,ad);
          },
          onAdLoadFailedCallback: (String adUnitId, MaxError error){
            _oneLoadAd?.loadMaxAdFail(AdType.interstitial, adUnitId, error);
            _twoLoadAd?.loadMaxAdFail(AdType.interstitial, adUnitId, error);
          },
          onAdDisplayedCallback: (MaxAd ad){
            adShowing=true;
            _removeAdById(ad.adUnitId);
            _updateTodayShowNum();
            _showAdResultListener?.onAdDisplayedCallback.call(ad,_getMaxAdBeanById(AdType.interstitial,ad.adUnitId));
          },
          onAdDisplayFailedCallback: (MaxAd ad, MaxError error){
            adShowing=false;
            _removeAdById(ad.adUnitId);
            _showAdResultListener?.onAdDisplayFailedCallback.call(ad,error);
            loadAd(AdType.reward);
            loadAd(AdType.interstitial);
          },
          onAdClickedCallback: (MaxAd ad){
            _updateTodayClickNum();
          },
          onAdHiddenCallback: (MaxAd ad){
            adShowing=false;
            loadAd(AdType.reward);
            loadAd(AdType.interstitial);
            _showAdResultListener?.onAdHiddenCallback.call(ad);
          },
        )
    );
  }

  bool checkHasCache(AdType adType){
    if(_oneLoadAd?.checkCache(adType)==true){
      return true;
    }
    return _twoLoadAd?.checkCache(adType)==true;
  }
  
  loadAd(AdType adType){
    _oneLoadAd?.loadAd(adType);
    _twoLoadAd?.loadAd(adType);
  }
  
  showAd({
    required AdType adType,
    required ShowAdResultListener showAdResultListener,
  })async{
    if(adShowing){
      logPrint("show ad--->$adType is showing");
      return;
    }
    var resultBean = _oneLoadAd?.getAdResult(adType);
    resultBean ??= _twoLoadAd?.getAdResult(adType);
    if(null==resultBean){
      logPrint("show ad--->$adType show fail,no ad");
      _oneLoadAd?.loadAd(adType);
      _twoLoadAd?.loadAd(adType);
      return;
    }
    _showAdResultListener=showAdResultListener;
    switch(adType){
      case AdType.reward:
        var ready = await AppLovinMAX.isRewardedAdReady(resultBean.maxAdBean.id??"");
        if(ready==true){
          logPrint("show ad--->$adType ad start show");
          AppLovinMAX.showRewardedAd(resultBean.maxAdBean.id??"");
        }else{
          logPrint("show ad--->$adType show fail,not ready");
          _removeAdById(resultBean.maxAdBean.id);
          _oneLoadAd?.loadAd(adType);
          _twoLoadAd?.loadAd(adType);
        }
        break;
      case AdType.interstitial:
        var ready = await AppLovinMAX.isInterstitialReady(resultBean.maxAdBean.id??"");
        if(ready==true){
          logPrint("show ad--->$adType ad start show");
          AppLovinMAX.showInterstitial(resultBean.maxAdBean.id??"");
        }else{
          logPrint("show ad--->$adType show fail,not ready");
          _removeAdById(resultBean.maxAdBean.id);
          _oneLoadAd?.loadAd(adType);
          _twoLoadAd?.loadAd(adType);
        }
        break;
    }
  }

  MaxAdBean? _getMaxAdBeanById(AdType adType,String? id){
    var maxAdBean = _oneLoadAd?.getMaxAdBeanById(adType, id);
    maxAdBean ??= _twoLoadAd?.getMaxAdBeanById(adType, id);
    return maxAdBean;
  }

  _removeAdById(String? id){
    _oneLoadAd?.removeAdResult(id);
    _twoLoadAd?.removeAdResult(id);
  }

  _updateTodayShowNum(){
    todayShowAdNum.write("${getTodayTime()}_${getTodayNum(todayShowAdNum)+1}");
  }

  _updateTodayClickNum(){
    todayClickAdNum.write("${getTodayTime()}_${getTodayNum(todayClickAdNum)+1}");
  }

  int getTodayNum(StorageHep<String> storageHep){
    var s = storageHep.read();
    if(s.isEmpty){
      return 0;
    }
    try{
      var list = s.split("_");
      if(list.first==getTodayTime()){
        return list.last.toInt();
      }
      return 0;
    }catch(e){
      return 0;
    }
  }

  getFirebaseConf(){
    var conf = FirebaseUtils.instance.getFirebaseConf("stmag_ad_config");
    if(conf.isNotEmpty){
      adConf.write(conf);
      var data = _parseAdData();
      _oneLoadAd?.updateInfo(data.idnmrhft??100, data.owmdhdfr??100, data.stmagIntOne??[], data.stmagRvOne??[]);
      _twoLoadAd?.updateInfo(data.idnmrhft??100, data.owmdhdfr??100, data.stmagIntTwo??[], data.stmagRvTwo??[]);
    }
  }

  ConfAdBean _parseAdData(){
    var s = adConf.read();
    if(s.isEmpty){
      s=localAdStr.base64();
    }
    return ConfAdBean.fromJson(jsonDecode(s));
  }
}