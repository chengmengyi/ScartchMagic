import 'package:applovin_max/applovin_max.dart';
import 'package:magic_base/utils/b_ad/max_ad_bean.dart';

class ShowAdResultListener{
  final Function(MaxAd ad,MaxAdBean? maxAdBean) onAdDisplayedCallback;
  final Function(MaxAd ad) onAdHiddenCallback;
  final Function(MaxAd ad, MaxError error) onAdDisplayFailedCallback;
  ShowAdResultListener({
    required this.onAdDisplayedCallback,
    required this.onAdHiddenCallback,
    required this.onAdDisplayFailedCallback,
  });
}