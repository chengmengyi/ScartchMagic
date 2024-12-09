import 'package:flutter/material.dart';

class SmImageWidget extends StatelessWidget{
  String imageName;
  double? width;
  double? height;
  BoxFit? boxFit;
  SmImageWidget({
    required this.imageName,
    this.width,
    this.height,
    this.boxFit,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset("magic_file/magic_image/$imageName.webp",width: width,height: height,fit: boxFit??BoxFit.fill,);
  }
}