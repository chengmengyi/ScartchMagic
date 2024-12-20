import 'package:magic_base/utils/b_ad/max_ad_bean.dart';

class ConfAdBean {
  ConfAdBean({
      this.idnmrhft, 
      this.owmdhdfr, 
      this.stmagIntOne, 
      this.stmagIntTwo, 
      this.stmagRvOne, 
      this.stmagRvTwo,
  });

  ConfAdBean.fromJson(dynamic json) {
    idnmrhft = json['idnmrhft'];
    owmdhdfr = json['owmdhdfr'];
    if (json['stmag_int_one'] != null) {
      stmagIntOne = [];
      json['stmag_int_one'].forEach((v) {
        stmagIntOne?.add(MaxAdBean.fromJson(v));
      });
    }
    if (json['stmag_int_two'] != null) {
      stmagIntTwo = [];
      json['stmag_int_two'].forEach((v) {
        stmagIntTwo?.add(MaxAdBean.fromJson(v));
      });
    }
    if (json['stmag_rv_one'] != null) {
      stmagRvOne = [];
      json['stmag_rv_one'].forEach((v) {
        stmagRvOne?.add(MaxAdBean.fromJson(v));
      });
    }
    if (json['stmag_rv_two'] != null) {
      stmagRvTwo = [];
      json['stmag_rv_two'].forEach((v) {
        stmagRvTwo?.add(MaxAdBean.fromJson(v));
      });
    }
  }
  int? idnmrhft;
  int? owmdhdfr;
  List<MaxAdBean>? stmagIntOne;
  List<MaxAdBean>? stmagIntTwo;
  List<MaxAdBean>? stmagRvOne;
  List<MaxAdBean>? stmagRvTwo;
}