class CashListBean{
  int cashNum;
  CashTaskBean? taskBean;
  CashListBean({
    required this.cashNum,
    required this.taskBean,
  });
}

class CashTaskBean {
  CashTaskBean({
    this.taskKey,
    this.taskType,
    this.cashType,
    this.cashMoney,
    this.currentPro,
    this.maxPro,
    this.account,
    this.completeStatus,
  });

  CashTaskBean.fromJson(dynamic json) {
    taskKey = json['taskKey'];
    taskType = json['taskType'];
    cashType = json['cashType'];
    cashMoney = json['cashMoney'];
    currentPro = json['currentPro'];
    maxPro = json['maxPro'];
    account = json['account'];
    completeStatus = json['completeStatus'];
  }
  String? taskKey;
  int? taskType;
  int? cashType;
  int? cashMoney;
  int? currentPro;
  int? maxPro;
  int? completeStatus;  //0未完成1已完成
  String? account;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['taskKey'] = taskKey;
    map['taskType'] = taskType;
    map['cashType'] = cashType;
    map['cashMoney'] = cashMoney;
    map['currentPro'] = currentPro;
    map['maxPro'] = maxPro;
    map['account'] = account;
    map['completeStatus'] = completeStatus;
    return map;
  }

}