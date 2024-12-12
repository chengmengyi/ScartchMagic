import 'package:flutter/material.dart';
import 'package:magic_b/page/widget/finger_widget/finger_lottie.dart';
import 'package:magic_b/utils/guide/guide_utils.dart';
import 'package:magic_base/base_widget/sm_image_widget.dart';
import 'package:magic_base/base_widget/sm_text_widget.dart';
import 'package:magic_base/utils/sm_export.dart';
import 'package:magic_base/utils/sm_extension.dart';

class BoxGuideOverlay extends StatelessWidget{
  Offset offset;
  Function() dismiss;
  BoxGuideOverlay({
    required this.offset,
    required this.dismiss,
});

  @override
  Widget build(BuildContext context) => Material(
    type: MaterialType.transparency,
    child: InkWell(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black.withOpacity(0.6),
        child: Stack(
          children: [
            Positioned(
              top: offset.dy,
              left: offset.dx,
              child: _contentWidget(),
            ),
            Positioned(
              top: offset.dy+30.h,
              left: offset.dx+30.w,
              child: InkWell(
                onTap: (){
                  _clickGuide();
                },
                child: FingerLottie(),
              ),
            )
          ],
        ),
      ),
    ),
  );

  _contentWidget()=>Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      _boxWidget(),
      SizedBox(width: 14.w,),
      _descWidget(),
    ],
  );
  
  _boxWidget()=> InkWell(
    onTap: (){
      _clickGuide();
    },
    child: Stack(
      alignment: Alignment.bottomCenter,
      children: [
        SmImageWidget(imageName: "icon_box",width: 60.w,height: 60.w,),
        SizedBox(
          width: 60.w,
          height: 60.w,
          child: CircularProgressIndicator(
            value: 1,
            color: "#FFD631".toSmColor(),
            backgroundColor: "#7E0F03".toSmColor(),
          ),
        ),
        SmTextWidget(
          text: "5/5",
          size: 14.sp,
          color: "#FFD91C",
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(
                color: "#000000".toSmColor(),
                blurRadius: 2.w,
                offset: Offset(0,0.5.w)
            )
          ],
        )
      ],
    ),
  );
  
  _descWidget()=>Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      SmImageWidget(imageName: "jiantou",width: 8.w,height: 16.h,),
      Container(
        width: 200.w,
        padding: EdgeInsets.all(6.w),
        decoration: BoxDecoration(
          color: "#FFFFFF".toSmColor().withOpacity(0.8),
          borderRadius: BorderRadius.circular(8.w),
        ),
        child: SmTextWidget(text: "Open a treasure chest every 5 scratches", size: 14.sp, color: "#000000"),
      )
    ],
  );

  _clickGuide(){
    GuideUtils.instance.hideOver();
    dismiss.call();
  }
}