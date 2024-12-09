import 'package:magic_base/sm_sql/sm_sql_utils.dart';
import 'package:magic_base/utils/event/event_code.dart';
import 'package:magic_base/utils/event/event_info.dart';
import 'package:magic_b/utils/b_sql/play_info_bean.dart';

class BSqlUtils{
  factory BSqlUtils()=>_getInstance();
  static BSqlUtils get instance => _getInstance();
  static BSqlUtils? _instance;
  static BSqlUtils _getInstance(){
    _instance??=BSqlUtils._internal();
    return _instance!;
  }

  BSqlUtils._internal();

  Future<List<PlayInfoBean>> queryPlayList()async{
    var db = await SmSqlUtils.instance.openDB();
    var list = await db.query(SmSqlTable.playInfoB);
    if(list.isEmpty){
      var defaultList=[
        PlayInfoBean(type: PlayType.playfruit.name,currentPro: 0,playedNum: 0,unlock: 1,time: 0),
        PlayInfoBean(type: PlayType.playbig.name,currentPro: 0,playedNum: 0,unlock: 0,time: 0),
        PlayInfoBean(type: PlayType.playtiger.name,currentPro: 0,playedNum: 0,unlock: 0,time: 0),
        PlayInfoBean(type: PlayType.play7.name,currentPro: 0,playedNum: 0,unlock: 0,time: 0),
        PlayInfoBean(type: PlayType.playemoji.name,currentPro: 0,playedNum: 0,unlock: 0,time: 0),
        PlayInfoBean(type: PlayType.play8.name,currentPro: 0,playedNum: 0,unlock: 0,time: 0),
      ];
      for (var value in defaultList) {
        db.insert(SmSqlTable.playInfoB, value.toJson());
      }
      return defaultList;
    }
    List<PlayInfoBean> resultList=[];
    for (var value in list) {
      resultList.add(PlayInfoBean.fromJson(value));
    }
    return resultList;
  }
  ///return  >0升级了 =0没升级
  Future<int> updatePlayedNumInfo(PlayType playType)async{
    var db = await SmSqlUtils.instance.openDB();
    var list = await db.query(SmSqlTable.playInfoB,where: '"type" = ? ', whereArgs: [playType.name]);
    if(list.isEmpty){
      return 0;
    }
    var map = list.first;
    var id = map["id"];
    var playedNum = map["playedNum"] as int;
    var currentPro = map["currentPro"] as int;
    var newMap = Map<String, Object?>.from(map);
    newMap["playedNum"]=playedNum+1;
    newMap["currentPro"]=currentPro+1;
    if(currentPro+1>=10){
      newMap["time"]=DateTime.now().millisecondsSinceEpoch+10*60*60*1000;
    }
    await db.update(SmSqlTable.playInfoB, newMap,where: '"id" = ?',whereArgs: [id]);
    EventInfo(eventCode: EventCode.updateLevelPro);
    // if(playedNum+1>=10){
    //   EventInfo(eventCode: EventCode.updateHomeList);
    // }
    EventInfo(eventCode: EventCode.updateHomeList);

    var queryPlayList = await BSqlUtils.instance.queryPlayList();
    var allPlayedNum=0;
    for (var value in queryPlayList) {
      allPlayedNum+=(value.playedNum??0);
    }
    if(allPlayedNum%5==0){
      return allPlayedNum~/5;
    }
    return 0;
  }

  Future<void> unlockNextPlay(String nextPlay)async{
    var db = await SmSqlUtils.instance.openDB();
    var list = await db.query(SmSqlTable.playInfoB,where: '"type" = ? ', whereArgs: [nextPlay]);
    if(list.isEmpty){
      return;
    }
    var map = list.first;
    var id = map["id"];
    var newMap = Map<String, Object?>.from(map);
    newMap["unlock"]=1;
    await db.update(SmSqlTable.playInfoB, newMap,where: '"id" = ?',whereArgs: [id]);
    EventInfo(eventCode: EventCode.updateHomeList);
  }

  Future<void> resetPlayTime(String playType)async{
    var db = await SmSqlUtils.instance.openDB();
    var list = await db.query(SmSqlTable.playInfoB,where: '"type" = ? ', whereArgs: [playType]);
    if(list.isEmpty){
      return;
    }
    var map = list.first;
    var id = map["id"];
    var newMap = Map<String, Object?>.from(map);
    newMap["time"]=0;
    newMap["currentPro"]=0;
    await db.update(SmSqlTable.playInfoB, newMap,where: '"id" = ?',whereArgs: [id]);
    EventInfo(eventCode: EventCode.updateHomeList);
  }
}