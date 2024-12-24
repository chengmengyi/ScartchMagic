import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:magic_b/page/widget/dialog/incent/incent_dialog.dart';
import 'package:magic_b/utils/b_storage/b_storage_hep.dart';
import 'package:magic_b/utils/cash_task/cash_task_utils.dart';
import 'package:magic_b/utils/guide/guide_step.dart';
import 'package:magic_b/utils/guide/guide_utils.dart';
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

class PlayFruitChildController extends SmBaseController with GetTickerProviderStateMixin{
  var _canClick=true,_has3fruit=false,playResultStatus=PlayResultStatus.init,
      showFruitFingerGuide=false,showRevealAllFinger=false,hideKeyIcon=false;
  final key = GlobalKey<ScratcherState>();
  final PlayType _playType=PlayType.playfruit;
  List<String> rewardList=[];
  Timer? _timer;

  GlobalKey globalKey=GlobalKey();
  GlobalKey keyGlobalKey=GlobalKey();
  Offset? iconOffset;
  AutoScratchUtils? autoScratchUtils;
  late AnimationController scaleController;

  @override
  void onInit() {
    super.onInit();
    _initAnimator();
    showFruitFingerGuide=currentGuideStep.read()==GuideStep.showFruitFingerGuide;
    if(showFruitFingerGuide){
      TbaUtils.instance.pointEvent(pointType: PointType.sm_card_guide);
    }
  }

  @override
  void onReady() {
    super.onReady();
    _initRewardList();
    autoScratchUtils=AutoScratchUtils(globalKey);
  }

  clickOpen()async{
    if(!_canClick){
      return;
    }
    updateFruitFinger();
    hideRevealAllFinger();
    GuideUtils.instance.clickRevealAll();
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
    if(_has3fruit){
      scaleController..reset()..forward();
    }
    if(rewardList.contains("icon_key")){
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
    BSqlUtils.instance.updateCashTaskPro(TaskType.card);
    scaleController.stop();
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
            InfoHep.instance.updatePlayedCardNum();
            Utils.toNextPlay(_playType);
          },
        ),
        arguments: {"sourceFrom":Utils.getSourceFromByPlayType(_playType)},
      );
      return;
    }

    var fruitReward = BValueHep.instance.getFruitReward();
    playResultStatus=_has3fruit?PlayResultStatus.success:PlayResultStatus.fail;
    if(playResultStatus==PlayResultStatus.success){
      if(currentGuideStep.read()==GuideStep.showFruitFingerGuide){
        GuideUtils.instance.updateGuideStep(GuideStep.firstGetReward);
      }
      SmRoutersUtils.instance.showDialog(
        widget: IncentDialog(
          incentType: IncentType.card,
          money: fruitReward,
          dismissDialog: (addNum){
            InfoHep.instance.updateCoins(addNum);
            InfoHep.instance.updatePlayedCardNum();
            _initRewardList();
            resetPlay();
          },
        ),
        arguments: {"sourceFrom":Utils.getSourceFromByPlayType(_playType)}
      );
    }else{
      update(["result_fail"]);
      Future.delayed(const Duration(milliseconds: 2000),(){
        InfoHep.instance.updatePlayedCardNum();
        _initRewardList();
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

    EventInfo(eventCode: EventCode.updateUpLevelText);
  }

  _initRewardList(){
    _has3fruit = BValueHep.instance.getFruitChance();
    rewardList.clear();
    rewardList.addAll(["icon_fruit1","icon_fruit1"]);
    if(_has3fruit){
      rewardList.add("icon_fruit1");
    }
    if(BValueHep.instance.checkHasKey()){
      rewardList.add("icon_key");
    }
    while(rewardList.length<9){
      rewardList.add(Random().nextInt(100)<50?"icon_fruit2":"icon_fruit3");
    }
    rewardList.shuffle();
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

  updateFruitFinger(){
    if(showFruitFingerGuide){
      TbaUtils.instance.pointEvent(pointType: PointType.sm_card_guide_c);
      showFruitFingerGuide=false;
      update(["showFruitFingerGuide"]);
    }
  }

  hideRevealAllFinger(){
    EventInfo(eventCode: EventCode.canClickOtherBtn,boolValue: false);
    if(showRevealAllFinger){
      showRevealAllFinger=false;
      update(["showRevealAllFingerGuide"]);
    }
  }

  @override
  bool smRegisterEvent() => true;

  @override
  smEventReceived(EventInfo eventInfo) {
    switch(eventInfo.eventCode){
      case EventCode.clickRevealAll:
        clickOpen();
        break;
      case EventCode.showRevealAllFingerGuide:
        if(playedCardNum.read()==2){
          showRevealAllFinger=true;
          update(["showRevealAllFingerGuide"]);
        }
        break;
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