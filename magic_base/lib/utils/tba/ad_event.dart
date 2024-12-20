import 'package:applovin_max/applovin_max.dart';
import 'package:magic_base/sm_sql/sm_sql_utils.dart';
import 'package:magic_base/utils/b_ad/max_ad_bean.dart';
import 'package:magic_base/utils/sm_extension.dart';
import 'package:magic_base/utils/tba/ad_pos.dart';
import 'package:magic_base/utils/tba/base_event.dart';

class AdEvent extends BaseEvent{

  upload(MaxAd maxAd,MaxAdBean? maxAdBean,AdPos adPos,{int tryNum=5})async{
    var baseMap = await getBaseMap();
    baseMap["tsar"]=maxAd.revenue*1000000;
    baseMap["actinide"]="USD";
    baseMap["cannon"]=maxAd.networkName;
    baseMap["galactic"]=maxAdBean?.plat??"";
    baseMap["amende"]=maxAdBean?.id??"";
    baseMap["pratt"]=adPos.name;
    baseMap["po"]=maxAdBean?.type??"";
    baseMap["spar"]=maxAd.revenuePrecision;
    baseMap["cheyenne"]="cocky";
    var dioResult = await request(TbaType.ad, baseMap);
    logPrint("tba--->tba type:${TbaType.ad}--->result:${dioResult.success}--->${adPos.name}");
    if(!dioResult.success){
      if(tryNum>0){
        Future.delayed(const Duration(milliseconds: 2000),(){
          upload(maxAd, maxAdBean, adPos,tryNum: tryNum-1);
        });
      }else{
        SmSqlUtils.instance.insertTbaMap(baseMap);
      }
    }
  }
}