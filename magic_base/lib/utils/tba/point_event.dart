import 'package:magic_base/sm_sql/sm_sql_utils.dart';
import 'package:magic_base/utils/sm_extension.dart';
import 'package:magic_base/utils/tba/ad_pos.dart';
import 'package:magic_base/utils/tba/base_event.dart';

class PointEvent extends BaseEvent{

  upload({required PointType pointType, Map<String,dynamic>? data,int tryNum=5})async{
    var map = await getBaseMap();
    map["cheyenne"]=pointType.name;
    if(null!=data){
      map[pointType.name]=data;
    }
    var result = await request(TbaType.point, map);
    logPrint("tba--->tba type:${TbaType.point}--->result:${result.success}--->${pointType.name}");
    if(!result.success){
      if(tryNum>0){
        Future.delayed(const Duration(milliseconds: 2000),(){
          upload(pointType: pointType,data: data,tryNum: tryNum-1);
        });
      }else{
        SmSqlUtils.instance.insertTbaMap(map);
      }
    }
  }
}