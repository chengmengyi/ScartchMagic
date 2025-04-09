import 'package:flutter/material.dart';
import 'package:magic_b/page/widget/btn_widget/btn_widget.dart';
import 'package:magic_b/page/widget/dialog/no_reward/no_reward_controller.dart';
import 'package:magic_base/base_widget/sm_base_dialog.dart';
import 'package:magic_base/base_widget/sm_image_widget.dart';
import 'package:magic_base/utils/sm_export.dart';

class NoRewardDialog extends SmBaseDialog<NoRewardController>{
  Function() dismiss;
  NoRewardDialog({required this.dismiss});

  @override
  NoRewardController setController() => NoRewardController();

  @override
  Widget contentWidget() => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      SmImageWidget(imageName: "no_reward",width: 240.w,height: 180.h,),
      SizedBox(height: 60.h,),
      BtnWidget(
        text: "Play Again",
        onTap: (){
          smController.clickPlayAgain(dismiss);
        },
      ),
    ],
  );
}