import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:flutter_tba_info/flutter_tba_info.dart';
import 'package:magic_base/utils/check_user/check_user_utils.dart';
import 'package:magic_base/utils/data.dart';
import 'package:magic_base/utils/sm_export.dart';
import 'package:magic_base/utils/sm_extension.dart';
import 'package:magic_base/utils/tba/ad_pos.dart';
import 'package:magic_base/utils/tba/tba_utils.dart';

class RequestAdjust{

  AppsflyerSdk? _appsflyerSdk;
  
  init()async{
    // TbaUtils.instance.pointEvent(pointType: PointType.sm_adjust_req);
    // Adjust.addSessionCallbackParameter("customer_user_id", await FlutterTbaInfo.instance.getDistinctId());
    // var adjustConfig = AdjustConfig(adjustTokenStr, AdjustEnvironment.production);
    // adjustConfig.attributionCallback=(attr){
    //   var network = attr.network??"";
    //   logPrint("check_user--->adjust_result--->$network");
    //   TbaUtils.instance.pointEvent(pointType: PointType.sm_adjust_suc,data: {"adj_user":!network.contains("Organic")?"1":"0"});
    //   if(network.isNotEmpty&&!network.contains("Organic")&&!adjustBuyUser.read()){
    //     TbaUtils.instance.pointEvent(pointType: PointType.organic_to_buy);
    //     adjustBuyUser.write(true);
    //   }
    // };
    // Adjust.start(adjustConfig);


    _appsflyerSdk=AppsflyerSdk(AppsFlyerOptions(
      afDevKey: "P2Z2vZ6Sp7DTKbZ23XhKbS",
      timeToWaitForATTUserAuthorization: 8,
      disableAdvertisingIdentifier: false,
      disableCollectASA: false,
      manualStart: true,
    ));

    await _appsflyerSdk?.initSdk(registerConversionDataCallback: true);
    var s = await FlutterTbaInfo.instance.getDistinctId();
    _appsflyerSdk?.setCustomerUserId(s);
    _appsflyerSdk?.onInstallConversionData((res){
      logPrint("check user---> request af result-->$res");
      try{
        if(res["status"]=="success"){
          var status = res["payload"]["af_status"].toString();
          var isB = !status.contains("Organic");
          TbaUtils.instance.pointEvent(pointType: PointType.sm_adjust_suc,data: {"adj_user":isB?"1":"0"});
          if(isB&&!adjustBuyUser.read()){
            TbaUtils.instance.pointEvent(pointType: PointType.organic_to_buy);
            adjustBuyUser.write(true);
          }
        }
      }catch(e){

      }
    });

    TbaUtils.instance.pointEvent(pointType: PointType.sm_adjust_req);
    _startAf();
  }

  _startAf(){
    logPrint("check user---> start request af");
    _appsflyerSdk?.startSDK(
        onSuccess: (){
          logPrint("check user---> initAppsflyer success");
        },
        onError: (code,msg){
          logPrint("check user---> initAppsflyer fail--->$code---->$msg");
          Future.delayed(const Duration(milliseconds: 1000),(){
            _startAf();
          });
        }
    );
  }

  uploadAdRevenue(MaxAd? ad,String adId,AdPos adPos){
    _appsflyerSdk?.logAdRevenue(
        AdRevenueData(
            monetizationNetwork: ad?.networkName??"",
            mediationNetwork: AFMediationNetwork.applovinMax.value,
            currencyIso4217Code: "USD",
            revenue: ad?.revenue??0,
            additionalParameters: {
              "adRevenueUnit": adId,
              "adRevenuePlacement": adPos.name,
            }
        )
    );
  }
}