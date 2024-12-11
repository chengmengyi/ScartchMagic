import 'package:flutter/material.dart';
import 'package:magic_base/base_widget/sm_image_widget.dart';
import 'package:magic_base/utils/sm_export.dart';
import 'package:magic_base/utils/voice/voice_utils.dart';

class PlayBottomWidget extends StatelessWidget{
  Function()? revealAll;
  PlayBottomWidget({
    this.revealAll,
  });

  @override
  Widget build(BuildContext context) => Container(
    margin: EdgeInsets.only(bottom: 12.h),
    child: InkWell(
      onTap: (){
        VoiceUtils.instance.playVoiceMp3();
        revealAll?.call();
      },
      child: SmImageWidget(imageName: "bottom_btn",height: 52.h,),
    ),
  );
}