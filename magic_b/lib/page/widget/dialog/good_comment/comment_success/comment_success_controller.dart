import 'package:magic_b/utils/info_hep.dart';
import 'package:magic_base/base_widget/sm_base_controller.dart';
import 'package:magic_base/sm_router/sm_routers_utils.dart';

class CommentSuccessController extends SmBaseController{
  clickOk(){
    SmRoutersUtils.instance.offPage();
    InfoHep.instance.updateCoins(5);
  }
}