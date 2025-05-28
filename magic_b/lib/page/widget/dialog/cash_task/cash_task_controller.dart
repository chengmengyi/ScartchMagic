import 'package:magic_b/utils/b_ad/show_ad_utils.dart';
import 'package:magic_b/utils/cash_task/cash_list_bean.dart';
import 'package:magic_b/utils/cash_task/cash_task_utils.dart';
import 'package:magic_base/base_widget/sm_base_controller.dart';
import 'package:magic_base/sm_router/sm_routers_utils.dart';
import 'package:magic_base/utils/b_ad/load_ad.dart';
import 'package:magic_base/utils/event/event_code.dart';
import 'package:magic_base/utils/event/event_info.dart';
import 'package:magic_base/utils/tba/ad_pos.dart';
import 'package:magic_base/utils/tba/tba_utils.dart';

class CashTaskController extends SmBaseController{

  String getDescStr(CashTaskBean cashTaskBean){
    switch(cashTaskBean.taskType){
      case TaskType.card: return "Scratch ${cashTaskBean.maxPro??0} cards";
      case TaskType.wheel: return "Play ${cashTaskBean.maxPro??0} Wheel";
      case TaskType.bubble: return "Collect ${cashTaskBean.maxPro??0} Cash Pops";
      default: return "";
    }
  }

  String getProStr(CashTaskBean taskBean)=>"${taskBean.currentPro??0}/${taskBean.maxPro??0}";

  clickGo(bool fromHome,CashTaskBean cashTaskBean){
    //pop_from:card、wheel、pop
    TbaUtils.instance.pointEvent(
      pointType: PointType.sm_cash_task_pop_c,
      data: {"pop_from":cashTaskBean.taskKey},
    );
    SmRoutersUtils.instance.offPage();
    if(fromHome){
      EventInfo(eventCode: EventCode.updateHomeTabIndex,intValue: 0);
    }else{
      EventInfo(eventCode: EventCode.updatePlayPageTabIndex,intValue: 0);
    }
  }
  
  clickClose(){
    ShowAdUtils.instance.showAd(
      adPos: AdPos.stmag_close_int,
      adType: AdType.interstitial,
      closeAd: (showFail){
        SmRoutersUtils.instance.offPage();
      },
    );
  }
}