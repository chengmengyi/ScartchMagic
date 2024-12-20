import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:magic_base/utils/b_ad/ad_utils.dart';
import 'package:magic_base/utils/check_user/check_user_utils.dart';
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
  
  readFirebaseConf()async{
    var result = await _initFirebase();
    if(!result){
      Future.delayed(const Duration(milliseconds: 2000),(){
        readFirebaseConf();
      });
      return;
    }
    valueUpdateCall?.call();
    AdUtils.instance.getFirebaseConf();
    CheckUserUtils.instance.getFirebaseConf();
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