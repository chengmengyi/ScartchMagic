import 'package:flutter/material.dart';
import 'package:magic_base/utils/sm_extension.dart';

class SmTextWidget extends StatelessWidget{
  String text;
  double size;
  String color;
  FontWeight? fontWeight;
  List<Shadow>? shadows;
  double? height;
  TextAlign? textAlign;

  SmTextWidget({
    required this.text,
    required this.size,
    required this.color,
    this.fontWeight,
    this.shadows,
    this.height,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
          color: color.toSmColor(),
          fontSize: size,
          fontWeight: fontWeight,
          shadows: shadows,
          height: height,
          fontFamily: fontWeight==FontWeight.w800||fontWeight==FontWeight.w700||fontWeight==FontWeight.w400?"magic":null
      ),
    );
  }

}