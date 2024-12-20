import 'package:magic_base/sm_sql/sm_sql_utils.dart';
import 'package:magic_base/utils/tba/base_event.dart';

class SqlEvent extends BaseEvent{

  upload()async{
    var tbaMap = await SmSqlUtils.instance.queryTbaMap();
    if(tbaMap.isEmpty){
      return;
    }
    List<String> list=[];
    for (var value in tbaMap) {
      list.add(value["dataMap"] as String);
    }
    var dioResult = await requestList(list);
    if(dioResult.success){
      SmSqlUtils.instance.removeTbaMap();
    }
  }
}