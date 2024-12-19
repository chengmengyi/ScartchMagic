class CashListBean{
  int cashNum;
  List<CashTaskBean> list;
  CashListBean({
    required this.cashNum,
    required this.list,
  });
}

class CashTaskBean {
  CashTaskBean({
    this.taskType,
    this.cashType,
    this.cashMoney,
    this.currentPro,
    this.timer,
    this.maxPro,
    this.maxDays,
    this.account,
    this.completeStatus,
  });

  CashTaskBean.fromJson(dynamic json) {
    taskType = json['taskType'];
    cashType = json['cashType'];
    cashMoney = json['cashMoney'];
    currentPro = json['currentPro'];
    timer = json['timer'];
    maxPro = json['maxPro'];
    maxDays = json['maxDays'];
    account = json['account'];
    completeStatus = json['completeStatus'];
  }
  int? taskType;
  int? cashType;
  int? cashMoney;
  int? currentPro;
  int? maxPro;
  int? maxDays;
  int? completeStatus;  //0未完成1已完成
  String? timer;
  String? account;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['taskType'] = taskType;
    map['cashType'] = cashType;
    map['cashMoney'] = cashMoney;
    map['currentPro'] = currentPro;
    map['timer'] = timer;
    map['maxPro'] = maxPro;
    map['maxDays'] = maxDays;
    map['account'] = account;
    map['completeStatus'] = completeStatus;
    return map;
  }

}