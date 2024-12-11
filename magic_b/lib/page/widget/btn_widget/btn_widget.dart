import 'package:flutter/material.dart';
import 'package:magic_base/base_widget/sm_image_widget.dart';
import 'package:magic_base/base_widget/sm_text_widget.dart';
import 'package:magic_base/utils/sm_export.dart';

class BtnWidget extends StatelessWidget{
  String text;
  Function() onTap;
  BtnWidget({
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
        alignment: Alignment.center,
        children: [
          SmImageWidget(imageName: "btn",width: 208.w,height: 56.h,),
          SmTextWidget(text: text, size: 18.sp, color: "#FFFFFF",fontWeight: FontWeight.w700,),
        ],
      ),
    ),
  );
}