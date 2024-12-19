import 'package:flutter/material.dart';
import 'package:magic_base/base_widget/sm_base_controller.dart';
import 'package:magic_base/sm_router/sm_routers_utils.dart';
import 'package:magic_base/utils/sm_extension.dart';

class InputAccountController extends SmBaseController{
  TextEditingController textEditingController=TextEditingController();

  clickCash(Function(String account) dismiss){
    var s = textEditingController.text.toString().trim();
    if(s.isEmpty){
      showToast("Please input your account");
      return;
    }
    SmRoutersUtils.instance.offPage();
    dismiss.call(s);
  }

  @override
  void onClose() {
    super.onClose();
    textEditingController.dispose();
  }
}