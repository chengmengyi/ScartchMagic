import 'package:magic_b/utils/b_value/b_value_hep.dart';
import 'package:magic_b/utils/cash_task/cash_list_bean.dart';
import 'package:magic_b/utils/cash_task/cash_task_utils.dart';
import 'package:magic_base/sm_sql/sm_sql_utils.dart';
import 'package:magic_base/utils/event/event_code.dart';
import 'package:magic_base/utils/event/event_info.dart';
import 'package:magic_b/utils/b_sql/play_info_bean.dart';
import 'package:magic_base/utils/sm_extension.dart';
import 'package:collection/collection.dart';
import 'package:sqflite_common/sqlite_api.dart';

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
    var list = await db.query(SmSqlTable.newPlayInfoB);
    if(list.isEmpty){
      var defaultList=[
        PlayInfoBean(type: PlayType.playfruit.name,hasNum: 10,playedNum: 0,),
        PlayInfoBean(type: PlayType.playbig.name,hasNum: 10,playedNum: 0,),
        PlayInfoBean(type: PlayType.playtiger.name,hasNum: 10,playedNum: 0,),
        PlayInfoBean(type: PlayType.play7.name,hasNum: 10,playedNum: 0,),
        PlayInfoBean(type: PlayType.playemoji.name,hasNum: 10,playedNum: 0,),
        PlayInfoBean(type: PlayType.play8.name,hasNum: 10,playedNum: 0,),
      ];
      for (var value in defaultList) {
        db.insert(SmSqlTable.newPlayInfoB, value.toJson());
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
    var list = await db.query(SmSqlTable.newPlayInfoB,where: '"type" = ? ', whereArgs: [playType.name]);
    if(list.isEmpty){
      return 0;
    }
    var map = list.first;
    var id = map["id"];
    var playedNum = map["playedNum"] as int;
    var newMap = Map<String, Object?>.from(map);
    newMap["playedNum"]=playedNum+1;
    await db.update(SmSqlTable.newPlayInfoB, newMap,where: '"id" = ?',whereArgs: [id]);
    EventInfo(eventCode: EventCode.updateLevelPro);
    EventInfo(eventCode: EventCode.updateHomeList);

    var queryPlayList = await BSqlUtils.instance.queryPlayList();
    var allPlayedNum=0;
    for (var value in queryPlayList) {
      allPlayedNum+=(value.playedNum??0);
    }
    if(allPlayedNum%10==0){
      return allPlayedNum~/10;
    }
    return 0;
  }

  // Future<void> unlockNextPlay(String nextPlay)async{
  //   var db = await SmSqlUtils.instance.openDB();
  //   var list = await db.query(SmSqlTable.playInfoB,where: '"type" = ? ', whereArgs: [nextPlay]);
  //   if(list.isEmpty){
  //     return;
  //   }
  //   var map = list.first;
  //   var id = map["id"];
  //   var newMap = Map<String, Object?>.from(map);
  //   newMap["unlock"]=1;
  //   await db.update(SmSqlTable.playInfoB, newMap,where: '"id" = ?',whereArgs: [id]);
  //   EventInfo(eventCode: EventCode.updateHomeList,strValue: nextPlay);
  // }

  // Future<void> resetPlayTime(String playType)async{
  //   var db = await SmSqlUtils.instance.openDB();
  //   var list = await db.query(SmSqlTable.playInfoB,where: '"type" = ? ', whereArgs: [playType]);
  //   if(list.isEmpty){
  //     return;
  //   }
  //   var map = list.first;
  //   var id = map["id"];
  //   var newMap = Map<String, Object?>.from(map);
  //   newMap["time"]=0;
  //   newMap["currentPro"]=0;
  //   await db.update(SmSqlTable.playInfoB, newMap,where: '"id" = ?',whereArgs: [id]);
  //   EventInfo(eventCode: EventCode.updateHomeList);
  // }

  Future<CashTaskBean?> queryCashTaskListByMoneyAndType(int money,int cashType)async{
    var db = await SmSqlUtils.instance.openDB();
    var list = await db.query(SmSqlTable.cashTaskB2,where: '"cashMoney" = ? AND "cashType" = ?', whereArgs: [money,cashType]);
    if(list.isEmpty){
      return null;
    }
    return CashTaskBean.fromJson(list.first);
  }

  Future<void> insertCashTask(int money,int cashType,String account,int taskType)async{
    var db = await SmSqlUtils.instance.openDB();
    var taskBean = CashTaskBean(
      taskType: taskType,
      taskKey: TaskKey.card1Number,
      cashType: cashType,
      cashMoney: money,
      currentPro: 0,
      maxPro: BValueHep.instance.getMaxProByTaskKey(TaskKey.card1Number),
      completeStatus: 0,
      account: account,
    );
    await db.insert(SmSqlTable.cashTaskB2, taskBean.toJson());
  }

  Future<void> updateCashTaskPro(int taskType)async{
    var db = await SmSqlUtils.instance.openDB();
    var list = await db.query(SmSqlTable.cashTaskB2,where: '"taskType" = ?', whereArgs: [taskType]);
    print("kk==updateCashTaskPro===${list}");
    if(list.isEmpty){
      return;
    }
    for (var value in list) {
      var newMap = Map<String,Object>.from(value);
      var currentPro = newMap["currentPro"] as int;
      var maxPro = newMap["maxPro"] as int;
      var taskKey = newMap["taskKey"] as String;
      //已完成当前任务
      if(currentPro>=maxPro-1){
        var nextTaskKey = _getNextTaskKey(taskKey);
        //已完成所有任务
        if(nextTaskKey.isEmpty){
          newMap["completeStatus"]=1;
        }else{ //跳转到下一个任务
          newMap["taskKey"]=nextTaskKey;
          newMap["taskType"]=_getNextTaskTypeByKey(taskKey);
          newMap["currentPro"]=0;
          newMap["maxPro"]=BValueHep.instance.getMaxProByTaskKey(nextTaskKey);
        }
      }else{
        newMap["currentPro"]=currentPro+1;
      }
      await db.update(SmSqlTable.cashTaskB2, newMap,where: "id = ?",whereArgs: [value["id"]]);
    }
    EventInfo(eventCode: EventCode.updateCashTaskList);
  }

  String _getNextTaskKey(String currentTaskKey){
    switch(currentTaskKey){
      case TaskKey.card1Number: return TaskKey.bubble1Number;
      case TaskKey.bubble1Number: return TaskKey.wheel1Number;
      case TaskKey.wheel1Number: return TaskKey.card2Number;
      case TaskKey.card2Number: return TaskKey.bubble2Number;
      case TaskKey.bubble2Number: return TaskKey.wheel2Number;
      case TaskKey.wheel2Number: return TaskKey.card3Number;
      case TaskKey.card3Number: return TaskKey.bubble3Number;
      case TaskKey.bubble3Number: return TaskKey.wheel3Number;
      default: return "";
    }
  }

  int _getNextTaskTypeByKey(String currentTaskKey){
    switch(currentTaskKey){
      case TaskKey.card1Number:
      case TaskKey.card2Number:
      case TaskKey.card3Number:
        return TaskType.bubble;
      case TaskKey.bubble1Number:
      case TaskKey.bubble2Number:
      case TaskKey.bubble3Number:
        return TaskType.wheel;
      case TaskKey.wheel1Number:
      case TaskKey.wheel2Number:
        return TaskType.card;
      default: return -1;
    }
  }

  // Future<void> deleteTask()async{
  //   var db = await SmSqlUtils.instance.openDB();
  //   await db.delete(SmSqlTable.cashTaskB);
  // }

  checkVersion2HasTask()async{
    var db = await SmSqlUtils.instance.openDB();
    var list = await db.query(SmSqlTable.cashTaskB);
    print(list);
    //[{id: 1, taskType: 1, cashType: 0, cashMoney: 1000, currentPro: 0, maxPro: 50, completeStatus: 0, maxDays: 2, timer: 2025-2-9, account: 5555666}]
    if(list.isNotEmpty){
      for (var map in list) {
        var cashMoney = map["cashMoney"] as int;
        var cashType = map["cashType"] as int;
        var account = map["account"] as String;
        await insertCashTask(cashMoney, cashType, account, TaskType.card);
      }
      await db.delete(SmSqlTable.cashTaskB);
    }
  }
}