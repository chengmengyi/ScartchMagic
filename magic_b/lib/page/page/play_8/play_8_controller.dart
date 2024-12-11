import 'dart:async';

import 'package:flutter/material.dart';
import 'package:magic_base/base_widget/sm_base_controller.dart';
import 'package:magic_base/sm_router/sm_routers_utils.dart';
import 'package:magic_base/utils/sm_export.dart';
import 'package:magic_base/utils/sm_extension.dart';
import 'package:magic_b/enums/play_result_status.dart';
import 'package:magic_b/page/page/play_8/play8_bean.dart';
import 'package:magic_b/page/widget/dialog/up_level_dialog/up_level_dialog.dart';
import 'package:magic_b/page/widget/dialog/win_dialog/win_dialog.dart';
import 'package:magic_b/utils/auto_scratch_utils.dart';
import 'package:magic_b/utils/info_hep.dart';
import 'package:magic_b/utils/b_sql/b_sql_utils.dart';
import 'package:magic_b/utils/b_sql/play_info_bean.dart';
import 'package:magic_b/utils/b_value/b_value_hep.dart';
import 'package:magic_b/utils/utils.dart';

class Play8Controller extends SmBaseController{
  var _canClick=true,prizeBorderIndex=-1,playResultStatus=PlayResultStatus.init;
  Timer? _timer;
  final PlayType _playType=PlayType.play8;
  final key = GlobalKey<ScratcherState>();
  List<Play8Bean> yourList=[];
  final List<String> _otherIconList=["play_icon1","play_icon2","play_icon3","play_icon4","play_icon5","play_icon6","play_icon7","play_icon8"];

  GlobalKey globalKey=GlobalKey();
  GlobalKey contentGlobalKey=GlobalKey();
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
    await Future.delayed(const Duration(milliseconds: 800));
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
        widget: WinDialog(
          addNum: reward,
          timeOut: (){
            InfoHep.instance.updateCoins(reward);
            _initYourList();
            resetPlay();
          },
        ),
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
    prizeBorderIndex=-1;
    playResultStatus=PlayResultStatus.init;
    update(["result_fail"]);
    key.currentState?.reset();
    _canClick=true;
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
    iconOffset=Offset(offset.dx+(autoScratchUtils?.marginLeft??0), offset.dy+(autoScratchUtils?.marginTop??0));
    update(["gold_icon"]);
  }

  @override
  void onClose() {
    super.onClose();
    autoScratchUtils?.stopWhile=true;
    _timer?.cancel();
  }
}
