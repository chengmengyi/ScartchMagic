import 'package:magic_base/base_widget/sm_base_controller.dart';
import 'package:magic_base/sm_router/sm_routers_utils.dart';

class WinDialogController extends SmBaseController{
  Function()? timeOut;
  @override
  void onReady() {
    super.onReady();
    Future.delayed(const Duration(milliseconds: 2000),(){
      SmRoutersUtils.instance.offPage();
      timeOut?.call();
    });
  }
}