import 'package:applovin_max/applovin_max.dart';
import 'package:magic_base/utils/b_ad/max_ad_bean.dart';
import 'package:magic_base/utils/storage/storage_hep.dart';
import 'package:magic_base/utils/tba/ad_event.dart';
import 'package:magic_base/utils/tba/ad_pos.dart';
import 'package:magic_base/utils/tba/install_event.dart';
import 'package:magic_base/utils/tba/point_event.dart';
import 'package:magic_base/utils/tba/session_event.dart';

StorageHep<bool> installUpload=StorageHep<bool>(key: "installUpload", defaultValue: false);

class TbaUtils{
  factory TbaUtils()=>_getInstance();
  static TbaUtils get instance => _getInstance();
  static TbaUtils? _instance;
  static TbaUtils _getInstance(){
    _instance??=TbaUtils._internal();
    return _instance!;
  }

  TbaUtils._internal();

  install(){
    if(!installUpload.read()){
      InstallEvent().upload();
      pointEvent(pointType: PointType.sm_install);
    }
    SessionEvent().upload();
    pointEvent(pointType: PointType.sm_session);
  }

  adEvent(MaxAd maxAd,MaxAdBean? maxAdBean,AdPos adPos){
    AdEvent().upload(maxAd, maxAdBean, adPos);
  }

  pointEvent({required PointType pointType, Map<String,dynamic>? data}){
    PointEvent().upload(pointType: pointType,data: data);
  }
}