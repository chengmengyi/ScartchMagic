import 'package:flutter/material.dart';
import 'package:magic_base/base_widget/sm_base_dialog.dart';
import 'package:magic_base/base_widget/sm_image_widget.dart';
import 'package:magic_base/base_widget/sm_text_widget.dart';
import 'package:magic_base/sm_router/all_routers_name.dart';
import 'package:magic_base/sm_router/sm_routers_utils.dart';
import 'package:magic_base/utils/sm_export.dart';
import 'package:magic_base/utils/sm_extension.dart';
import 'package:magic_base/utils/voice/voice_utils.dart';
import 'package:magic_b/page/widget/dialog/set/set_controller.dart';

class SetDialog extends SmBaseDialog<SetController>{
  @override
  SetController setController() => SetController();

  @override
  Widget contentWidget() => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: double.infinity,
        height: 264.h,
        margin: EdgeInsets.only(left: 48.w,right: 48.w),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            SmImageWidget(imageName: "set",width: double.infinity,height: double.infinity,boxFit: BoxFit.fill,),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _voiceWidget(),
                SizedBox(height: 22.h,),
                _lineWidget(),
                _privacyWidget(),
                _lineWidget(),
                _contactWidget(),
              ],
            )
          ],
        ),
      ),
      SizedBox(height: 20.h,),
      InkWell(
        onTap: (){
          SmRoutersUtils.instance.offPage();
        },
        child: const Icon(Icons.close,color: Colors.white,),
      )
    ],
  );
  
  _voiceWidget()=>Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      InkWell(
        onTap: (){
          smController.playVoiceMp3();
        },
        child: GetBuilder<SetController>(
          id: "voice",
          builder: (_)=>SmImageWidget(imageName: playVoice.read()?"set2":"set4",width: 60.w,height: 60.w,),
        ),
      ),
      SizedBox(width: 40.w,),
      InkWell(
        onTap: (){
          smController.playBgMp3();
        },
        child: GetBuilder<SetController>(
          id: "bg",
          builder: (_)=>SmImageWidget(imageName: playBg.read()?"set3":"set5",width: 60.w,height: 60.w,),
        ),
      ),
    ],
  );

  _contactWidget()=>InkWell(
    onTap: (){
      smController.toEmail();
    },
    child: Container(
      width: double.infinity,
      height: 56.h,
      alignment: Alignment.center,
      child: SmTextWidget(
        text: "Contact Us",
        size: 16.sp,
        color: "#FFF84D",
        fontWeight: FontWeight.w500,
        shadows: [
          Shadow(
              color: "#A5460E".toSmColor(),
              blurRadius: 2.w,
              offset: Offset(0,0.5.w)
          )
        ],
      ),
    ),
  );

  _privacyWidget()=>InkWell(
    onTap: (){
      smController.toPrivacy();
    },
    child: Container(
      width: double.infinity,
      height: 56.h,
      alignment: Alignment.center,
      child: SmTextWidget(
        text: "Privacy Policy",
        size: 16.sp,
        color: "#FFF84D",
        fontWeight: FontWeight.w500,
        shadows: [
          Shadow(
              color: "#A5460E".toSmColor(),
              blurRadius: 2.w,
              offset: Offset(0,0.5.w)
          )
        ],
      ),
    ),
  );

  _lineWidget()=>Container(
    width: double.infinity,
    height: 0.5.h,
    color: "#9C444E".toSmColor(),
    margin: EdgeInsets.only(left: 24.w,right: 24.w),
  );
}