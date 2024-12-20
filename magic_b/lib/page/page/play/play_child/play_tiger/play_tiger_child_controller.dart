import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:magic_b/page/page/play/play_child/play_tiger/prize_bean.dart';
import 'package:magic_b/page/page/play/play_child/play_tiger/tiger_bean.dart';
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

class PlayTigerChildController extends SmBaseController{
  var win=false,_canClick=true,prizeBorderIndex=-1,hideKeyIcon=false,playResultStatus=PlayResultStatus.init;
  Timer? _timer;
  final PlayType _playType=PlayType.playtiger;
  final key = GlobalKey<ScratcherState>();
  List<PrizeBean> prizeList=[];
  List<TigerBean> yourList=[];
  final List<String> _otherIconList=["tiger8","tiger9","tiger10","tiger11"];

  GlobalKey globalKey=GlobalKey();
  GlobalKey keyGlobalKey=GlobalKey();
  Offset? iconOffset;
  AutoScratchUtils? autoScratchUtils;

  @override
  void onInit() {
    super.onInit();
    _initPrizeList();
  }

  @override
  void onReady() {
    super.onReady();
    _initYourList();
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
    if(yourList.indexWhere((element) => element.hasKey==true)>=0){
      TbaUtils.instance.pointEvent(pointType: PointType.sm_key_out,data: {"source_from":Utils.getSourceFromByPlayType(_playType)});
      _canClick=false;
      hideKeyIcon=true;
      update(["your_list"]);
      var renderBox = keyGlobalKey.currentContext!.findRenderObject() as RenderBox;
      var offset = renderBox.localToGlobal(Offset.zero);
      EventInfo(eventCode: EventCode.keyAnimatorStart,dynamicValue: offset);
      return;
    }
    _checkResult();
  }

  _checkResult()async{
    if(win){
      prizeBorderIndex = yourList.where((value) => value.icon=="tiger7").length;
      update(["prize_list","your_list"]);
    }
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

    playResultStatus=win?PlayResultStatus.success:PlayResultStatus.fail;
    if(playResultStatus==PlayResultStatus.success){
      var tigerReward = yourList.map((item) => item.reward).reduce((a, b) => a + b);
      SmRoutersUtils.instance.showDialog(
          widget: IncentDialog(
            incentType: IncentType.card,
            money: tigerReward,
            dismissDialog: (addNum){
              InfoHep.instance.updateCoins(tigerReward);
              _initYourList();
              resetPlay();
            },
          ),
          arguments: {"sourceFrom":Utils.getSourceFromByPlayType(_playType)}
      );
    }else{
      update(["result_fail"]);
      Future.delayed(const Duration(milliseconds: 2000),(){
        _initYourList();
        resetPlay();
      });
    }
  }

  resetPlay(){
    InfoHep.instance.updateBoxProgress();
    prizeBorderIndex=-1;
    playResultStatus=PlayResultStatus.init;
    update(["result_fail","prize_list"]);
    key.currentState?.reset();
    _canClick=true;
    hideKeyIcon=false;
    autoScratchUtils?.stopWhile=false;
    iconOffset=null;
    update(["gold_icon"]);
  }


  _initYourList(){
    yourList.clear();
    var tigerNum = BValueHep.instance.getTigerNum();
    win=tigerNum!=0;
    if(tigerNum==0){
      var length = Random().nextInt(3);
      while(yourList.length<length){
        yourList.add(TigerBean(icon: "tiger7", reward: BValueHep.instance.getTigerReward()));
      }
    }else{
      while(yourList.length<tigerNum){
        yourList.add(TigerBean(icon: "tiger7", reward: BValueHep.instance.getTigerReward()));
      }
    }
    if(BValueHep.instance.checkHasKey()){
      yourList.add(TigerBean(icon: "", reward: 0,hasKey: true));
    }
    while(yourList.length<12){
      yourList.add(TigerBean(icon: _otherIconList.random(), reward: 0));
    }
    yourList.shuffle();
    update(["your_list"]);
  }

  _initPrizeList() {
    prizeList.add(PrizeBean(num: 3, multiple: 1));
    prizeList.add(PrizeBean(num: 4, multiple: 2));
    prizeList.add(PrizeBean(num: 5, multiple: 3));
    prizeList.add(PrizeBean(num: 6, multiple: 5));
    prizeList.add(PrizeBean(num: 7, multiple: 10));
    prizeList.add(PrizeBean(num: 8, multiple: 25));
    prizeList.add(PrizeBean(num: 9, multiple: 50));
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