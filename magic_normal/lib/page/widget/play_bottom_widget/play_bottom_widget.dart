import 'package:flutter/material.dart';
import 'package:magic_base/base_widget/sm_base_widget.dart';
import 'package:magic_base/base_widget/sm_image_widget.dart';
import 'package:magic_base/sm_router/sm_routers_utils.dart';
import 'package:magic_base/utils/sm_export.dart';
import 'package:magic_base/utils/voice/voice_utils.dart';
import 'package:magic_normal/page/widget/play_bottom_widget/play_bottom_controller.dart';

class PlayBottomWidget extends SmBaseWidget<PlayBottomController>{
  Function()? revealAll;
  PlayBottomWidget({
    this.revealAll,
});

  @override
  PlayBottomController setController() => PlayBottomController();

  @override
  Widget contentWidget() => SizedBox(
    width: double.infinity,
    height: 80.h,
    child: Stack(
      children: [
        SmImageWidget(imageName: "play_bottom_bg",width: double.infinity,height: 80.h,),
        InkWell(
          onTap: (){
            SmRoutersUtils.instance.offPage();
          },
          child: SmImageWidget(imageName: "more_tickets",width: 68.w,height: 68.w,),
        ),
        Container(
          margin: EdgeInsets.only(left: 78.w,top: 12.h,right: 14.w),
          child: InkWell(
            onTap: (){
              VoiceUtils.instance.playVoiceMp3();
              revealAll?.call();
            },
            child: SmImageWidget(imageName: "bottom_btn",width: double.infinity,height: 52.h,),
          ),
        ),
      ],
    ),
  );
}