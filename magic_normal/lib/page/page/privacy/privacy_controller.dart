import 'package:magic_base/base_widget/sm_base_controller.dart';
import 'package:magic_base/utils/sm_export.dart';

class PrivacyController extends SmBaseController{
  late WebViewController controller;
  
  @override
  void onInit() {
    super.onInit();
    controller=WebViewController()
    ..loadRequest(Uri.parse("https://scratchmagic.net/privacy/"));
  }
}