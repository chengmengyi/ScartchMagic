import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:magic_base/base_widget/sm_base_controller.dart';
import 'package:magic_base/sm_router/sm_routers_utils.dart';
import 'package:magic_base/utils/event/event_code.dart';
import 'package:magic_base/utils/event/event_info.dart';
import 'package:magic_base/utils/sm_export.dart';
import 'package:magic_normal/enums/play_result_status.dart';
import 'package:magic_normal/page/widget/dialog/up_level_dialog/up_level_dialog.dart';
import 'package:magic_normal/page/widget/dialog/win_dialog/win_dialog.dart';
import 'package:magic_normal/utils/auto_scratch_utils.dart';
import 'package:magic_normal/utils/info_hep.dart';
import 'package:magic_normal/utils/normal_sql/normal_sql_utils.dart';
import 'package:magic_normal/utils/normal_sql/play_info_bean.dart';
import 'package:magic_normal/utils/normal_value/normal_value_hep.dart';
import 'package:magic_normal/utils/utils.dart';

class PlayFruitController extends SmBaseController{
  var _canClick=true,_has3fruit=false,playResultStatus=PlayResultStatus.init;
  final key = GlobalKey<ScratcherState>();
  List<String> rewardList=[];
  Timer? _timer;

  GlobalKey globalKey=GlobalKey();
  GlobalKey contentGlobalKey=GlobalKey();
  Offset? iconOffset;
  AutoScratchUtils? autoScratchUtils;

  @override
  void onReady() {
    super.onReady();
    _initRewardList();
    autoScratchUtils=AutoScratchUtils(contentGlobalKey,globalKey);
  }

  clickOpen()async{
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

    var maxWin = NormalValueHep.instance.getMaxWin(PlayType.playfruit.name);
    var upLevel = await NormalSqlUtils.instance.updatePlayedNumInfo(PlayType.playfruit);
    if(upLevel>0){
      SmRoutersUtils.instance.showDialog(
        widget: UpLevelDialog(
          level: upLevel,
          addNum: maxWin,
          call: (){
            InfoHep.instance.updateCoins(maxWin);
            Utils.toNextPlay(PlayType.playfruit);
          },
        ),
      );
      return;
    }

    var fruitReward = NormalValueHep.instance.getFruitReward();
    playResultStatus=_has3fruit?PlayResultStatus.success:PlayResultStatus.fail;
    if(playResultStatus==PlayResultStatus.success){
      SmRoutersUtils.instance.showDialog(
        widget: WinDialog(
          addNum: fruitReward,
          timeOut: (){
            InfoHep.instance.updateCoins(fruitReward);
            _initRewardList();
            resetPlay();
          },
        ),
      );
    }else{
      update(["result_fail"]);
      Future.delayed(const Duration(milliseconds: 2000),(){
        _initRewardList();
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

    EventInfo(eventCode: EventCode.updateUpLevelText);
  }

  _initRewardList(){
    _has3fruit = NormalValueHep.instance.getFruitChance();
    rewardList.clear();
    rewardList.addAll(["icon_fruit1","icon_fruit1"]);
    if(_has3fruit){
      rewardList.add("icon_fruit1");
    }
    while(rewardList.length<9){
      rewardList.add(Random().nextInt(100)<50?"icon_fruit2":"icon_fruit3");
    }
    rewardList.shuffle();
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