import 'package:applovin_max/applovin_max.dart';
import 'package:magic_base/utils/b_ad/ad_utils.dart';
import 'package:magic_base/utils/b_ad/max_ad_bean.dart';
import 'package:magic_base/utils/b_ad/max_result_bean.dart';
import 'package:magic_base/utils/sm_extension.dart';


enum AdType{
  interstitial,reward,
}

class LoadAd{
  bool one;
  int maxShowNum;
  int maxClickNum;
  List<MaxAdBean> intList;
  List<MaxAdBean> rewardList;

  final Map<AdType,MaxResultBean> _resultAdMap={};

  LoadAd({
    required this.one,
    required this.maxShowNum,
    required this.maxClickNum,
    required this.intList,
    required this.rewardList,
  });

  final List<AdType> _loadingList=[];

  updateInfo(maxShowNum,maxClickNum,intList,rewardList){
    this.maxShowNum=maxShowNum;
    this.maxClickNum=maxClickNum;
    this.intList=intList;
    this.rewardList=rewardList;
  }

  loadAd(AdType adType){
    if(_loadingList.contains(adType)){
      logPrint("load ad--->${one?"one":"two"}--->$adType is loading");
      return;
    }
    var showNum = AdUtils.instance.getTodayNum(todayShowAdNum);
    var clickNum = AdUtils.instance.getTodayNum(todayShowAdNum);
    logPrint("load ad--->${one?"one":"two"}--->todayShowAdNum=$showNum,todayShowAdNum = $clickNum");
    if(showNum>maxShowNum||clickNum>=maxClickNum){
      logPrint("load ad--->${one?"one":"two"}--->todayShowAdNum or todayShowAdNum max");
      return;
    }
    if(checkCache(adType)){
      logPrint("load ad--->${one?"one":"two"}--->$adType has cache");
      return;
    }
    List<MaxAdBean> list=_getAdListByAdType(adType);
    if(list.isEmpty){
      logPrint("load ad--->${one?"one":"two"}--->$adType list empty");
      return;
    }
    _loadingList.add(adType);
    _startLoadAd(adType, list.first);
  }

  _startLoadAd(AdType adType,MaxAdBean maxAdBean){
    logPrint("load ad--->${one?"one":"two"}--->start load ad, info: ${maxAdBean.toString()}");
    switch(adType){
      case AdType.reward:
        AppLovinMAX.loadRewardedAd(maxAdBean.id??"");
        break;
      case AdType.interstitial:
        AppLovinMAX.loadInterstitial(maxAdBean.id??"");
        break;
    }
  }

  bool checkCache(AdType adType){
    var resultBean = _resultAdMap[adType];
    if(null!=resultBean){
      var expired = DateTime.now().millisecondsSinceEpoch-resultBean.loadTime>((resultBean.maxAdBean.time??3000)*1000);
      if(expired){
        removeAdResult(resultBean.maxAdBean.id);
        return false;
      }else{
        return true;
      }
    }
    return false;
  }

  loadMaxAdSuccess(AdType adType,MaxAd maxAd){
    var list = _getAdListByAdType(adType);
    var indexWhere = list.indexWhere((element) => element.id==maxAd.adUnitId);
    if(indexWhere>=0){
      var maxAdBean = list[indexWhere];
      logPrint("load ad--->${one?"one":"two"}--->$adType load success, id=${maxAdBean.id}");
      _loadingList.remove(adType);
      _resultAdMap[adType]=MaxResultBean(loadTime: DateTime.now().millisecondsSinceEpoch, maxAdBean: maxAdBean);
    }
  }

  loadMaxAdFail(AdType adType,String adUnitId, MaxError error){
    var list = _getAdListByAdType(adType);
    var indexWhere = list.indexWhere((element) => element.id==adUnitId);
    if(indexWhere>=0){
      logPrint("load ad--->${one?"one":"two"}--->$adType load fail, id=$adUnitId, errorCode=${error.code}, errorMsg=${error.message}");
      var nextIndex=indexWhere+1;
      if(list.length>nextIndex){
        logPrint("load ad--->${one?"one":"two"}--->$adType load fail, start next ad");
        _startLoadAd(adType,list[nextIndex]);
      }else{
        logPrint("load ad--->${one?"one":"two"}--->$adType load fail, no next ad");
        _loadingList.remove(adType);
        loadAd(adType);
      }
    }
  }

  List<MaxAdBean> _getAdListByAdType(AdType adType){
    switch(adType){
      case AdType.reward: return rewardList;
      case AdType.interstitial: return intList;
    }
  }

  removeAdResult(String? id){
    _resultAdMap.removeWhere((key, value) => value.maxAdBean.id==id);
  }

  MaxResultBean? getAdResult(AdType adType)=>_resultAdMap[adType];

  MaxAdBean? getMaxAdBeanById(AdType adType, String? id){
    var list = _getAdListByAdType(adType);
    var indexWhere = list.indexWhere((element) => element.id==id);
    if(indexWhere>=0){
      return list[indexWhere];
    }
    return null;
  }
}