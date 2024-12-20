import 'package:flutter/foundation.dart';
import 'package:magic_base/utils/check_user/request_adjust.dart';
import 'package:magic_base/utils/check_user/request_cloak.dart';
import 'package:magic_base/utils/firebase/firebase_utils.dart';
import 'package:magic_base/utils/sm_extension.dart';
import 'package:magic_base/utils/storage/storage_hep.dart';
import 'package:magic_base/utils/tba/ad_pos.dart';
import 'package:magic_base/utils/tba/tba_utils.dart';

StorageHep<bool> adjustBuyUser=StorageHep<bool>(key: "adjustBuyUser", defaultValue: false);
StorageHep<bool> localBuyUser=StorageHep<bool>(key: "localBuyUser", defaultValue: false);


class CheckUserUtils{
  factory CheckUserUtils()=>_getInstance();
  static CheckUserUtils get instance => _getInstance();
  static CheckUserUtils? _instance;
  static CheckUserUtils _getInstance(){
    _instance??=CheckUserUtils._internal();
    return _instance!;

  }

  CheckUserUtils._internal();

  var buyUser=false,_adjustOn="1";
  final RequestCloak _requestCloak=RequestCloak();
  final RequestAdjust _requestAdjust=RequestAdjust();

  initCheck(){
    TbaUtils.instance.pointEvent(pointType: PointType.sm_cloak_req);
    _requestCloak.init();
    _requestAdjust.init();
  }

  checkUser(){
    // if(kDebugMode){
    //   buyUser=true;
    //   return;
    // }
    if(localBuyUser.read()){
      logPrint("check_user--->local is buy");
      buyUser=true;
      return;
    }
    if(!_requestCloak.white){
      logPrint("check_user--->cloak black");
      return;
    }
    if(_adjustOn=="1"&&!adjustBuyUser.read()){
      logPrint("check_user--->adjust black");
      return;
    }
    logPrint("check_user--->is b");
    buyUser=true;
    localBuyUser.write(true);
  }

  getFirebaseConf(){
    var conf = FirebaseUtils.instance.getFirebaseConf("magic_adjust_on");
    if(conf.isNotEmpty){
      _adjustOn=conf;
    }
  }
}