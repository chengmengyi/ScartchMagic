import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:magic_base/base_widget/sm_base_controller.dart';
import 'package:magic_base/sm_router/sm_routers_utils.dart';
import 'package:magic_base/utils/sm_export.dart';
import 'package:magic_normal/enums/play_result_status.dart';
import 'package:magic_normal/page/page/play_big/big_your_bean.dart';
import 'package:magic_normal/page/widget/dialog/up_level_dialog/up_level_dialog.dart';
import 'package:magic_normal/page/widget/dialog/win_dialog/win_dialog.dart';
import 'package:magic_normal/utils/auto_scratch_utils.dart';
import 'package:magic_normal/utils/info_hep.dart';
import 'package:magic_normal/utils/normal_sql/normal_sql_utils.dart';
import 'package:magic_normal/utils/normal_sql/play_info_bean.dart';
import 'package:magic_normal/utils/normal_value/normal_value_hep.dart';
import 'package:magic_normal/utils/utils.dart';

class PlayBigController extends SmBaseController{
  var _win=false,_canClick=true,playResultStatus=PlayResultStatus.init;
  List<int> winningNumList=[];
  List<BigYourBean> yourNumList=[];
  final key = GlobalKey<ScratcherState>();
  Timer? _timer;
  final PlayType _playType=PlayType.playbig;
  GlobalKey globalKey=GlobalKey();
  GlobalKey contentGlobalKey=GlobalKey();
  Offset? iconOffset;
  AutoScratchUtils? autoScratchUtils;

  @override
  void onReady() {
    super.onReady();
    _initWinningNumList();
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

    var maxWin = NormalValueHep.instance.getMaxWin(_playType.name);
    var upLevel = await NormalSqlUtils.instance.updatePlayedNumInfo(_playType);
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

    playResultStatus=_win?PlayResultStatus.success:PlayResultStatus.fail;
    if(playResultStatus==PlayResultStatus.success){
      var bigReward=0;
      for (var element in yourNumList) {
        if(winningNumList.contains(element.num)){
          bigReward+=element.reward;
        }
      }
      SmRoutersUtils.instance.showDialog(
        widget: WinDialog(
          addNum: bigReward,
          timeOut: (){
            InfoHep.instance.updateCoins(bigReward);
            _initWinningNumList();
            resetPlay();
          },
        ),
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
    playResultStatus=PlayResultStatus.init;
    update(["result_fail"]);
    key.currentState?.reset();
    _canClick=true;
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
      if(NormalValueHep.instance.getBigChance()){
        yourNumList.add(BigYourBean(num: value, reward: NormalValueHep.instance.getBigReward()));
      }
    }
    _win=yourNumList.isNotEmpty;
    Random random = Random();
    while(yourNumList.length<12){
      int number = random.nextInt(100);
      var indexWhere = yourNumList.indexWhere((element) => element.num==number);
      if(indexWhere<0){
        yourNumList.add(BigYourBean(num: number, reward: NormalValueHep.instance.getBigReward()));
      }
    }
    yourNumList.shuffle();
    update(["your_num"]);
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