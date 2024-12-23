import 'dart:async';
import 'package:magic_b/utils/b_ad/show_ad_utils.dart';
import 'package:magic_b/utils/b_sql/b_sql_utils.dart';
import 'package:magic_b/utils/b_value/b_value_hep.dart';
import 'package:magic_b/utils/cash_task/cash_task_utils.dart';
import 'package:magic_b/utils/info_hep.dart';
import 'package:magic_base/base_widget/sm_base_controller.dart';
import 'package:magic_base/utils/b_ad/load_ad.dart';
import 'package:magic_base/utils/event/event_code.dart';
import 'package:magic_base/utils/event/event_info.dart';
import 'package:magic_base/utils/sm_export.dart';
import 'package:magic_base/utils/tba/ad_pos.dart';
import 'package:magic_base/utils/tba/tba_utils.dart';

class BubbleWidgetController extends SmBaseController with GetSingleTickerProviderStateMixin{
  double width=360.w,currentX=0.0;
  double height=760.h,currentY=0.0;
  Timer? _timer;
  bool right=true,down=true,showGuide=false,showBubble=true;
  var addNum=BValueHep.instance.getBubbleReward();

  @override
  void onInit() {
    super.onInit();

  }

  @override
  void onReady() {
    super.onReady();
    _initAnimator();
  }

  clickBubble(){
    BSqlUtils.instance.updateCashTaskPro(TaskType.bubble);
    TbaUtils.instance.pointEvent(pointType: PointType.sm_float_c);
    showBubble=false;
    update(["bubble"]);
    ShowAdUtils.instance.showAd(
      adPos: AdPos.stmag_bubble_rv,
      adType: AdType.reward,
      closeAd: (showFail){
        _showBubble();
        if(!showFail){
          InfoHep.instance.updateCoins(addNum);
        }
      }
    );
  }

  _showBubble(){
    Future.delayed(const Duration(milliseconds: 10000),(){
      showBubble=true;
      addNum=BValueHep.instance.getBubbleReward();
      update(["bubble"]);
    });
  }

  _initAnimator(){
    _timer=Timer.periodic(const Duration(milliseconds: 10), (timer) {
      if(right){
        currentX++;
        if(down){
          currentY++;
          if(currentY>=height){
            down=false;
          }
        }else{
          currentY--;
          if(currentY<=0){
            down=true;
          }
        }
        if(currentX>=width){
          right=false;
        }
      }else{
        currentX--;
        if(down){
          currentY++;
          if(currentY>=height){
            down=false;
          }
        }else{
          currentY--;
          if(currentY<=0){
            down=true;
          }
        }
        if(currentX<=0){
          right=true;
        }
      }
      update(["bubble"]);
    });
  }

  @override
  bool smRegisterEvent() => true;

  @override
  smEventReceived(EventInfo eventInfo) {
    switch(eventInfo.eventCode){
      case EventCode.showMoneyGetLottie:
        addNum=BValueHep.instance.getBubbleReward();
        update(["bubble"]);
        break;
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    _timer=null;
    super.onClose();
  }
}