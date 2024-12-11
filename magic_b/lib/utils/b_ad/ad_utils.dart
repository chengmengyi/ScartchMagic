class AdUtils{
  factory AdUtils()=>_getInstance();
  static AdUtils get instance => _getInstance();
  static AdUtils? _instance;
  static AdUtils _getInstance(){
    _instance??=AdUtils._internal();
    return _instance!;
  }

  AdUtils._internal();

  showAd({
    required Function() closeAd,
  }){
    closeAd.call();
  }
}