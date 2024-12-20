import 'dart:io';

import 'package:flutter_tba_info/flutter_tba_info.dart';
import 'package:magic_base/utils/data.dart';
import 'package:magic_base/utils/dio/dio_result.dart';
import 'package:magic_base/utils/dio/dio_utils.dart';
import 'package:magic_base/utils/sm_extension.dart';

enum TbaType{
  install,session,ad,point,
}

class BaseEvent{
  Future<Map<String,dynamic>> getBaseMap() async => {
    "transmit" : await FlutterTbaInfo.instance.getDeviceModel(),
    "callus" : await FlutterTbaInfo.instance.getOsCountry(),
    "come" : await FlutterTbaInfo.instance.getOsVersion(),
    "visor" : await FlutterTbaInfo.instance.getDistinctId(),
    "bath" : await FlutterTbaInfo.instance.getNetworkType(),
    "dupe" : await FlutterTbaInfo.instance.getBundleId(),
    "margaret" : await FlutterTbaInfo.instance.getOperator(),
    "shall" : Platform.isAndroid?"quirt":"batik",
    "ethel" : await FlutterTbaInfo.instance.getGaid(),
    "charon" : DateTime.now().millisecondsSinceEpoch,
    "anxious" : await FlutterTbaInfo.instance.getSystemLanguage(),
    "bellyful" : await FlutterTbaInfo.instance.getIdfa(),
    "spandrel" : await FlutterTbaInfo.instance.getAppVersion(),
    "tioga" : await FlutterTbaInfo.instance.getLogId(),
    "smyrna" : await FlutterTbaInfo.instance.getManufacturer(),
    "alumina" : await FlutterTbaInfo.instance.getIdfv(),
    "door" : await FlutterTbaInfo.instance.getBrand(),
    "hecatomb" : await FlutterTbaInfo.instance.getAndroidId(),
  };

  Future<DioResult> request(TbaType type,Map<String,dynamic> map)async{
    var header = await _getHeaderMap();
    var path = await _getRequestStr();
    logPrint("tba--->tba type:$type--->path:$path");
    logPrint("tba--->tba type:$type--->map:$map");
    return await DioUtils.instance.requestPost(
      url: path,
      dataMap: map,
      headerMap: header,
    );
  }


  Future<DioResult> requestList(List list)async{
    var header = await _getHeaderMap();
    header["Content-Encoding"]="gzip";
    var path = await _getRequestStr();
    logPrint("tba--->request list--->${list.length}");
    return await DioUtils.instance.requestListPost(
      url: path,
      list: list,
      headerMap: header,
    );
  }

  Future<Map<String,dynamic>> _getHeaderMap() async => {
    "bellyful" : await FlutterTbaInfo.instance.getIdfa(),
    "tioga" : await FlutterTbaInfo.instance.getLogId(),
  };

  Future<String> _getRequestStr() async => "$tbaStr?margaret=${await FlutterTbaInfo.instance.getOperator()}&transmit=${await FlutterTbaInfo.instance.getDeviceModel()}&smyrna=${await FlutterTbaInfo.instance.getManufacturer()}&door=${await FlutterTbaInfo.instance.getBrand()}";
}