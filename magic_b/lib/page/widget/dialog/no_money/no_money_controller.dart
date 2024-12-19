import 'package:magic_base/base_widget/sm_base_controller.dart';
import 'package:magic_base/sm_router/sm_routers_utils.dart';

class NoMoneyController extends SmBaseController{

  clickEarn(){
    SmRoutersUtils.instance.offPage();
  }
}