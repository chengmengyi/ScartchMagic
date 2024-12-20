import 'dart:async';

import 'package:flutter/material.dart';
import 'package:magic_b/page/page/play/play_child/play_emoji/emoji_bean.dart';
import 'package:magic_b/page/widget/dialog/incent/incent_dialog.dart';
import 'package:magic_base/base_widget/sm_base_controller.dart';
import 'package:magic_base/sm_router/sm_routers_utils.dart';
import 'package:magic_base/utils/event/event_code.dart';
import 'package:magic_base/utils/event/event_info.dart';
import 'package:magic_base/utils/sm_export.dart';
import 'package:magic_base/utils/sm_extension.dart';
import 'package:magic_b/enums/play_result_status.dart';
import 'package:magic_b/page/widget/dialog/up_level_dialog/up_level_dialog.dart';
import 'package:magic_b/page/widget/dialog/win_dialog/win_dialog.dart';
import 'package:magic_b/utils/auto_scratch_utils.dart';
import 'package:magic_b/utils/info_hep.dart';
import 'package:magic_b/utils/b_sql/b_sql_utils.dart';
import 'package:magic_b/utils/b_sql/play_info_bean.dart';
import 'package:magic_b/utils/b_value/b_value_hep.dart';
import 'package:magic_b/utils/utils.dart';
import 'package:magic_base/utils/tba/ad_pos.dart';
import 'package:magic_base/utils/tba/tba_utils.dart';

class PlayEmojiChildController extends SmBaseController{
  final key = GlobalKey<ScratcherState>();
  var _win=false,_canClick=true,prizeBorderIndex=-1,hideKeyIcon=false,playResultStatus=PlayResultStatus.init;
  Timer? _timer;
  final PlayType _playType=PlayType.playemoji;
  List<EmojiBean> emojiList=[];
  final Map<int,List<int>> _lineMap={
    0:[0,1,2],
    1:[3,4,5],
    2:[6,7,8],
    3:[0,3,6],
    4:[1,4,7],
    5:[2,5,8],
    6:[0,4,8],
    7:[2,4,6],
  };

  GlobalKey globalKey=GlobalKey();
  GlobalKey contentGlobalKey=GlobalKey();
  GlobalKey keyGlobalKey=GlobalKey();
  Offset? iconOffset;
  AutoScratchUtils? autoScratchUtils;


  @override
  void onInit() {
    super.onInit();
    while(emojiList.length<9){
      emojiList.add(EmojiBean(icon: "", reward: 0));
    }
  }

  @override
  void onReady() {
    super.onReady();
    _initEmojiList();
    autoScratchUtils=AutoScratchUtils(globalKey);
  }


  clickOpen(){
    if(!_canClick){
      return;
    }
    _canClick=false;
    autoScratchUtils?.startAuto(
      key: key,
      iconOffsetCall: (offset){
        iconOffset=offset;
        update(["gold_icon"]);
      },
    );
  }

  onThreshold()async{
    autoScratchUtils?.stopWhile=true;
    Future.delayed(const Duration(milliseconds: 100),(){
      iconOffset=null;
      update(["gold_icon"]);
    });
    if(emojiList.indexWhere((element) => element.hasKey==true)>=0){
      TbaUtils.instance.pointEvent(pointType: PointType.sm_key_out,data: {"source_from":Utils.getSourceFromByPlayType(_playType)});
      _canClick=false;
      hideKeyIcon=true;
      update(["list"]);
      var renderBox = keyGlobalKey.currentContext!.findRenderObject() as RenderBox;
      var offset = renderBox.localToGlobal(Offset.zero);
      EventInfo(eventCode: EventCode.keyAnimatorStart,dynamicValue: offset);
      return;
    }
    _checkResult();
  }

  _checkResult()async{
    await Future.delayed(const Duration(milliseconds: 800));
    EventInfo(eventCode: EventCode.canClickOtherBtn,boolValue: true);
    var maxWin = BValueHep.instance.getMaxWin(_playType.name);
    var upLevel = await BSqlUtils.instance.updatePlayedNumInfo(_playType);
    if(upLevel>0){
      SmRoutersUtils.instance.showDialog(
        widget: UpLevelDialog(
          level: upLevel,
          addNum: maxWin,
          call: (){
            InfoHep.instance.updateCoins(maxWin);
            Utils.toNextPlay(_playType);
          },
        ),
        arguments: {"sourceFrom":Utils.getSourceFromByPlayType(_playType)},
      );
      return;
    }

    playResultStatus=_win?PlayResultStatus.success:PlayResultStatus.fail;
    if(playResultStatus==PlayResultStatus.success){
      var tigerReward = emojiList.map((item) => item.reward).reduce((a, b) => a + b);
      SmRoutersUtils.instance.showDialog(
          widget: IncentDialog(
            incentType: IncentType.card,
            money: tigerReward,
            dismissDialog: (addNum){
              InfoHep.instance.updateCoins(tigerReward);
              _initEmojiList();
              resetPlay();
            },
          ),
          arguments: {"sourceFrom":Utils.getSourceFromByPlayType(_playType)}
      );
    }else{
      update(["result_fail"]);
      Future.delayed(const Duration(milliseconds: 2000),(){
        _initEmojiList();
        resetPlay();
      });
    }
  }

  resetPlay(){
    InfoHep.instance.updateBoxProgress();
    prizeBorderIndex=-1;
    playResultStatus=PlayResultStatus.init;
    update(["result_fail"]);
    key.currentState?.reset();
    _canClick=true;
    hideKeyIcon=false;
    autoScratchUtils?.stopWhile=false;
    iconOffset=null;
    update(["gold_icon"]);
  }


  _initEmojiList(){
    for (var value in emojiList) {
      value.icon="";
      value.reward=0;
    }
    _win = BValueHep.instance.getEmojiChance();
    if(_win){
      var list = _lineMap.random();
      for (var value in list) {
        var bean = emojiList[value];
        bean.icon="emoji6";
        bean.reward=BValueHep.instance.getEmojiReward();
      }

      var otherList=["emoji5","emoji5","emoji5","emoji7","emoji7","emoji7"];
      for (var emptyValue in emojiList) {
        if(emptyValue.icon.isEmpty){
          var r = otherList.random();
          emptyValue.icon=r;
          otherList.remove(r);
        }
      }
    }else{
      for(int index=0;index<emojiList.length;index++){
        var bean = emojiList[index];
        if(index<3){
          bean.icon="emoji5";
        }else if(index>=6){
          bean.icon="emoji6";
          bean.reward=BValueHep.instance.getEmojiReward();
        }else{
          bean.icon="emoji7";
        }
      }
      _shuffleEmojiList();
    }

    var indexWhere = emojiList.indexWhere((element) => element.icon!="emoji6");
    if(indexWhere>=0&&BValueHep.instance.checkHasKey()){
      emojiList[indexWhere].hasKey=true;
    }
    update(["list"]);
  }

  _shuffleEmojiList(){
    emojiList.shuffle();
    for (var keys in _lineMap.keys) {
      var lineList = _lineMap[keys];
      var emoji7Num=0;
      lineList?.forEach((element) {
        if(emojiList[element].icon=="emoji6"){
          emoji7Num++;
        }
      });
      if(emoji7Num>=3){
        _shuffleEmojiList();
        return;
      }
    }
  }

  updateIconOffset(DragUpdateDetails details){
    var offset = details.localPosition;
    iconOffset=Offset(offset.dx, offset.dy);
    update(["gold_icon"]);
  }

  onScratchEnd(){
    iconOffset=null;
    update(["gold_icon"]);
  }

  @override
  bool smRegisterEvent() => true;

  @override
  smEventReceived(EventInfo eventInfo) {
    switch(eventInfo.eventCode){
      case EventCode.keyAnimatorEnd:
        _checkResult();
        break;
    }
  }

  @override
  void onClose() {
    super.onClose();
    autoScratchUtils?.stopWhile=true;
    _timer?.cancel();
  }
}