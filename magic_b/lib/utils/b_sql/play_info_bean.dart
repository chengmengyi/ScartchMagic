enum PlayType{
  playfruit,playbig,playtiger,play7,playemoji,play8,
}

class PlayInfoBean {
  PlayInfoBean({
    this.type,
    this.hasNum,
    this.maxWin,
    this.playedNum,
  });

  PlayInfoBean.fromJson(dynamic json) {
    type = json['type'];
    hasNum = json['hasNum'];
    playedNum = json['playedNum'];
  }
  String? type;
  int? hasNum;
  int? maxWin;
  int? playedNum;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['type'] = type;
    map['hasNum'] = hasNum;
    map['playedNum'] = playedNum;
    return map;
  }

}