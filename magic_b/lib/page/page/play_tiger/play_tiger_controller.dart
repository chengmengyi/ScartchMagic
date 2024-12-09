import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:magic_base/base_widget/sm_base_controller.dart';
import 'package:magic_base/sm_router/sm_routers_utils.dart';
import 'package:magic_base/utils/sm_export.dart';
import 'package:magic_base/utils/sm_extension.dart';
import 'package:magic_b/enums/play_result_status.dart';
import 'package:magic_b/page/page/play_tiger/prize_bean.dart';
import 'package:magic_b/page/page/play_tiger/tiger_bean.dart';
import 'package:magic_b/page/widget/dialog/up_level_dialog/up_level_dialog.dart';
import 'package:magic_b/page/widget/dialog/win_dialog/win_dialog.dart';
import 'package:magic_b/utils/auto_scratch_utils.dart';
import 'package:magic_b/utils/info_hep.dart';
import 'package:magic_b/utils/b_sql/b_sql_utils.dart';
import 'package:magic_b/utils/b_sql/play_info_bean.dart';
import 'package:magic_b/utils/b_value/b_value_hep.dart';
import 'package:magic_b/utils/utils.dart';

class PlayTigerController extends SmBaseController{
  var win=false,_canClick=true,prizeBorderIndex=-1,playResultStatus=PlayResultStatus.init;
  Timer? _timer;
  final PlayType _playType=PlayType.playtiger;
  final key = GlobalKey<ScratcherState>();
  List<PrizeBean> prizeList=[];
  List<TigerBean> yourList=[];
  final List<String> _otherIconList=["tiger8","tiger9","tiger10","tiger11"];

  GlobalKey globalKey=GlobalKey();
  GlobalKey contentGlobalKey=GlobalKey();
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
    autoScratchUtils=AutoScratchUtils(contentGlobalKey,globalKey);
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


    if(win){
      prizeBorderIndex = yourList.where((value) => value.icon=="tiger7").length;
      update(["prize_list","your_list"]);
    }
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

    playResultStatus=win?PlayResultStatus.success:PlayResultStatus.fail;
    if(playResultStatus==PlayResultStatus.success){
      var tigerReward = yourList.map((item) => item.reward).reduce((a, b) => a + b);
      SmRoutersUtils.instance.showDialog(
        widget: WinDialog(
          addNum: tigerReward,
          timeOut: (){
            InfoHep.instance.updateCoins(tigerReward);
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