import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:magic_b/utils/b_storage/b_storage_hep.dart';
import 'package:magic_b/utils/cash_task/cash_task_utils.dart';
import 'package:magic_base/utils/b_ad/load_ad.dart';
import 'package:magic_base/utils/data.dart';
import 'package:magic_base/utils/firebase/firebase_utils.dart';
import 'package:magic_base/utils/sm_extension.dart';
import 'package:magic_b/utils/b_sql/play_info_bean.dart';
import 'package:magic_b/utils/b_value/value_bean.dart';

class BValueHep{
  factory BValueHep()=>_getInstance();
  static BValueHep get instance => _getInstance();
  static BValueHep? _instance;
  static BValueHep _getInstance(){
    _instance??=BValueHep._internal();
    return _instance!;
  }

  BValueHep._internal();

  ValueBean? _valueBean;

  initValue(){
    FirebaseUtils.instance.valueUpdateCall=(){
      if(kDebugMode){
        return;
      }
      if(valueConf.read().isEmpty){
        var s = FirebaseUtils.instance.getFirebaseConf("magic_number");
        if(s.isNotEmpty){
          valueConf.write(s);
          _parseValueData();
        }
      }
    };
    _parseValueData();
  }

  int getSignReward(){
    var list = _valueBean?.checkReward??[];
    if(list.length!=2){
      return 3;
    }
    var min = list.first;
    var max = list.last;
    return min + Random().nextInt(max - min + 1);
  }

  List<int> getCashList()=>_valueBean?.cardRange??[1000,1200,1500,2000];

  int getMaxProByTaskType(int taskType){
    var wtdTask = _valueBean?.wtdTask;
    switch(taskType){
      case TaskType.card: return wtdTask?.cardNumber??50;
      case TaskType.wheel: return wtdTask?.wheelNumber??5;
      case TaskType.bubble: return wtdTask?.bubbleNumber??10;
      default: return 50;
    }
  }

  int getMaxDaysByTaskType(int taskType){
    var wtdTask = _valueBean?.wtdTask;
    switch(taskType){
      case TaskType.card: return wtdTask?.cardDay??2;
      case TaskType.wheel: return wtdTask?.wheelDay??3;
      case TaskType.bubble: return wtdTask?.bubbleDay??2;
      default: return 2;
    }
  }

  int getMaxWin(String? playType){
    try{
      if(playType==PlayType.playfruit.name){
        return _valueBean?.winupNumber?[0]??50;
      }else if(playType==PlayType.playbig.name){
        return _valueBean?.winupNumber?[1]??60;
      }else if(playType==PlayType.playtiger.name){
        return _valueBean?.winupNumber?[2]??60;
      }else if(playType==PlayType.play7.name){
        return _valueBean?.winupNumber?[3]??80;
      }else if(playType==PlayType.playemoji.name){
        return _valueBean?.winupNumber?[4]??90;
      }else if(playType==PlayType.play8.name){
        return _valueBean?.winupNumber?[5]??100;
      }else{
        return 50;
      }
    }catch(e){
      return 50;
    }
  }

  bool checkHasKey(){
    // if(kDebugMode){
    //   return true;
    // }
    var list = _valueBean?.keyOut??[];
    if(list.isEmpty){
      return false;
    }
    var userCoins = coins.read();
    var last = list.last;
    if(userCoins>=(last.endNumber??1000)){
      return Random().nextInt(100)<(last.point??5);
    }
    for (var value in list) {
      if(userCoins>=(value.firstNumber??0)&&userCoins<(value.endNumber??0)){
        return Random().nextInt(100)<(value.point??5);
      }
    }
    return false;
  }

  bool checkShowIntAd(AdType adType){
    if(kDebugMode){
      return false;
    }
    if(adType==AdType.reward){
      return true;
    }
    var list = _valueBean?.intadPoint??[];
    if(list.isEmpty){
      return false;
    }
    var userCoins = coins.read();
    var last = list.last;
    if(userCoins>=(last.endNumber??1000)){
      return Random().nextInt(100)<(last.point??5);
    }
    for (var value in list) {
      if(userCoins>=(value.firstNumber??0)&&userCoins<(value.endNumber??0)){
        return Random().nextInt(100)<(value.point??5);
      }
    }
    return false;
  }

  int getBoxReward(){
    var list = _valueBean?.boxPrize??[];
    if(list.isEmpty){
      return 1;
    }
    return _randomReward(list);
  }

  int getBubbleReward(){
    var list = _valueBean?.floatPrize??[];
    if(list.isEmpty){
      return 1;
    }
    return _randomReward(list);
  }

  bool getFruitChance()=>Random().nextInt(100)<(_valueBean?.cardFruit?.point??75);

  int getFruitReward() => _randomReward(_valueBean?.cardFruit?.prize??[]);

  bool getBigChance()=>Random().nextInt(100)<(_valueBean?.cardNumber?.point??50);

  int getBigReward() => _randomReward(_valueBean?.cardNumber?.prize??[]);

  int getTigerNum(){
    var result = Random().nextInt(100)<(_valueBean?.cardTiger?.point??50);
    if(!result){
      return 0;
    }
    var cardTiger = _valueBean?.cardTiger;
    var tiger3 = cardTiger?.tiger3??50;
    var tiger4 = cardTiger?.tiger4??20;
    var tiger5 = cardTiger?.tiger5??10;
    var tiger6 = cardTiger?.tiger6??9;
    var tiger7 = cardTiger?.tiger7??7;
    var tiger8 = cardTiger?.tiger8??3;
    var tiger9 = cardTiger?.tiger9??1;
    var index = Random().nextInt(100);
    if(index<tiger3){
      return 3;
    }else if(index>=tiger3&&index<(tiger3+tiger4)){
      return 4;
    }else if(index>=(tiger3+tiger4)&&index<(tiger3+tiger4+tiger5)){
      return 5;
    }else if(index>=(tiger3+tiger4+tiger5)&&index<(tiger3+tiger4+tiger5+tiger6)){
      return 6;
    }else if(index>=(tiger3+tiger4+tiger5+tiger6)&&index<(tiger3+tiger4+tiger5+tiger6+tiger7)){
      return 7;
    }else if(index>=(tiger3+tiger4+tiger5+tiger6+tiger7)&&index<(tiger3+tiger4+tiger5+tiger6+tiger7+tiger8)){
      return 8;
    }else{
      return 9;
    }
  }

  int getWheelAddNum(){
    var wheelPoint = _valueBean?.wheelPoint;
    var point20 = wheelPoint?.point20??70;
    var point50 = wheelPoint?.point50??25;
    var point80 = wheelPoint?.point80??5;
    var point100 = wheelPoint?.point100??0;
    var index = Random().nextInt(100);
    if(index<point20){
      return 20;
    }else if(index>=point20&&index<(point20+point50)){
      return 50;
    }else if(index>=(point20+point50)&&index<(point20+point50+point80)){
      return 80;
    }
    return 20;
  }

  int getTigerReward() => _randomReward(_valueBean?.cardTiger?.prize??[]);

  bool getPlay7Chance()=>Random().nextInt(100)<(_valueBean?.card77hot?.point7??50);

  bool getPlay77Chance()=>Random().nextInt(100)<(_valueBean?.card77hot?.point77??30);

  int getPlay7Reward() => _randomReward(_valueBean?.card77hot?.prize??[]);

  bool getEmojiChance()=>Random().nextInt(100)<(_valueBean?.cardEmoji?.pointFace??40);

  int getEmojiReward() => _randomReward(_valueBean?.cardEmoji?.prize??[]);

  bool getPlay8Chance()=>Random().nextInt(100)<(_valueBean?.card8rich?.point8bet??20);

  bool getPlay8IconChance()=>Random().nextInt(100)<(_valueBean?.card8rich?.point3match??60);

  int getPlay8Reward() => _randomReward(_valueBean?.card8rich?.prize??[]);

  int _randomReward(List<Prize> list){
    if(list.isEmpty){
      return 1;
    }
    var userCoins = coins.read();
    var last = list.last;
    if(userCoins>=(last.endNumber??1000)){
      var min = last.prize?.first??1;
      var max = last.prize?.last??5;
      return min + Random().nextInt(max - min + 1);
    }
    for (var value in list) {
      if(userCoins>=(value.firstNumber??0)&&userCoins<(value.endNumber??0)){
        var min = value.prize?.first??1;
        var max = value.prize?.last??5;
        return min + Random().nextInt(max - min + 1);
      }
    }
    return 1;
  }

  _parseValueData(){
    var s = valueConf.read();
    if(s.isEmpty){
      s=valueStrB.base64();
    }
    _valueBean=ValueBean.fromJson(jsonDecode(s));
  }
}