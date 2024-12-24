import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:magic_b/page/page/play/play_child/play_7/play7_bean.dart';
import 'package:magic_b/page/widget/dialog/incent/incent_dialog.dart';
import 'package:magic_b/utils/cash_task/cash_task_utils.dart';
import 'package:magic_base/base_widget/sm_base_controller.dart';
import 'package:magic_base/sm_router/sm_routers_utils.dart';
import 'package:magic_base/utils/event/event_code.dart';
import 'package:magic_base/utils/event/event_info.dart';
import 'package:magic_base/utils/sm_export.dart';
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

class Play7ChildController extends SmBaseController with GetTickerProviderStateMixin{
  var win=false,_canClick=true,showCover=false,hideKeyIcon=false,playResultStatus=PlayResultStatus.init;

  final key = GlobalKey<ScratcherState>();
  Timer? _timer;
  List<Play7Bean> yourList=[];
  final PlayType _playType=PlayType.play7;


  GlobalKey globalKey=GlobalKey();
  GlobalKey keyGlobalKey=GlobalKey();
  GlobalKey contentGlobalKey=GlobalKey();
  Offset? iconOffset;
  AutoScratchUtils? autoScratchUtils;
  late AnimationController scaleController;

  @override
  void onInit() {
    super.onInit();
    _initAnimator();
  }

  @override
  void onReady() {
    super.onReady();
    _initYourNumList();
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
    if(yourList.indexWhere((element) => element.icon.isNotEmpty)>=0){
      scaleController..reset()..forward();
    }
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
    BSqlUtils.instance.updateCashTaskPro(TaskType.card);
    scaleController.stop();
    win = yourList.indexWhere((element) => element.icon.isNotEmpty)>=0;
    playResultStatus=win?PlayResultStatus.success:PlayResultStatus.fail;
    update(["cover"]);
    if(!win){
      update(["result_fail"]);
      Future.delayed(const Duration(milliseconds: 2000),(){
        EventInfo(eventCode: EventCode.canClickOtherBtn,boolValue: true);
        _initYourNumList();
        resetPlay();
      });
      return;
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
            InfoHep.instance.updateCoins(maxWin,showLottie: false);
            Utils.toNextPlay(_playType);
          },
        ),
        arguments: {"sourceFrom":Utils.getSourceFromByPlayType(_playType)},
      );
      return;
    }
    var bigReward=yourList.map((item) => item.reward).reduce((a, b) => a + b);
    SmRoutersUtils.instance.showDialog(
        widget: IncentDialog(
          incentType: IncentType.card,
          money: bigReward,
          dismissDialog: (addNum){
            InfoHep.instance.updateCoins(addNum);
            _initYourNumList();
            resetPlay();
          },
        ),
        arguments: {"sourceFrom":Utils.getSourceFromByPlayType(_playType)}
    );
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

  _initYourNumList(){
    yourList.clear();
    var play7reward = BValueHep.instance.getPlay7Reward();
    if(BValueHep.instance.getPlay7Chance()){
      yourList.add(Play7Bean(icon: "play_one_7", num: 0, reward: play7reward));
    }
    if(BValueHep.instance.getPlay77Chance()){
      yourList.add(Play7Bean(icon: "play_two_7", num: 0, reward: play7reward*2));
    }
    if(BValueHep.instance.checkHasKey()){
      yourList.add(Play7Bean(icon: "", num: 0, reward: 0,hasKey: true));
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

  _initAnimator(){
    scaleController=AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
      lowerBound: 1,
      upperBound: 1.2,
    )
      ..addStatusListener((status) {
        if(status==AnimationStatus.completed){
          scaleController.reverse();
        }else if(status==AnimationStatus.dismissed){
          scaleController.forward();
        }
      });
  }

  @override
  void onClose() {
    scaleController.dispose();
    super.onClose();
    autoScratchUtils?.stopWhile=true;
    _timer?.cancel();
  }
}