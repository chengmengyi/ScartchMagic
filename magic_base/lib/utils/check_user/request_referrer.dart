import 'package:android_play_install_referrer/android_play_install_referrer.dart';
import 'package:magic_base/utils/check_user/check_user_utils.dart';

class RequestReferrer{
  var _referrerRequestNum=0;

  init()async{
    if(_referrerRequestNum>=15){
      return;
    }
    try{
      var referrerDetails = await AndroidPlayInstallReferrer.installReferrer;
      var referrerStr=referrerDetails.installReferrer??"";
      if(referrerStr.isNotEmpty){
      }else{
        _referrerRequestNum++;
        init();
      }
    }catch(e){
      _referrerRequestNum++;
      init();
    }
  }
}