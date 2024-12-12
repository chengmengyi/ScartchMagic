import 'package:flutter/material.dart';
import 'package:magic_base/base_widget/sm_image_widget.dart';
import 'package:magic_base/base_widget/sm_text_widget.dart';
import 'package:magic_base/utils/sm_export.dart';

class WatchVideoBtnWidget extends StatelessWidget{
  String text;
  Function() onTap;
  WatchVideoBtnWidget({
    required this.text,
    required this.onTap,
  });
  
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: (){
      onTap.call();
    },
    child: SizedBox(
      width: 208.w,
      height: 56.h,
      child: Stack(
        children: [
          SmImageWidget(imageName: "btn",width: 208.w,height: 56.h,),
          Align(
            alignment: Alignment.center,
            child: SmTextWidget(text: text, size: 18.sp, color: "#FFFFFF",fontWeight: FontWeight.w700,),
          ),
          Align(
            alignment: Alignment.topRight,
            child: SmImageWidget(imageName: "icon_video",width: 32.w,height: 32.h,),
          )
        ],
      ),
    ),
  );
}