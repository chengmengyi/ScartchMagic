import 'dart:convert';

import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:magic_base/utils/b_ad/ad_utils.dart';
import 'package:magic_base/utils/check_user/check_user_utils.dart';
import 'package:magic_base/utils/data.dart';
import 'package:magic_base/utils/sm_export.dart';
import 'package:magic_base/utils/sm_extension.dart';

class FirebaseUtils{
  factory FirebaseUtils()=>_getInstance();
  static FirebaseUtils get instance => _getInstance();
  static FirebaseUtils? _instance;
  static FirebaseUtils _getInstance(){
    _instance??=FirebaseUtils._internal();
    return _instance!;

  }

  FirebaseUtils._internal();
  
  FirebaseRemoteConfig? _firebaseRemoteConfig;
  Function()? valueUpdateCall;
  final _facebook = FacebookAppEvents();


  readFirebaseConf()async{
    var result = await _initFirebase();
    _initFacebook(result);
    if(result){
      valueUpdateCall?.call();
      AdUtils.instance.getFirebaseConf();
      CheckUserUtils.instance.getFirebaseConf();
    }
  }

  _initFacebook(bool result){
    try{
      String s=facebookInfoStr.base64();
      if(result){
        var fbStr = getFirebaseConf("c68card_fb");
        if(fbStr.isNotEmpty){
          s=fbStr;
        }
      }
      var json = jsonDecode(s);
      _facebook.init(appId: json["app_id"], appToken: json["client_token"], appName: json["app_name"]);
    }catch(e){

    }
  }

  facebookLogPurchase(MaxAd? ad){
    _facebook.logPurchase(amount: ad?.revenue??0.0, currency: "USD");
  }

  test(){
    _initFacebook(true);
  }
  
  Future<bool> _initFirebase()async{
    try{
      await Firebase.initializeApp();
      _firebaseRemoteConfig=FirebaseRemoteConfig.instance;
      await _firebaseRemoteConfig?.setConfigSettings(RemoteConfigSettings(fetchTimeout: const Duration(seconds: 10), minimumFetchInterval: const Duration(seconds: 1)));
      await _firebaseRemoteConfig?.fetchAndActivate();
      return true;
    }catch(e){
      logPrint("init firebase error,$e");
      return false;
    }
  }

  String getFirebaseConf(String key) => _firebaseRemoteConfig?.getString(key)??"";
}