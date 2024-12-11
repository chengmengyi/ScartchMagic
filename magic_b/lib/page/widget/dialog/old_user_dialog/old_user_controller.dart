import 'package:magic_b/utils/guide/guide_step.dart';
import 'package:magic_b/utils/guide/guide_utils.dart';
import 'package:magic_base/base_widget/sm_base_controller.dart';
import 'package:magic_base/sm_router/sm_routers_utils.dart';

class OldUserController extends SmBaseController{

  clickClose(){
    SmRoutersUtils.instance.offPage();
    GuideUtils.instance.updateOldStep(OldGuideStep.showSingleRewardDialog);
  }

  clickSpin(){
    SmRoutersUtils.instance.offPage();
    GuideUtils.instance.updateOldStep(OldGuideStep.showWheelTab);
  }
}