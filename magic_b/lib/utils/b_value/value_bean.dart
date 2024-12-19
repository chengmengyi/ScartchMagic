class ValueBean {
  ValueBean({
      this.cardRange, 
      this.newPrize, 
      this.intadPoint, 
      this.floatPrize, 
      this.wheelPoint, 
      this.keyOut, 
      this.cardFruit, 
      this.cardNumber, 
      this.cardTiger, 
      this.card77hot, 
      this.cardEmoji, 
      this.card8rich, 
      this.wtdTask, 
      this.winupNumber, 
      this.checkReward,
      this.boxPrize,
  });

  ValueBean.fromJson(dynamic json) {
    cardRange = json['card_range'] != null ? json['card_range'].cast<int>() : [];
    newPrize = json['new_prize'];
    if (json['intad_point'] != null) {
      intadPoint = [];
      json['intad_point'].forEach((v) {
        intadPoint?.add(IntadPoint.fromJson(v));
      });
    }
    if (json['float_prize'] != null) {
      floatPrize = [];
      json['float_prize'].forEach((v) {
        floatPrize?.add(Prize.fromJson(v));
      });
    }
    wheelPoint = json['wheel_point'] != null ? WheelPoint.fromJson(json['wheel_point']) : null;
    if (json['key_out'] != null) {
      keyOut = [];
      json['key_out'].forEach((v) {
        keyOut?.add(KeyOut.fromJson(v));
      });
    }
    cardFruit = json['card_fruit'] != null ? CardFruit.fromJson(json['card_fruit']) : null;
    cardNumber = json['card_number'] != null ? CardNumber.fromJson(json['card_number']) : null;
    cardTiger = json['card_tiger'] != null ? CardTiger.fromJson(json['card_tiger']) : null;
    card77hot = json['card_77hot'] != null ? Card77hot.fromJson(json['card_77hot']) : null;
    cardEmoji = json['card_emoji'] != null ? CardEmoji.fromJson(json['card_emoji']) : null;
    card8rich = json['card_8rich'] != null ? Card8rich.fromJson(json['card_8rich']) : null;
    wtdTask = json['wtd_task'] != null ? WtdTask.fromJson(json['wtd_task']) : null;
    winupNumber = json['winup_number'] != null ? json['winup_number'].cast<int>() : [];
    checkReward = json['check_reward'] != null ? json['check_reward'].cast<int>() : [];
    if (json['box_prize'] != null) {
      boxPrize = [];
      json['box_prize'].forEach((v) {
        boxPrize?.add(Prize.fromJson(v));
      });
    }
  }
  List<int>? cardRange;
  int? newPrize;
  List<IntadPoint>? intadPoint;
  List<Prize>? floatPrize;
  WheelPoint? wheelPoint;
  List<KeyOut>? keyOut;
  CardFruit? cardFruit;
  CardNumber? cardNumber;
  CardTiger? cardTiger;
  Card77hot? card77hot;
  CardEmoji? cardEmoji;
  Card8rich? card8rich;
  WtdTask? wtdTask;
  List<int>? winupNumber;
  List<int>? checkReward;
  List<Prize>? boxPrize;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['card_range'] = cardRange;
    map['new_prize'] = newPrize;
    if (intadPoint != null) {
      map['intad_point'] = intadPoint?.map((v) => v.toJson()).toList();
    }
    if (floatPrize != null) {
      map['float_prize'] = floatPrize?.map((v) => v.toJson()).toList();
    }
    if (wheelPoint != null) {
      map['wheel_point'] = wheelPoint?.toJson();
    }
    if (keyOut != null) {
      map['key_out'] = keyOut?.map((v) => v.toJson()).toList();
    }
    if (cardFruit != null) {
      map['card_fruit'] = cardFruit?.toJson();
    }
    if (cardNumber != null) {
      map['card_number'] = cardNumber?.toJson();
    }
    if (cardTiger != null) {
      map['card_tiger'] = cardTiger?.toJson();
    }
    if (card77hot != null) {
      map['card_77hot'] = card77hot?.toJson();
    }
    if (cardEmoji != null) {
      map['card_emoji'] = cardEmoji?.toJson();
    }
    if (card8rich != null) {
      map['card_8rich'] = card8rich?.toJson();
    }
    if (wtdTask != null) {
      map['wtd_task'] = wtdTask?.toJson();
    }
    map['winup_number'] = winupNumber;
    map['check_reward'] = checkReward;
    if (boxPrize != null) {
      map['box_prize'] = boxPrize?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class WtdTask {
  WtdTask({
      this.cardNumber, 
      this.cardDay, 
      this.wheelNumber, 
      this.wheelDay, 
      this.bubbleNumber, 
      this.bubbleDay,});

  WtdTask.fromJson(dynamic json) {
    cardNumber = json['card_number'];
    cardDay = json['card_day'];
    wheelNumber = json['wheel_number'];
    wheelDay = json['wheel_day'];
    bubbleNumber = json['bubble_number'];
    bubbleDay = json['bubble_day'];
  }
  int? cardNumber;
  int? cardDay;
  int? wheelNumber;
  int? wheelDay;
  int? bubbleNumber;
  int? bubbleDay;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['card_number'] = cardNumber;
    map['card_day'] = cardDay;
    map['wheel_number'] = wheelNumber;
    map['wheel_day'] = wheelDay;
    map['bubble_number'] = bubbleNumber;
    map['bubble_day'] = bubbleDay;
    return map;
  }

}

class Card8rich {
  Card8rich({
      this.point3match, 
      this.point8bet, 
      this.prize,});

  Card8rich.fromJson(dynamic json) {
    point3match = json['point_3match'];
    point8bet = json['point_8bet'];
    if (json['prize'] != null) {
      prize = [];
      json['prize'].forEach((v) {
        prize?.add(Prize.fromJson(v));
      });
    }
  }
  int? point3match;
  int? point8bet;
  List<Prize>? prize;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['point_3match'] = point3match;
    map['point_8bet'] = point8bet;
    if (prize != null) {
      map['prize'] = prize?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Prize {
  Prize({
      this.firstNumber, 
      this.prize, 
      this.endNumber,});

  Prize.fromJson(dynamic json) {
    firstNumber = json['first_number'];
    prize = json['prize'] != null ? json['prize'].cast<int>() : [];
    endNumber = json['end_number'];
  }
  int? firstNumber;
  List<int>? prize;
  int? endNumber;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['first_number'] = firstNumber;
    map['prize'] = prize;
    map['end_number'] = endNumber;
    return map;
  }

}

class CardEmoji {
  CardEmoji({
      this.pointFace, 
      this.prize,});

  CardEmoji.fromJson(dynamic json) {
    pointFace = json['point_face'];
    if (json['prize'] != null) {
      prize = [];
      json['prize'].forEach((v) {
        prize?.add(Prize.fromJson(v));
      });
    }
  }
  int? pointFace;
  List<Prize>? prize;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['point_face'] = pointFace;
    if (prize != null) {
      map['prize'] = prize?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Card77hot {
  Card77hot({
      this.point7, 
      this.point77, 
      this.prize,});

  Card77hot.fromJson(dynamic json) {
    point7 = json['point_7'];
    point77 = json['point_77'];
    if (json['prize'] != null) {
      prize = [];
      json['prize'].forEach((v) {
        prize?.add(Prize.fromJson(v));
      });
    }
  }
  int? point7;
  int? point77;
  List<Prize>? prize;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['point_7'] = point7;
    map['point_77'] = point77;
    if (prize != null) {
      map['prize'] = prize?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class CardTiger {
  CardTiger({
      this.tiger3, 
      this.tiger4, 
      this.tiger5, 
      this.tiger6, 
      this.tiger7, 
      this.tiger8, 
      this.tiger9, 
      this.tiger10, 
      this.prize,});

  CardTiger.fromJson(dynamic json) {
    point = json['point'];
    tiger3 = json['tiger3'];
    tiger4 = json['tiger4'];
    tiger5 = json['tiger5'];
    tiger6 = json['tiger6'];
    tiger7 = json['tiger7'];
    tiger8 = json['tiger8'];
    tiger9 = json['tiger9'];
    tiger10 = json['tiger10'];
    if (json['prize'] != null) {
      prize = [];
      json['prize'].forEach((v) {
        prize?.add(Prize.fromJson(v));
      });
    }
  }
  int? point;
  int? tiger3;
  int? tiger4;
  int? tiger5;
  int? tiger6;
  int? tiger7;
  int? tiger8;
  int? tiger9;
  int? tiger10;
  List<Prize>? prize;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['point'] = point;
    map['tiger3'] = tiger3;
    map['tiger4'] = tiger4;
    map['tiger5'] = tiger5;
    map['tiger6'] = tiger6;
    map['tiger7'] = tiger7;
    map['tiger8'] = tiger8;
    map['tiger9'] = tiger9;
    map['tiger10'] = tiger10;
    if (prize != null) {
      map['prize'] = prize?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class CardNumber {
  CardNumber({
      this.point, 
      this.prize,});

  CardNumber.fromJson(dynamic json) {
    point = json['point'];
    if (json['prize'] != null) {
      prize = [];
      json['prize'].forEach((v) {
        prize?.add(Prize.fromJson(v));
      });
    }
  }
  int? point;
  List<Prize>? prize;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['point'] = point;
    if (prize != null) {
      map['prize'] = prize?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class CardFruit {
  CardFruit({
      this.point, 
      this.prize,});

  CardFruit.fromJson(dynamic json) {
    point = json['point'];
    if (json['prize'] != null) {
      prize = [];
      json['prize'].forEach((v) {
        prize?.add(Prize.fromJson(v));
      });
    }
  }
  int? point;
  List<Prize>? prize;
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['point'] = point;
    if (prize != null) {
      map['prize'] = prize?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}


class KeyOut {
  KeyOut({
      this.firstNumber, 
      this.point, 
      this.endNumber,});

  KeyOut.fromJson(dynamic json) {
    firstNumber = json['first_number'];
    point = json['point'];
    endNumber = json['end_number'];
  }
  int? firstNumber;
  int? point;
  int? endNumber;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['first_number'] = firstNumber;
    map['point'] = point;
    map['end_number'] = endNumber;
    return map;
  }

}

class WheelPoint {
  WheelPoint({
      this.point20, 
      this.point50, 
      this.point80, 
      this.point100, 
      this.iphonePoint,});

  WheelPoint.fromJson(dynamic json) {
    point20 = json['point_20'];
    point50 = json['point_50'];
    point80 = json['point_80'];
    point100 = json['point_100'];
    iphonePoint = json['iphone_point'];
  }
  int? point20;
  int? point50;
  int? point80;
  int? point100;
  int? iphonePoint;
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['point_20'] = point20;
    map['point_50'] = point50;
    map['point_80'] = point80;
    map['point_100'] = point100;
    map['iphone_point'] = iphonePoint;
    return map;
  }

}

class IntadPoint {
  IntadPoint({
      this.firstNumber, 
      this.point, 
      this.endNumber,});

  IntadPoint.fromJson(dynamic json) {
    firstNumber = json['first_number'];
    point = json['point'];
    endNumber = json['end_number'];
  }
  int? firstNumber;
  int? point;
  int? endNumber;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['first_number'] = firstNumber;
    map['point'] = point;
    map['end_number'] = endNumber;
    return map;
  }

}