import 'dart:io';

import 'package:flutter_tba_info/flutter_tba_info.dart';
import 'package:magic_base/utils/check_user/check_user_utils.dart';
import 'package:magic_base/utils/data.dart';
import 'package:magic_base/utils/dio/dio_utils.dart';
import 'package:magic_base/utils/sm_extension.dart';
import 'package:magic_base/utils/tba/ad_pos.dart';
import 'package:magic_base/utils/tba/tba_utils.dart';

class RequestCloak{
  var white=false;

  init()async{
    var bundleId = await FlutterTbaInfo.instance.getBundleId();
    var os = Platform.isAndroid?"quirt":"batik";
    var appVersion = await FlutterTbaInfo.instance.getAppVersion();
    var distinctId = await FlutterTbaInfo.instance.getDistinctId();
    var clientTs = DateTime.now().millisecondsSinceEpoch;
    var deviceModel = await FlutterTbaInfo.instance.getDeviceModel();
    var osVersion = await FlutterTbaInfo.instance.getOsVersion();
    var idfv = await FlutterTbaInfo.instance.getIdfv();
    var gaid = await FlutterTbaInfo.instance.getGaid();
    var androidId = await FlutterTbaInfo.instance.getAndroidId();
    var idfa = await FlutterTbaInfo.instance.getIdfa();
    var networkType = await FlutterTbaInfo.instance.getNetworkType();
    var operator = await FlutterTbaInfo.instance.getOperator();
    var path="$cloakStr?dupe=$bundleId&shall=$os&spandrel=$appVersion&visor=$distinctId&charon=$clientTs&transmit=$deviceModel&come=$osVersion&alumina=$idfv&ethel=$gaid&hecatomb=$androidId&bellyful=$idfa&bath=$networkType&margaret=$operator";
    logPrint("check_user--->cloak url--->$path");
    var dioResult = await DioUtils.instance.requestGet(url: path);
    logPrint("check_user--->cloak result--->${dioResult.success}--->${dioResult.result}");
    if(dioResult.success&&(dioResult.result=="salvo"||dioResult.result=="len")){
      TbaUtils.instance.pointEvent(pointType: PointType.sm_cloak_suc,data: {"cloak_user":dioResult.result=="salvo"?"0":"1"});
      white=dioResult.result=="len";
    }else{
      Future.delayed(const Duration(milliseconds: 1000),(){
        init();
      });
    }
  }
}