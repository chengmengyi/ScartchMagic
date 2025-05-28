import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:magic_b/page/widget/dialog/add_chance_dialog/add_chance_dialog.dart';
import 'package:magic_b/page/widget/dialog/big_win/bigwin_dialog.dart';
import 'package:magic_b/page/widget/dialog/box/box_dialog.dart';
import 'package:magic_b/page/widget/dialog/cash_task/cash_task_dialog.dart';
import 'package:magic_b/page/widget/dialog/cash_win/cashwin_dialog.dart';
import 'package:magic_b/page/widget/dialog/incent/incent_dialog.dart';
import 'package:magic_b/page/widget/dialog/input_account/input_account_dialog.dart';
import 'package:magic_b/page/widget/dialog/no_reward/no_reward_dialog.dart';
import 'package:magic_b/page/widget/dialog/no_wheel/no_wheel_dialog.dart';
import 'package:magic_b/page/widget/dialog/old_user_dialog/old_user_dialog.dart';
import 'package:magic_b/page/widget/dialog/old_user_double_reward/old_user_double_reward_dialog.dart';
import 'package:magic_b/page/widget/dialog/up_level_dialog/up_level_dialog.dart';
import 'package:magic_b/utils/b_sql/b_sql_utils.dart';
import 'package:magic_b/utils/b_sql/play_info_bean.dart';
import 'package:magic_b/utils/b_value/b_value_hep.dart';
import 'package:magic_b/utils/cash_task/cash_list_bean.dart';
import 'package:magic_b/utils/cash_task/cash_task_utils.dart';
import 'package:magic_b/utils/guide/first_play_guide_overlay.dart';
import 'package:magic_b/utils/guide/guide_step.dart';
import 'package:magic_b/utils/guide/guide_utils.dart';
import 'package:magic_b/utils/info_hep.dart';
import 'package:magic_base/base_widget/sm_base_controller.dart';
import 'package:magic_base/sm_router/all_routers_name.dart';
import 'package:magic_base/sm_router/sm_routers_utils.dart';
import 'package:magic_base/utils/b_ad/ad_utils.dart';
import 'package:magic_base/utils/b_ad/load_ad.dart';
import 'package:magic_base/utils/check_user/check_user_utils.dart';
import 'package:magic_base/utils/event/event_code.dart';
import 'package:magic_base/utils/event/event_info.dart';
import 'package:magic_base/utils/firebase/firebase_utils.dart';
import 'package:magic_base/utils/sm_export.dart';
import 'package:magic_base/utils/sm_extension.dart';
import 'package:magic_base/utils/tba/ad_pos.dart';
import 'package:magic_base/utils/tba/tba_utils.dart';
import 'package:flutter_tba_info/flutter_tba_info.dart';

class CardChildController extends SmBaseController{
  var fingerIndex=-1,totalSecondsNum=80;
  GlobalKey playListGlobal=GlobalKey();
  ScrollController scrollController=ScrollController();
  Timer? _timer;
  List<PlayInfoBean> playList=[];

  @override
  void onInit() {
    super.onInit();
    TbaUtils.instance.pointEvent(pointType: PointType.sm_home_page);
  }

  @override
  void onReady() {
    super.onReady();
    _initPlayList();
    GuideUtils.instance.checkGuide(checkOldGuide: true);
  }

  clickItem(PlayInfoBean bean){
    // fingerIndex=-1;
    // update(["list"]);
    var playType = PlayType.values.firstWhere((element) => element.name==bean.type);
    if((bean.hasNum??0)<=0){
      SmRoutersUtils.instance.showDialog(
        widget: AddChanceDialog(
          playType: playType,
          dismiss: ()async{
            await BSqlUtils.instance.addPlayNum(playType.name,addNum: 5);
            _initPlayList();
          },
        ),
      );
      return;
    }

    SmRoutersUtils.instance.toNextPage(
      routersName: AllRoutersName.playB,
      arguments: {
        "playType":playType,
      },
    );
  }

  _initPlayList({String playType=""})async{
    playList.clear();
    var list = await BSqlUtils.instance.queryPlayList();
    playList.addAll(list);

    // var index = playList.indexWhere((element) => element.type==playType);
    // if(index>=0){
    //   scrollController.jumpTo((index~/2)*296.h);
    //   fingerIndex=index;
    // }
    for (var element in playList) {
      element.maxWin=BValueHep.instance.getMaxWin(element.type);
    }
    update(["list"]);

    var indexWhere = playList.indexWhere((element) => (element.hasNum??0)<10);
    if(indexWhere>=0&&null==_timer){
      _timer?.cancel();
      _timer=Timer.periodic(const Duration(milliseconds: 1000), (timer) async{
        bool updateUI=false;
        for (var element in playList) {
          if((element.hasNum??0)<10){
            updateUI=true;
            element.secondsNum=(element.secondsNum??0)+1;
            await BSqlUtils.instance.savePlayInfo(element);
            if((element.secondsNum??0)>=totalSecondsNum){
              await BSqlUtils.instance.addPlayNum(element.type??"");
              element.secondsNum=0;
              element.hasNum=(element.hasNum??0)+1;
            }
          }
        }
        if(updateUI){
          update(["list"]);
        }
      });
    }
  }

  String getRefreshTimerStr(PlayInfoBean bean){
    var i = bean.secondsNum??0;
    if(i<=0){
      return "";
    }
    return "${totalSecondsNum-i}";
  }

  // double getRefreshTimerEndAngle(PlayInfoBean bean){
  //   var pro = (3600000-((bean.time??0)-DateTime.now().millisecondsSinceEpoch))/3600000;
  //   if(pro>=1.0){
  //     return 270;
  //   }else if(pro<=0){
  //     return -90;
  //   }else{
  //     return pro*360-90;
  //   }
  // }

  @override
  bool smRegisterEvent() => true;

  @override
  smEventReceived(EventInfo eventInfo) {
    switch(eventInfo.eventCode){
      case EventCode.updateHomeList:
        _checkShowItemFinger(eventInfo.strValue);
        break;
      case EventCode.showFirstPlayGuide:
        _showFirstPlayGuide();
        break;
    }
  }

  _checkShowItemFinger(value)async{
    if(null!=value&&value is String){
      _initPlayList(playType: value);
    }else{
      _initPlayList();
    }
  }

  _showFirstPlayGuide(){
    TbaUtils.instance.pointEvent(pointType: PointType.sm_home_guide);
    var renderBox = playListGlobal.currentContext!.findRenderObject() as RenderBox;
    var offset = renderBox.localToGlobal(Offset.zero);
    GuideUtils.instance.showOver(
      context: smContext,
      widget: FirstPlayGuideOverlay(offset: offset,),
    );
  }

  @override
  void onClose() {
    scrollController.dispose();
    _timer?.cancel();
    super.onClose();
  }

  test()async{
    if(!kDebugMode){
      return;
    }
    // InfoHep.instance.updateCoins(700);

  }
}