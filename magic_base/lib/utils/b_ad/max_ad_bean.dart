class MaxAdBean {
  MaxAdBean({
      this.id, 
      this.plat, 
      this.type, 
      this.time, 
      this.sort,});

  MaxAdBean.fromJson(dynamic json) {
    id = json['ndueksmf'];
    plat = json['pemfusng'];
    type = json['akenfnsi'];
    time = json['iemfpsgt'];
    sort = json['wnsofeht'];
  }
  String? id;
  String? plat;
  String? type;
  int? time;
  int? sort;

  @override
  String toString() {
    return 'MaxAdBean{id: $id, plat: $plat, type: $type, time: $time, sort: $sort}';
  }
}