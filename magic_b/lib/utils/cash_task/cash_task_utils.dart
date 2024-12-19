import 'dart:async';

import 'package:magic_b/utils/b_sql/b_sql_utils.dart';
import 'package:magic_b/utils/b_value/b_value_hep.dart';
import 'package:magic_b/utils/cash_task/cash_list_bean.dart';

class TaskType{
  static const int card=1;
  static const int wheel=2;
  static const int bubble=3;
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
      var list = await BSqlUtils.instance.queryCashTaskListByMoneyAndType(money, cashTypeIndex);
      cashList.add(CashListBean(cashNum: money, list: list));
    }
    return cashList;
  }

  Future<void> insertCashTask(int money,int cashType,String account)async{
    await BSqlUtils.instance.insertCashTask(money, cashType, account, TaskType.card);
  }
}