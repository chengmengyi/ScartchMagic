import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:magic_base/base_widget/sm_base_controller.dart';
import 'package:magic_base/sm_router/all_routers_name.dart';
import 'package:magic_base/sm_router/sm_routers_utils.dart';
import 'package:magic_base/utils/event/event_code.dart';
import 'package:magic_base/utils/event/event_info.dart';
import 'package:magic_base/utils/sm_export.dart';
import 'package:magic_base/utils/sm_extension.dart';
import 'package:magic_base/utils/voice/voice_utils.dart';
import 'package:magic_normal/page/widget/dialog/unlock_dialog/unlock_dialog.dart';
import 'package:magic_normal/utils/info_hep.dart';
import 'package:magic_normal/utils/normal_sql/normal_sql_utils.dart';
import 'package:magic_normal/utils/normal_sql/play_info_bean.dart';
import 'package:magic_normal/utils/normal_value/normal_value_hep.dart';

class HomeController extends SmBaseController{
  Timer? _timer;
  List<PlayInfoBean> playList=[];

  @override
  void onReady() {
    super.onReady();
    _initPlayList();
    VoiceUtils.instance.playBgMp3();
    AppTrackingTransparency.requestTrackingAuthorization();
  }

  clickItem(PlayInfoBean bean){
    if((bean.time??0)>0){
      showToast("No scratch card, please go to the next level！");
      return;
    }
    if(bean.unlock!=1){
      SmRoutersUtils.instance.showDialog(
        widget: UnlockDialog(
          playType: bean.type??"",
          bean: bean,
        ),
      );
      return;
    }
    if(bean.type==PlayType.playfruit.name){
      SmRoutersUtils.instance.toNextPage(routersName: AllRoutersName.playFruitA);
    }else if(bean.type==PlayType.playbig.name){
      SmRoutersUtils.instance.toNextPage(routersName: AllRoutersName.playBigA);
    }else if(bean.type==PlayType.playtiger.name){
      SmRoutersUtils.instance.toNextPage(routersName: AllRoutersName.playTigerA);
    }else if(bean.type==PlayType.play7.name){
      SmRoutersUtils.instance.toNextPage(routersName: AllRoutersName.play7A);
    }else if(bean.type==PlayType.playemoji.name){
      SmRoutersUtils.instance.toNextPage(routersName: AllRoutersName.playEmojiA);
    }else if(bean.type==PlayType.play8.name){
      SmRoutersUtils.instance.toNextPage(routersName: AllRoutersName.play8A);
    }
  }

  _initPlayList()async{
    playList.clear();
    var list = await NormalSqlUtils.instance.queryPlayList();
    playList.addAll(list);
    for (var element in playList) {
      element.maxWin=NormalValueHep.instance.getMaxWin(element.type);
    }
    update(["list"]);
    var indexWhere = playList.indexWhere((element) => (element.time??0)>0);
    if(indexWhere>=0&&null==_timer){
      var bean = playList[indexWhere];
      if((bean.time??0)-DateTime.now().millisecondsSinceEpoch<=0){
        _timer?.cancel();
        _timer=null;
        NormalSqlUtils.instance.resetPlayTime(bean.type??"");
        return;
      }
      _timer=Timer.periodic(const Duration(milliseconds: 1000), (timer) {
        var hasTimer = playList.indexWhere((element) => (element.time??0)>0)>=0;
        if(!hasTimer){
          _timer?.cancel();
          _timer=null;
          return;
        }
        update(["list"]);
      });
    }
  }

  String getRefreshTimerStr(PlayInfoBean bean){
    var i = (bean.time??0)-DateTime.now().millisecondsSinceEpoch;
    if(i<=0){
      return "";
    }
    return formatDuration(i);
  }

  double getRefreshTimerEndAngle(PlayInfoBean bean){
    var pro = (36000000-((bean.time??0)-DateTime.now().millisecondsSinceEpoch))/36000000;
    if(pro>=1.0){
      return 270;
    }else if(pro<=0){
      return -90;
    }else{
      return pro*360-90;
    }
  }

  @override
  bool smRegisterEvent() => true;

  @override
  smEventReceived(EventInfo eventInfo) {
    switch(eventInfo.eventCode){
      case EventCode.updateHomeList:
        _initPlayList();
        break;
    }
  }

  @override
  void onClose() {
    super.onClose();
    _timer?.cancel();
  }

  test(){
    if(!kDebugMode){
      return;
    }
    InfoHep.instance.updateCoins(100000000);
  }
}