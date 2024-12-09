enum PlayType{
  playfruit,playbig,playtiger,play7,playemoji,play8,
}

class PlayInfoBean {
  PlayInfoBean({
    this.type,
    this.currentPro,
    this.playedNum,
    this.maxWin,
    this.unlock,
    this.time,
  });

  PlayInfoBean.fromJson(dynamic json) {
    type = json['type'];
    currentPro = json['currentPro'];
    playedNum = json['playedNum'];
    unlock = json['unlock'];
    time = json['time'];
  }
  String? type;
  int? currentPro;
  int? playedNum;
  int? maxWin;
  int? unlock;
  int? time;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['type'] = type;
    map['currentPro'] = currentPro;
    map['playedNum'] = playedNum;
    map['unlock'] = unlock;
    map['time'] = time;
    return map;
  }

}