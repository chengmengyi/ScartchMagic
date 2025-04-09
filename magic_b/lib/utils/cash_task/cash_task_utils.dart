import 'dart:async';

import 'package:magic_b/utils/b_sql/b_sql_utils.dart';
import 'package:magic_b/utils/b_value/b_value_hep.dart';
import 'package:magic_b/utils/cash_task/cash_list_bean.dart';

class TaskType{
  static const int card=0;
  static const int bubble=1;
  static const int wheel=2;
}

class TaskKey{
  static const String card1Number="card1Number";
  static const String bubble1Number="bubble1Number";
  static const String wheel1Number="wheel1Number";
  static const String card2Number="card2Number";
  static const String bubble2Number="bubble2Number";
  static const String wheel2Number="wheel2Number";
  static const String card3Number="card3Number";
  static const String bubble3Number="bubble3Number";
  static const String wheel3Number="wheel3Number";
}

class CashTaskUtils{
  factory CashTaskUtils()=>_getInstance();
  static CashTaskUtils get instance => _getInstance();
  static CashTaskUtils? _instance;
  static CashTaskUtils _getInstance(){
    _instance??=CashTaskUtils._internal();
    return _instance!;
  }

  CashTaskUtils._internal();

  Future<List<CashListBean>> getCashListByCashType(int cashTypeIndex)async{
    List<CashListBean> cashList=[];
    for (var money in BValueHep.instance.getCashList()) {
      var taskBean = await BSqlUtils.instance.queryCashTaskListByMoneyAndType(money, cashTypeIndex);
      cashList.add(CashListBean(cashNum: money, taskBean: taskBean));
    }
    return cashList;
  }

  Future<void> insertCashTask(int money,int cashType,String account)async{
    await BSqlUtils.instance.insertCashTask(money, cashType, account, TaskType.card);
  }
}