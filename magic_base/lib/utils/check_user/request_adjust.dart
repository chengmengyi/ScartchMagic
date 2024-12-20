import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_config.dart';
import 'package:flutter_tba_info/flutter_tba_info.dart';
import 'package:magic_base/utils/check_user/check_user_utils.dart';
import 'package:magic_base/utils/data.dart';
import 'package:magic_base/utils/sm_extension.dart';
import 'package:magic_base/utils/tba/ad_pos.dart';
import 'package:magic_base/utils/tba/tba_utils.dart';

class RequestAdjust{
  
  init()async{
    TbaUtils.instance.pointEvent(pointType: PointType.sm_adjust_req);
    Adjust.addSessionCallbackParameter("customer_user_id", await FlutterTbaInfo.instance.getDistinctId());
    var adjustConfig = AdjustConfig(adjustTokenStr, AdjustEnvironment.production);
    adjustConfig.attributionCallback=(attr){
      var network = attr.network??"";
      logPrint("check_user--->adjust_result--->$network");
      TbaUtils.instance.pointEvent(pointType: PointType.sm_adjust_suc,data: {"adj_user":!network.contains("Organic")?"1":"0"});
      if(network.isNotEmpty&&!network.contains("Organic")&&!adjustBuyUser.read()){
        TbaUtils.instance.pointEvent(pointType: PointType.organic_to_buy);
        adjustBuyUser.write(true);
      }
    };
    Adjust.start(adjustConfig);
  }
}