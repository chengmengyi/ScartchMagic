import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:magic_base/base_widget/sm_base_controller.dart';
import 'package:magic_base/sm_router/sm_routers_utils.dart';
import 'package:magic_base/utils/sm_export.dart';
import 'package:magic_b/enums/play_result_status.dart';
import 'package:magic_b/page/page/play_7/play7_bean.dart';
import 'package:magic_b/page/widget/dialog/up_level_dialog/up_level_dialog.dart';
import 'package:magic_b/page/widget/dialog/win_dialog/win_dialog.dart';
import 'package:magic_b/utils/auto_scratch_utils.dart';
import 'package:magic_b/utils/info_hep.dart';
import 'package:magic_b/utils/b_sql/b_sql_utils.dart';
import 'package:magic_b/utils/b_sql/play_info_bean.dart';
import 'package:magic_b/utils/b_value/b_value_hep.dart';
import 'package:magic_b/utils/utils.dart';

class Play7Controller extends SmBaseController{
  var win=false,_canClick=true,showCover=false,playResultStatus=PlayResultStatus.init;

  final key = GlobalKey<ScratcherState>();
  Timer? _timer;
  List<Play7Bean> yourList=[];
  final PlayType _playType=PlayType.play7;


  GlobalKey globalKey=GlobalKey();
  GlobalKey contentGlobalKey=GlobalKey();
  Offset? iconOffset;
  AutoScratchUtils? autoScratchUtils;


  @override
  void onReady() {
    super.onReady();
    _initYourNumList();
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

    win = yourList.indexWhere((element) => element.icon.isNotEmpty)>=0;
    playResultStatus=win?PlayResultStatus.success:PlayResultStatus.fail;
    update(["cover"]);
    if(!win){
      update(["result_fail"]);
      Future.delayed(const Duration(milliseconds: 2000),(){
        _initYourNumList();
        resetPlay();
      });
      return;
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
    var bigReward=yourList.map((item) => item.reward).reduce((a, b) => a + b);
    SmRoutersUtils.instance.showDialog(
      widget: WinDialog(
        addNum: bigReward,
        timeOut: (){
          InfoHep.instance.updateCoins(bigReward);
          _initYourNumList();
          resetPlay();
        },
      ),
    );
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

  _initYourNumList(){
    yourList.clear();
    var play7reward = BValueHep.instance.getPlay7Reward();
    if(BValueHep.instance.getPlay7Chance()){
      yourList.add(Play7Bean(icon: "play_one_7", num: 0, reward: play7reward));
    }
    if(BValueHep.instance.getPlay77Chance()){
      yourList.add(Play7Bean(icon: "play_two_7", num: 0, reward: play7reward*2));
    }
    Random random = Random();
    while(yourList.length<12){
      int number = random.nextInt(100);
      var indexWhere = yourList.indexWhere((element) => element.num==number);
      if(indexWhere<0){
        yourList.add(Play7Bean(icon: "", num: number, reward: 0));
      }
    }
    yourList.shuffle();
    update(["your_list"]);
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