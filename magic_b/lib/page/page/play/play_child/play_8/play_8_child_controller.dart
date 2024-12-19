import 'dart:async';

import 'package:flutter/material.dart';
import 'package:magic_b/page/page/play/play_child/play_8/play8_bean.dart';
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

class Play8ChildController extends SmBaseController{
  var _canClick=true,prizeBorderIndex=-1,hideKeyIcon=false,playResultStatus=PlayResultStatus.init;
  Timer? _timer;
  final PlayType _playType=PlayType.play8;
  final key = GlobalKey<ScratcherState>();
  List<Play8Bean> yourList=[];
  final List<String> _otherIconList=["play_icon1","play_icon2","play_icon3","play_icon4","play_icon5","play_icon6","play_icon7","play_icon8"];

  GlobalKey globalKey=GlobalKey();
  GlobalKey contentGlobalKey=GlobalKey();
  GlobalKey keyGlobalKey=GlobalKey();
  Offset? iconOffset;
  AutoScratchUtils? autoScratchUtils;


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
      );
      return;
    }

    var reward = 0;
    for (var element in yourList) {
      if(element.is8){
        reward+=element.reward*8;
      }else{
        reward+=element.reward;
      }
    }

    playResultStatus=reward>0?PlayResultStatus.success:PlayResultStatus.fail;
    if(playResultStatus==PlayResultStatus.success){
      SmRoutersUtils.instance.showDialog(
          widget: IncentDialog(
            money: reward,
            dismissDialog: (addNum){
              InfoHep.instance.updateCoins(reward);
              _initYourList();
              resetPlay();
            },
          )
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
    update(["result_fail"]);
    key.currentState?.reset();
    _canClick=true;
    hideKeyIcon=false;
    autoScratchUtils?.stopWhile=false;
    iconOffset=null;
    update(["gold_icon"]);
  }


  _initYourList(){
    yourList.clear();
    if(BValueHep.instance.getPlay8Chance()){
      yourList.add(Play8Bean(icon: "play87", reward: BValueHep.instance.getPlay8Reward(), is8: true));
    }
    if(BValueHep.instance.getPlay8IconChance()){
      var icon = _otherIconList.random();
      for(int index=0; index<3;index++){
        yourList.add(Play8Bean(icon: icon, reward: BValueHep.instance.getPlay8Reward(), is8: false));
      }
    }
    if(BValueHep.instance.checkHasKey()){
      yourList.add(Play8Bean(icon: "", reward: 0, is8: false,hasKey: true));
    }
    while(yourList.length<15){
      var icon = _otherIconList.random();
      int count = yourList.where((value) => value.icon==icon).length;
      if(count<2){
        yourList.add(Play8Bean(icon: icon, reward: 0, is8: false));
      }
    }
    yourList.shuffle();
    update(["list"]);
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
