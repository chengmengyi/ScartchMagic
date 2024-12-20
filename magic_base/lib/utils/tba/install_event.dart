import 'package:flutter_tba_info/flutter_tba_info.dart';
import 'package:magic_base/utils/sm_extension.dart';
import 'package:magic_base/utils/tba/base_event.dart';
import 'package:magic_base/utils/tba/tba_utils.dart';


class InstallEvent extends BaseEvent{

  upload()async{
    var map = await getInstallMap();
    var result = await request(TbaType.install, map);
    logPrint("tba--->tba type:${TbaType.install}--->result:${result.success}");
    if(result.success){
      installUpload.write(true);
    }
  }

  Future<Map<String,dynamic>> getInstallMap()async{
    var map = await getBaseMap();
    var referrerMap = await FlutterTbaInfo.instance.getReferrerMap();
    map["spume"]={
      "bigelow" : referrerMap["build"],
      "trample" : referrerMap["install_version"],
      "swanson" : referrerMap["user_agent"],
      "quetzal" : "mangrove",
      "by" : referrerMap["referrer_click_timestamp_seconds"],
      "racket" : referrerMap["install_begin_timestamp_seconds"],
      "eyepiece" : referrerMap["referrer_click_timestamp_server_seconds"],
      "seal" : referrerMap["install_begin_timestamp_server_seconds"],
      "bequeath" : referrerMap["install_first_seconds"],
      "subtle" : referrerMap["last_update_seconds"],
      "wiremen" : referrerMap["google_play_instant"],
    };
    return map;
  }
}