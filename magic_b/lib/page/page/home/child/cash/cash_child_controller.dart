import 'package:magic_b/page/widget/dialog/cash_task/cash_task_dialog.dart';
import 'package:magic_b/page/widget/dialog/input_account/input_account_dialog.dart';
import 'package:magic_b/page/widget/dialog/no_money/no_money_dialog.dart';
import 'package:magic_b/utils/b_storage/b_storage_hep.dart';
import 'package:magic_b/utils/cash_task/cash_list_bean.dart';
import 'package:magic_b/utils/cash_task/cash_task_utils.dart';
import 'package:magic_b/utils/info_hep.dart';
import 'package:magic_base/base_widget/sm_base_controller.dart';
import 'package:magic_base/sm_router/sm_routers_utils.dart';
import 'package:magic_base/utils/event/event_code.dart';
import 'package:magic_base/utils/event/event_info.dart';
import 'package:magic_base/utils/sm_extension.dart';
import 'package:magic_base/utils/tba/ad_pos.dart';
import 'package:magic_base/utils/tba/tba_utils.dart';

import 'cash_type_bean.dart';

class CashChildController extends SmBaseController{
  //0pay 1 ama 2gp 3mas 4cash 5web
  var cashIndex=cashTypeIndex.read();
  List<CashTypeBean> cashTypeList=[
    CashTypeBean(unsIcon: "cash_type_uns_pay", selIcon: "cash_type_sel_pay"),
    CashTypeBean(unsIcon: "cash_type_uns_ama", selIcon: "cash_type_sel_ama"),
    CashTypeBean(unsIcon: "cash_type_uns_gp", selIcon: "cash_type_sel_gp"),
    CashTypeBean(unsIcon: "cash_type_uns_mas", selIcon: "cash_type_sel_mas"),
    CashTypeBean(unsIcon: "cash_type_uns_cash", selIcon: "cash_type_sel_cash"),
    CashTypeBean(unsIcon: "cash_type_uns_web", selIcon: "cash_type_sel_web"),
  ];
  List<CashListBean> cashList=[];

  @override
  void onInit() {
    super.onInit();
    print("kk==CashChildController==onInit");
  }
  @override
  void onReady() {
    super.onReady();
    print("kk==CashChildController==onReady");
    updateCashList();
  }

  clickCashType(index){
    if(index==cashIndex){
      return;
    }
    cashIndex=index;
    cashTypeIndex.write(index);
    update(["cash_type","money_bg"]);
    updateCashList();
  }

  clickCashOut(CashListBean bean,bool fromHome){
    TbaUtils.instance.pointEvent(pointType: PointType.sm_cash_out_c,data: {"money":bean.cashNum});
    var list = bean.list;
    if(list.isNotEmpty){
      if(list.first.completeStatus==1){
        showToast("Cash has arrived, please check your account");
        return ;
      }
      var indexWhere = list.indexWhere((element) => element.timer==getTodayTime());
      if(indexWhere>=0){
        var cashTaskBean = list[indexWhere];
        if((cashTaskBean.currentPro??0)>=(cashTaskBean.maxPro??0)){
          showToast("Completed 1 day's task in a row, come back tomorrow");
          return;
        }
      }
      SmRoutersUtils.instance.showDialog(
        widget: CashTaskDialog(
          list: list,
          fromHome: fromHome,
        )
      );
      return;
    }
    if(coins.read()<bean.cashNum){
      SmRoutersUtils.instance.showDialog(widget: NoMoneyDialog());
      return;
    }
    SmRoutersUtils.instance.showDialog(
      widget: InputAccountDialog(
        cashNum: bean.cashNum,
        dismiss: (String account)async{
          hasCreateCash.write(true);
          await CashTaskUtils.instance.insertCashTask(bean.cashNum, cashIndex, account);
          InfoHep.instance.updateCoins(-bean.cashNum);
          updateCashList();
        },
      ),
    );
  }

  updateCashList()async{
    cashList.clear();
    var list = await CashTaskUtils.instance.getCashListByCashType(cashIndex);
    cashList.addAll(list);
    update(["cash_list"]);
  }

  getMoneyBg(){
    switch(cashIndex){
      case 0: return "money_bg_pay";
      case 1: return "money_bg_ama";
      case 2: return "money_bg_gp";
      case 3: return "money_bg_mas";
      case 4: return "money_bg_cash";
      case 5: return "money_bg_web";
      default: return "money_bg_web";
    }
  }

  String getTitleStr(List<CashTaskBean> list){
    var cashTaskBean = list.first;
    switch(cashTaskBean.taskType){
      case TaskType.card: return "Scratch ${cashTaskBean.maxPro??0} Cards";
      case TaskType.wheel: return "Spin ${cashTaskBean.maxPro??0} Wheels";
      case TaskType.bubble: return "Collect ${cashTaskBean.maxPro??0} Pops";
      default: return "";
    }
  }

  String getTaskProStr(List<CashTaskBean> list){
    var first = list.first;
    if(first.completeStatus==1){
      return "${first.maxPro??0}/${first.maxPro??0}";
    }
    var current = list.map((item) => (item.currentPro??0)).reduce((a, b) => a + b);
    return "$current/${list.first.maxPro??0}";
  }

  bool completeCurrentPro(List<CashTaskBean> list){
    if(list.first.completeStatus==1){
      return true;
    }
    var current = list.map((item) => (item.currentPro??0)).reduce((a, b) => a + b);
    return current>=(list.first.maxPro??0);
  }

  String getDaysProStr(List<CashTaskBean> list){
    var first = list.first;
    if(first.completeStatus==1){
      return "${first.maxDays??0}/${first.maxDays??0}";
    }
    return "${list.length}/${list.first.maxDays??0}";
  }

  bool completeCurrentDays(List<CashTaskBean> list){
    if(list.first.completeStatus==1){
      return true;
    }
    return list.length>=(list.first.maxDays??0);
  }

  String getBtnStr(List<CashTaskBean> list){
    if(list.isEmpty){
      return "Cash Out";
    }
    if(list.first.completeStatus==1){
      return "Completed";
    }
    var indexWhere = list.indexWhere((element) => element.timer==getTodayTime());
    if(indexWhere>=0){
      var cashTaskBean = list[indexWhere];
      return (cashTaskBean.currentPro??0)>=(cashTaskBean.maxPro??0)?"Completed":"Cash Out";
    }
    return "Cash Out";
  }

  @override
  bool smRegisterEvent() => true;

  @override
  smEventReceived(EventInfo eventInfo) {
    switch(eventInfo.eventCode){
      case EventCode.updateCoins:
        update(["cash_list","coins"]);
        break;
      case EventCode.updateCashTaskList:
        updateCashList();
        break;
    }
  }
}