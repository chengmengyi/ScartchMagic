import 'package:magic_base/utils/data.dart';
import 'package:magic_base/utils/sm_export.dart';
import 'package:magic_base/utils/sm_extension.dart';

class NormalAdUtils{
  factory NormalAdUtils()=>_getInstance();
  static NormalAdUtils get instance => _getInstance();
  static NormalAdUtils? _instance;
  static NormalAdUtils _getInstance(){
    _instance??=NormalAdUtils._internal();
    return _instance!;
  }

  NormalAdUtils._internal();

  final String _rewardId="d7be78de3dd0439d";
  var _loadSuccess=false;
  Function()? _onAdHiddenCallback;

  initMax()async{
    var maxConfiguration = await AppLovinMAX.initialize(maxKeyBase64.base64());
    _setRewardListener();
    _loadAd();
  }

  _setRewardListener(){
    AppLovinMAX.setRewardedAdListener(
        RewardedAdListener(
            onAdLoadedCallback: (MaxAd ad) {
              _loadSuccess=true;
            },
            onAdLoadFailedCallback: (String adUnitId, MaxError error) {
              _loadSuccess=false;
            },
            onAdDisplayedCallback: (MaxAd ad) {

            },
            onAdDisplayFailedCallback: (MaxAd ad, MaxError error) {

            },
            onAdClickedCallback: (MaxAd ad) {

            },
            onAdHiddenCallback: (MaxAd ad) {
              _onAdHiddenCallback?.call();
              _loadAd();
            },
            onAdReceivedRewardCallback: (MaxAd ad, MaxReward reward) {

            },
            onAdRevenuePaidCallback: (MaxAd ad){

            }
        )
    );
  }

  _loadAd(){
    AppLovinMAX.loadRewardedAd(_rewardId);
  }

  showAd({
    required Function() onAdHiddenCallback,
  }){
    if(!_loadSuccess){
      showToast("Failed to obtain advertisement, please try again later");
      _loadAd();
      return;
    }
    _onAdHiddenCallback=onAdHiddenCallback;
    AppLovinMAX.showRewardedAd(_rewardId);
  }
}