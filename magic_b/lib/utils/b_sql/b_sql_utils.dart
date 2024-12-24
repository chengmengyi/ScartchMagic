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
      newMap["time"]=DateTime.now().millisecondsSinceEpoch+60*60*1000;
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
    if(allPlayedNum%10==0){
      return allPlayedNum~/10;
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
    EventInfo(eventCode: EventCode.updateHomeList,strValue: nextPlay);
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

  //返回的是包含今日的提现进度，最多两条
  Future<List<CashTaskBean>> queryCashTaskListByMoneyAndType(int money,int cashType)async{
    var db = await SmSqlUtils.instance.openDB();
    var list = await db.query(SmSqlTable.cashTaskB,where: '"cashMoney" = ? AND "cashType" = ?', whereArgs: [money,cashType]);
    if(list.isEmpty){
      return [];
    }
    List<CashTaskBean> cashTaskList=[];
    var indexWhere = list.indexWhere((element) => element["timer"]==getTodayTime());
    if(indexWhere<0){
      cashTaskList.add(CashTaskBean.fromJson(list.last));
      cashTaskList.add(CashTaskBean());
    }else{
      if(list.length>=2){
        cashTaskList.add(CashTaskBean.fromJson(list[list.length-2]));
        cashTaskList.add(CashTaskBean.fromJson(list.last));
      }else{
        cashTaskList.add(CashTaskBean.fromJson(list.last));
      }
    }
    return cashTaskList;
  }

  Future<void> insertCashTask(int money,int cashType,String account,int taskType)async{
    var db = await SmSqlUtils.instance.openDB();
    var taskBean = CashTaskBean(
      taskType: taskType,
      cashType: cashType,
      cashMoney: money,
      currentPro: 0,
      maxPro: BValueHep.instance.getMaxProByTaskType(taskType),
      maxDays: BValueHep.instance.getMaxDaysByTaskType(taskType),
      timer: getTodayTime(),
      completeStatus: 0,
      account: account,
    );
    await db.insert(SmSqlTable.cashTaskB, taskBean.toJson());
  }

  Future<void> updateCashTaskPro(int taskType)async{
    var db = await SmSqlUtils.instance.openDB();
    var list = await db.query(SmSqlTable.cashTaskB,where: '"taskType" = ?', whereArgs: [taskType]);
    print("kk==updateCashTaskPro===${list}");

    // return;

    if(list.isEmpty){
      return;
    }
    var todayTime = getTodayTime();
    var groupByMap = groupBy(list, (p0) => p0["cashType"]);
    for(var keys in groupByMap.keys){
      var value = groupByMap[keys]??[];
      var indexWhere = value.indexWhere((element) => element["timer"]==todayTime);
      //此提现类型中有今天的数据，更新进度
      if(indexWhere>=0){
        var map = value[indexWhere];
        var newMap = Map<String,Object>.from(map);
        var currentPro = map["currentPro"] as int;
        newMap["currentPro"]=currentPro+1;
        await db.update(SmSqlTable.cashTaskB, newMap,where: "id = ?",whereArgs: [map["id"]]);
      }else{ //此提现类型中没有今天的数据，插入一条进入数据
        var map = value.first;
        var newMap = Map<String,Object>.from(map);
        newMap["currentPro"]=1;
        newMap["timer"]=todayTime;
        newMap.remove("id");
        await db.insert(SmSqlTable.cashTaskB, newMap);
      }
    }
    //判断是否跳转到下一个任务
    _checkToNextCashTask(db,taskType);
  }

  //判断是否跳转到下一个任务
  Future<void> _checkToNextCashTask(Database db,int taskType)async{
    var list = await db.query(SmSqlTable.cashTaskB,where: '"taskType" = ?', whereArgs: [taskType]);

    if(list.isEmpty){
      return;
    }
    var group = groupBy(list, (p0) => p0["cashType"]);
    print("kk==_checkToNextCashTask===${group}");
    for (var keys in group.keys) {
      var value = group[keys]??[];
      if(value.isNotEmpty){
        var firstMap = Map<String,Object>.from(value.first);
        var maxDays = firstMap["maxDays"] as int;
        if(value.length>=maxDays){
          var allDaysPro=value.sublist(value.length-maxDays,value.length).map((e) => e["currentPro"] as int).toList().reduce((value, element) => value+element);
          var maxPro = firstMap["maxPro"] as int;
          print("kk====${keys}===${allDaysPro}==${maxPro}");
          if(allDaysPro>=maxPro){
            //删除指定类型的所有数据
            await db.delete(SmSqlTable.cashTaskB,where: '"taskType" = ?',whereArgs: [taskType]);
            //完成了所有任务
            if(taskType==TaskType.bubble){
              firstMap["completeStatus"]=1;
              firstMap.remove("id");
            }else{ //完成了此项任务，开启下一项任务
              var nextTaskType = _getNextTaskType(taskType);
              firstMap.remove("id");
              firstMap["taskType"]=nextTaskType;
              firstMap["currentPro"]=0;
              firstMap["maxPro"]=BValueHep.instance.getMaxProByTaskType(nextTaskType);
              firstMap["maxDays"]=BValueHep.instance.getMaxDaysByTaskType(nextTaskType);
              firstMap["timer"]=getTodayTime();
            }
            await db.insert(SmSqlTable.cashTaskB, firstMap);
          }
        }
      }
    }
    EventInfo(eventCode: EventCode.updateCashTaskList);
  }

  int _getNextTaskType(int currentTaskType){
    switch(currentTaskType){
      case TaskType.card: return TaskType.wheel;
      case TaskType.wheel: return TaskType.bubble;
      default: return TaskType.card;
    }
  }

  Future<void> deleteTask()async{
    var db = await SmSqlUtils.instance.openDB();
    await db.delete(SmSqlTable.cashTaskB);
  }
}