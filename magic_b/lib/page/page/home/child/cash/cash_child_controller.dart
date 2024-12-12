import 'package:magic_b/utils/b_storage/b_storage_hep.dart';
import 'package:magic_base/base_widget/sm_base_controller.dart';

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

  @override
  void onInit() {
    super.onInit();
    print("kk==CashChildController==onInit");
  }
  @override
  void onReady() {
    super.onReady();
    print("kk==CashChildController==onReady");
  }

  clickCashType(index){
    if(index==cashIndex){
      return;
    }
    cashIndex=index;
    cashTypeIndex.write(index);
    update(["cash_type","money_bg"]);
  }

  clickCashOut(){

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
}