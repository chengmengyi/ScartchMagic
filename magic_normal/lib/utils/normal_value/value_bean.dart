class ValueBean {
  ValueBean({
      this.smCardFruit, 
      this.smCardNumber, 
      this.smCardTiger, 
      this.smCard77hot, 
      this.smCardEmoji, 
      this.smCard8rich,});

  ValueBean.fromJson(dynamic json) {
    smCardFruit = json['sm_card_fruit'] != null ? SmCardFruit.fromJson(json['sm_card_fruit']) : null;
    smCardNumber = json['sm_card_number'] != null ? SmCardNumber.fromJson(json['sm_card_number']) : null;
    smCardTiger = json['sm_card_tiger'] != null ? SmCardTiger.fromJson(json['sm_card_tiger']) : null;
    smCard77hot = json['sm_card_77hot'] != null ? SmCard77hot.fromJson(json['sm_card_77hot']) : null;
    smCardEmoji = json['sm_card_emoji'] != null ? SmCardEmoji.fromJson(json['sm_card_emoji']) : null;
    smCard8rich = json['sm_card_8rich'] != null ? SmCard8rich.fromJson(json['sm_card_8rich']) : null;
  }
  SmCardFruit? smCardFruit;
  SmCardNumber? smCardNumber;
  SmCardTiger? smCardTiger;
  SmCard77hot? smCard77hot;
  SmCardEmoji? smCardEmoji;
  SmCard8rich? smCard8rich;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (smCardFruit != null) {
      map['sm_card_fruit'] = smCardFruit?.toJson();
    }
    if (smCardNumber != null) {
      map['sm_card_number'] = smCardNumber?.toJson();
    }
    if (smCardTiger != null) {
      map['sm_card_tiger'] = smCardTiger?.toJson();
    }
    if (smCard77hot != null) {
      map['sm_card_77hot'] = smCard77hot?.toJson();
    }
    if (smCardEmoji != null) {
      map['sm_card_emoji'] = smCardEmoji?.toJson();
    }
    if (smCard8rich != null) {
      map['sm_card_8rich'] = smCard8rich?.toJson();
    }
    return map;
  }

}

class SmCard8rich {
  SmCard8rich({
      this.winupNumber, 
      this.point3match, 
      this.point8bet, 
      this.prize,});

  SmCard8rich.fromJson(dynamic json) {
    winupNumber = json['winup_number'];
    point3match = json['point_3match'];
    point8bet = json['point_8bet'];
    prize = json['prize'] != null ? json['prize'].cast<int>() : [];
  }
  int? winupNumber;
  int? point3match;
  int? point8bet;
  List<int>? prize;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['winup_number'] = winupNumber;
    map['point_3match'] = point3match;
    map['point_8bet'] = point8bet;
    map['prize'] = prize;
    return map;
  }

}

class SmCardEmoji {
  SmCardEmoji({
      this.winupNumber, 
      this.pointFace, 
      this.prize,});

  SmCardEmoji.fromJson(dynamic json) {
    winupNumber = json['winup_number'];
    pointFace = json['point_face'];
    prize = json['prize'] != null ? json['prize'].cast<int>() : [];
  }
  int? winupNumber;
  int? pointFace;
  List<int>? prize;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['winup_number'] = winupNumber;
    map['point_face'] = pointFace;
    map['prize'] = prize;
    return map;
  }

}

class SmCard77hot {
  SmCard77hot({
      this.winupNumber, 
      this.point7, 
      this.point77, 
      this.prize,});

  SmCard77hot.fromJson(dynamic json) {
    winupNumber = json['winup_number'];
    point7 = json['point_7'];
    point77 = json['point_77'];
    prize = json['prize'] != null ? json['prize'].cast<int>() : [];
  }
  int? winupNumber;
  int? point7;
  int? point77;
  List<int>? prize;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['winup_number'] = winupNumber;
    map['point_7'] = point7;
    map['point_77'] = point77;
    map['prize'] = prize;
    return map;
  }

}

class SmCardTiger {
  SmCardTiger({
      this.winupNumber, 
      this.point, 
      this.tiger3, 
      this.tiger4, 
      this.tiger5, 
      this.tiger6, 
      this.tiger7, 
      this.tiger8, 
      this.tiger9, 
      this.prize,});

  SmCardTiger.fromJson(dynamic json) {
    winupNumber = json['winup_number'];
    point = json['point'];
    tiger3 = json['tiger3'];
    tiger4 = json['tiger4'];
    tiger5 = json['tiger5'];
    tiger6 = json['tiger6'];
    tiger7 = json['tiger7'];
    tiger8 = json['tiger8'];
    tiger9 = json['tiger9'];
    prize = json['prize'] != null ? json['prize'].cast<int>() : [];
  }
  int? winupNumber;
  int? point;
  int? tiger3;
  int? tiger4;
  int? tiger5;
  int? tiger6;
  int? tiger7;
  int? tiger8;
  int? tiger9;
  List<int>? prize;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['winup_number'] = winupNumber;
    map['point'] = point;
    map['tiger3'] = tiger3;
    map['tiger4'] = tiger4;
    map['tiger5'] = tiger5;
    map['tiger6'] = tiger6;
    map['tiger7'] = tiger7;
    map['tiger8'] = tiger8;
    map['tiger9'] = tiger9;
    map['prize'] = prize;
    return map;
  }

}

class SmCardNumber {
  SmCardNumber({
      this.winupNumber, 
      this.point, 
      this.prize,});

  SmCardNumber.fromJson(dynamic json) {
    winupNumber = json['winup_number'];
    point = json['point'];
    prize = json['prize'] != null ? json['prize'].cast<int>() : [];
  }
  int? winupNumber;
  int? point;
  List<int>? prize;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['winup_number'] = winupNumber;
    map['point'] = point;
    map['prize'] = prize;
    return map;
  }

}

class SmCardFruit {
  SmCardFruit({
      this.winupNumber, 
      this.point, 
      this.prize,});

  SmCardFruit.fromJson(dynamic json) {
    winupNumber = json['winup_number'];
    point = json['point'];
    prize = json['prize'] != null ? json['prize'].cast<int>() : [];
  }
  int? winupNumber;
  int? point;
  List<int>? prize;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['winup_number'] = winupNumber;
    map['point'] = point;
    map['prize'] = prize;
    return map;
  }

}