import 'dart:convert';
import 'dart:math';

import 'package:magic_base/utils/sm_extension.dart';
import 'package:magic_normal/utils/local_data.dart';
import 'package:magic_normal/utils/normal_sql/play_info_bean.dart';
import 'package:magic_normal/utils/normal_value/value_bean.dart';

class NormalValueHep{
  factory NormalValueHep()=>_getInstance();
  static NormalValueHep get instance => _getInstance();
  static NormalValueHep? _instance;
  static NormalValueHep _getInstance(){
    _instance??=NormalValueHep._internal();
    return _instance!;
  }

  NormalValueHep._internal();

  ValueBean? _valueBean;

  initValue(){
    _valueBean=ValueBean.fromJson(jsonDecode(valueStr.base64()));
  }

  int getMaxWin(String? playType){
    if(playType==PlayType.playfruit.name){
      return _valueBean?.smCardFruit?.winupNumber??50000;
    }else if(playType==PlayType.playbig.name){
      return _valueBean?.smCardNumber?.winupNumber??80000;
    }else if(playType==PlayType.playtiger.name){
      return _valueBean?.smCardTiger?.winupNumber??100000;
    }else if(playType==PlayType.play7.name){
      return _valueBean?.smCard77hot?.winupNumber??150000;
    }else if(playType==PlayType.playemoji.name){
      return _valueBean?.smCardEmoji?.winupNumber??200000;
    }else if(playType==PlayType.play8.name){
      return _valueBean?.smCard8rich?.winupNumber??300000;
    }else{
      return 50000;
    }
  }

  bool getFruitChance()=>Random().nextInt(100)<(_valueBean?.smCardFruit?.point??75);

  int getFruitReward() => _randomReward(_valueBean?.smCardFruit?.prize??[2000,5000]);

  bool getBigChance()=>Random().nextInt(100)<(_valueBean?.smCardNumber?.point??60);

  int getBigReward() => _randomReward(_valueBean?.smCardNumber?.prize??[5000,8000]);

  int getTigerNum(){
    var result = Random().nextInt(100)<(_valueBean?.smCardTiger?.point??50);
    if(!result){
      return 0;
    }
    var cardTiger = _valueBean?.smCardTiger;
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

  int getTigerReward() => _randomReward(_valueBean?.smCardTiger?.prize??[2000,3000]);

  bool getPlay7Chance()=>Random().nextInt(100)<(_valueBean?.smCard77hot?.point7??70);

  bool getPlay77Chance()=>Random().nextInt(100)<(_valueBean?.smCard77hot?.point77??30);

  int getPlay7Reward() => _randomReward(_valueBean?.smCard77hot?.prize??[6000,8000]);

  bool getEmojiChance()=>Random().nextInt(100)<(_valueBean?.smCardEmoji?.pointFace??40);

  int getEmojiReward() => _randomReward(_valueBean?.smCardEmoji?.prize??[10000,20000]);

  bool getPlay8Chance()=>Random().nextInt(100)<(_valueBean?.smCard8rich?.point8bet??20);

  bool getPlay8IconChance()=>Random().nextInt(100)<(_valueBean?.smCard8rich?.point3match??80);

  int getPlay8Reward() => _randomReward(_valueBean?.smCard8rich?.prize??[5000,10000]);

  int _randomReward(List<int> list){
    if(list.length!=2){
      return 0;
    }
    var min = list.first;
    var max = list.last;
    return min + Random().nextInt(max - min + 1);
  }
}