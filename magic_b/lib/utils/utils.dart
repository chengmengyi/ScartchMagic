import 'package:magic_base/sm_router/all_routers_name.dart';
import 'package:magic_base/sm_router/sm_routers_utils.dart';
import 'package:magic_b/utils/b_sql/b_sql_utils.dart';
import 'package:magic_b/utils/b_sql/play_info_bean.dart';
import 'package:magic_base/utils/event/event_code.dart';
import 'package:magic_base/utils/event/event_info.dart';

class Utils{
  static toNextPlay(PlayType playType)async{
    var list = await BSqlUtils.instance.queryPlayList();
    var indexWhere = list.indexWhere((element) => (element.time??0)<=0,list.indexWhere((element) => element.type==playType.name)+1);
    if(indexWhere<0){
      SmRoutersUtils.instance.offPage();
      return;
    }

    var currentType = list[indexWhere].type??"";
    var nextPlayType = PlayType.values.firstWhere((element) => element.name==currentType);
    // if(currentType==PlayType.playfruit.name){
    //   nextPlayType=PlayType.playfruit;
    // }else if(currentType==PlayType.playbig.name){
    //   nextPlayType=PlayType.playbig;
    // }else if(currentType==PlayType.playtiger.name){
    //   nextPlayType=PlayType.playtiger;
    // }else if(currentType==PlayType.play7.name){
    //   nextPlayType=PlayType.play7;
    // }else if(currentType==PlayType.playemoji.name){
    //   nextPlayType=PlayType.playemoji;
    // }else if(currentType==PlayType.play8.name){
    //   nextPlayType=PlayType.play8;
    // }
    await BSqlUtils.instance.unlockNextPlay(currentType);
    EventInfo(eventCode: EventCode.toNextCardChild,dynamicValue: nextPlayType);
  }
}