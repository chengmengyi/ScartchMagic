import 'package:magic_base/base_widget/sm_base_controller.dart';
import 'package:magic_base/sm_router/sm_routers_utils.dart';
import 'package:magic_base/utils/tba/ad_pos.dart';
import 'package:magic_base/utils/tba/tba_utils.dart';

class NoMoneyController extends SmBaseController{
  @override
  void onInit() {
    super.onInit();
    TbaUtils.instance.pointEvent(pointType: PointType.sm_cash_not_pop);
  }

  clickEarn(){
    TbaUtils.instance.pointEvent(pointType: PointType.sm_cash_not_pop_c);
    SmRoutersUtils.instance.offPage();
  }
}