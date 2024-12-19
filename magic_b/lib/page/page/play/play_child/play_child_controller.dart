import 'package:flutter/material.dart';
import 'package:magic_b/page/page/play/play_child/play_7/play_7_child.dart';
import 'package:magic_b/page/page/play/play_child/play_8/play_8_child.dart';
import 'package:magic_b/page/page/play/play_child/play_big/play_big_child.dart';
import 'package:magic_b/page/page/play/play_child/play_emoji/play_emoji_child.dart';
import 'package:magic_b/page/page/play/play_child/play_fruit/play_fruit_child.dart';
import 'package:magic_b/page/page/play/play_child/play_tiger/play_tiger_child.dart';
import 'package:magic_b/page/widget/dialog/box/box_dialog.dart';
import 'package:magic_b/utils/b_sql/play_info_bean.dart';
import 'package:magic_b/utils/b_storage/b_storage_hep.dart';
import 'package:magic_b/utils/guide/box_guide_overlay.dart';
import 'package:magic_b/utils/guide/guide_utils.dart';
import 'package:magic_base/base_widget/sm_base_controller.dart';
import 'package:magic_base/sm_router/sm_routers_utils.dart';
import 'package:magic_base/utils/event/event_code.dart';
import 'package:magic_base/utils/event/event_info.dart';
import 'package:magic_base/utils/sm_export.dart';
import 'package:magic_base/utils/sm_extension.dart';

class PlayChildController extends SmBaseController with GetTickerProviderStateMixin{
  PlayType? currentPlayType;
  var showBubble=false,currentBox=currentBoxProgress.read(),showMoneyLottie=false,canClick=true,showBoxFinger=false;
  GlobalKey boxGlobalKey=GlobalKey();
  Offset? boxFingerOffset;
  late AnimationController keyLottieController;
  Animation<Offset>? keyAnimation;
  Offset keyEndOffset=Offset.zero;

  final Map<PlayType,Widget> _widgetMap={
    PlayType.playfruit:PlayFruitChild(),
    PlayType.playbig:PlayBigChild(),
    PlayType.playtiger:PlayTigerChild(),
    PlayType.play7:Play7Child(),
    PlayType.playemoji:PlayEmojiChild(),
    PlayType.play8:Play8Child(),
  };

  final Map<PlayType,String> _bgMap={
    PlayType.playfruit:"fruit_bg",
    PlayType.playbig:"big_bg",
    PlayType.playtiger:"tiger_bg",
    PlayType.play7:"play71",
    PlayType.playemoji:"emoji1",
    PlayType.play8:"play81",
  };

  @override
  void onInit() {
    super.onInit();
    keyLottieController=AnimationController(vsync: this,duration: const Duration(milliseconds: 2000))
      ..addListener(() {
        update(["key"]);
      })
    ..addStatusListener((status) {
      if(status==AnimationStatus.completed){
        canClick=true;
        wheelChanceNum.add(1);
        EventInfo(eventCode: EventCode.keyAnimatorEnd);
      }
    });
  }

  @override
  void onReady() {
    super.onReady();
    var size = MediaQuery.of(smContext).size;
    keyEndOffset=Offset(size.width/2-40.w, size.height-40.h);
    var renderBox = boxGlobalKey.currentContext!.findRenderObject() as RenderBox;
    boxFingerOffset = renderBox.localToGlobal(Offset.zero);
  }

  clickBox(){
    if(!canClick){
      return;
    }
    showBoxFinger=false;
    update(["box_finger"]);
    var current = currentBoxProgress.read();
    if(current<5){
      showToast("${5-current} scratch cards left to complete");
      return;
    }
    SmRoutersUtils.instance.showDialog(
      widget: BoxDialog(
        dismiss: (){
          currentBox=0;
          currentBoxProgress.write(0);
          update(["box"]);
        },
      ),
    );

  }

  @override
  bool smRegisterEvent() => true;

  @override
  smEventReceived(EventInfo eventInfo) {
    switch(eventInfo.eventCode){
      case EventCode.showBubble:
        showBubble=true;
        update(["showBubble"]);
        break;
      case EventCode.updateBoxProgress:
        _updateBoxProgress();
        break;
      case EventCode.toNextCardChild:
        currentPlayType=eventInfo.dynamicValue as PlayType;
        update(["child_page","bg"]);
        break;
      case EventCode.keyAnimatorStart:
        _showKeyAnimator(eventInfo.dynamicValue);
        break;
    }
  }

  _showKeyAnimator(Offset offset){
    canClick=false;
    update(["key"]);
    keyAnimation=Tween<Offset>(
      begin: offset,
      end: keyEndOffset,
    ).animate(CurvedAnimation(parent: keyLottieController, curve: Curves.elasticInOut));

    keyLottieController..reset()..forward();
  }

  getChildPage(PlayType playType){
    currentPlayType ??= playType;
    return _widgetMap[currentPlayType]??Container();
  }

  getBgRes(PlayType playType){
    currentPlayType ??= playType;
    return _bgMap[currentPlayType]??"fruit_bg";
  }

  _updateBoxProgress(){
    currentBox = currentBoxProgress.read();
    update(["box"]);
    if(currentBox>=5){
      _showBoxGuide();
    }
  }

  _showBoxGuide(){
    if(firstShowBoxGuide.read()){
      firstShowBoxGuide.write(false);
      var renderBox = boxGlobalKey.currentContext!.findRenderObject() as RenderBox;
      var offset = renderBox.localToGlobal(Offset.zero);
      GuideUtils.instance.showOver(
        context: smContext,
        widget: BoxGuideOverlay(
          offset: offset,
          dismiss: (){
            clickBox();
          },
        ),
      );
      return;
    }

    if(!showBoxFinger){
      showBoxFinger=true;
      update(["box_finger"]);
    }
  }
  @override
  void onClose() {
    keyLottieController.dispose();
    super.onClose();
  }
}