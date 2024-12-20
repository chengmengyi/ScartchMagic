import 'package:magic_b/utils/cash_task/cash_list_bean.dart';
import 'package:magic_b/utils/cash_task/cash_task_utils.dart';
import 'package:magic_base/base_widget/sm_base_controller.dart';
import 'package:magic_base/sm_router/sm_routers_utils.dart';
import 'package:magic_base/utils/event/event_code.dart';
import 'package:magic_base/utils/event/event_info.dart';
import 'package:magic_base/utils/tba/ad_pos.dart';
import 'package:magic_base/utils/tba/tba_utils.dart';

class CashTaskController extends SmBaseController{

  @override
  void onInit() {
    super.onInit();
    TbaUtils.instance.pointEvent(pointType: PointType.sm_cash_task_pop);
  }

  String getDescStr(CashTaskBean cashTaskBean){
    switch(cashTaskBean.taskType){
      case TaskType.card: return "Scratch ${cashTaskBean.maxPro??0} cards for ${cashTaskBean.maxDays??0} consecutive days";
      case TaskType.wheel: return "Play ${cashTaskBean.maxPro??0} Wheel for ${cashTaskBean.maxDays??0} consecutive days";
      case TaskType.bubble: return "Collect ${cashTaskBean.maxPro??0} Cash Pops for ${cashTaskBean.maxDays??0} consecutive days";
      default: return "";
    }
  }

  String getProStr(List<CashTaskBean> list){
    var current = list.map((item) => (item.currentPro??0)).reduce((a, b) => a + b);
    return "$current/${list.first.maxPro??0}";
  }

  clickGo(bool fromHome){
    TbaUtils.instance.pointEvent(pointType: PointType.sm_cash_task_pop_c);
    SmRoutersUtils.instance.offPage();
    if(fromHome){
      EventInfo(eventCode: EventCode.updateHomeTabIndex,intValue: 0);
    }else{
      EventInfo(eventCode: EventCode.updatePlayPageTabIndex,intValue: 0);
    }
  }
}