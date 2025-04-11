import 'package:magic_base/base_widget/sm_base_controller.dart';
import 'package:magic_base/sm_router/sm_routers_utils.dart';
import 'package:magic_base/utils/sm_export.dart';

class PrivacyController extends SmBaseController{
  late WebViewController controller;
  var title="";
  
  @override
  void onInit() {
    super.onInit();
    var map = SmRoutersUtils.instance.getParams();
    var url = map["url"];
    title = map["title"];
    controller=WebViewController();
    // controller.loadRequest(Uri.parse("https://sites.google.com/view/scratch-magicwin-pp/home"));
    controller.loadRequest(Uri.parse(url));
  }
}