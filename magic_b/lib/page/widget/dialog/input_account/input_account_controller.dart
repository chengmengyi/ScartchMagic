import 'package:flutter/material.dart';
import 'package:magic_base/base_widget/sm_base_controller.dart';
import 'package:magic_base/sm_router/sm_routers_utils.dart';
import 'package:magic_base/utils/sm_extension.dart';
import 'package:magic_base/utils/tba/ad_pos.dart';
import 'package:magic_base/utils/tba/tba_utils.dart';

class InputAccountController extends SmBaseController{
  TextEditingController textEditingController=TextEditingController();

  @override
  void onInit() {
    super.onInit();
    TbaUtils.instance.pointEvent(pointType: PointType.sm_cash_confirm_pop);
  }


  clickCash(Function(String account) dismiss){
    TbaUtils.instance.pointEvent(pointType: PointType.sm_cash_confirm_pop_c);
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