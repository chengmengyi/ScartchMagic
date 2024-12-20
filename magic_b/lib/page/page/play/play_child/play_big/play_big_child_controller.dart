import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:magic_b/enums/play_result_status.dart';
import 'package:magic_b/page/page/play/play_child/play_big/big_your_bean.dart';
import 'package:magic_b/page/widget/dialog/incent/incent_dialog.dart';
import 'package:magic_b/page/widget/dialog/up_level_dialog/up_level_dialog.dart';
import 'package:magic_b/utils/auto_scratch_utils.dart';
import 'package:magic_b/utils/b_sql/b_sql_utils.dart';
import 'package:magic_b/utils/b_sql/play_info_bean.dart';
import 'package:magic_b/utils/b_value/b_value_hep.dart';
import 'package:magic_b/utils/info_hep.dart';
import 'package:magic_b/utils/utils.dart';
import 'package:magic_base/base_widget/sm_base_controller.dart';
import 'package:magic_base/sm_router/sm_routers_utils.dart';
import 'package:magic_base/utils/event/event_code.dart';
import 'package:magic_base/utils/event/event_info.dart';
import 'package:magic_base/utils/sm_export.dart';
import 'package:magic_base/utils/tba/ad_pos.dart';
import 'package:magic_base/utils/tba/tba_utils.dart';

class PlayBigChildController extends SmBaseController{
  var _win=false,_canClick=true,hideKeyIcon=false,playResultStatus=PlayResultStatus.init;
  List<int> winningNumList=[];
  List<BigYourBean> yourNumList=[];
  final key = GlobalKey<ScratcherState>();
  Timer? _timer;
  final PlayType _playType=PlayType.playbig;
  GlobalKey globalKey=GlobalKey();
  GlobalKey keyGlobalKey=GlobalKey();
  Offset? iconOffset;
  AutoScratchUtils? autoScratchUtils;

  @override
  void onReady() {
    super.onReady();
    _initWinningNumList();
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
    if(yourNumList.indexWhere((element) => element.hasKey==true)>=0){
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
      var bigReward=0;
      for (var element in yourNumList) {
        if(winningNumList.contains(element.num)){
          bigReward+=element.reward;
        }
      }
      SmRoutersUtils.instance.showDialog(
          widget: IncentDialog(
            incentType: IncentType.card,
            money: bigReward,
            dismissDialog: (addNum){
              InfoHep.instance.updateCoins(bigReward);
              _initWinningNumList();
              resetPlay();
            },
          ),
          arguments: {"sourceFrom":Utils.getSourceFromByPlayType(_playType)}
      );
    }else{
      update(["result_fail"]);
      Future.delayed(const Duration(milliseconds: 2000),(){
        _initWinningNumList();
        resetPlay();
      });
    }
  }

  resetPlay(){
    InfoHep.instance.updateBoxProgress();
    playResultStatus=PlayResultStatus.init;
    update(["result_fail"]);
    key.currentState?.reset();
    _canClick=true;
    hideKeyIcon=false;
    autoScratchUtils?.stopWhile=false;
    iconOffset=null;
    update(["gold_icon"]);
  }

  _initWinningNumList(){
    winningNumList.clear();
    Random random = Random();
    while (winningNumList.length < 3) {
      int number = random.nextInt(100);
      if (!winningNumList.contains(number)) {
        winningNumList.add(number);
      }
    }
    winningNumList.sort((a, b) => a.compareTo(b));
    update(["winning_num"]);
    _initYourNumList();
  }

  _initYourNumList(){
    yourNumList.clear();
    for (var value in winningNumList) {
      if(BValueHep.instance.getBigChance()){
        yourNumList.add(BigYourBean(num: value, reward: BValueHep.instance.getBigReward()));
      }
    }
    _win=yourNumList.isNotEmpty;
    if(BValueHep.instance.checkHasKey()){
      yourNumList.add(BigYourBean(num: 1, reward: 1,hasKey: true));
    }
    Random random = Random();
    while(yourNumList.length<12){
      int number = random.nextInt(100);
      var indexWhere = yourNumList.indexWhere((element) => element.num==number);
      if(indexWhere<0){
        yourNumList.add(BigYourBean(num: number, reward: BValueHep.instance.getBigReward()));
      }
    }
    yourNumList.shuffle();
    update(["your_num"]);
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