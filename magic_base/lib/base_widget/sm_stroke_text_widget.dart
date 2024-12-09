
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SmStrokeTextWidget extends StatelessWidget{
  String text;
  double fontSize;
  Color textColor;
  Color strokeColor;
  double? strokeWidth;
  FontWeight? fontWeight;
  TextDecoration? decoration;
  Color? decorationColor;

  SmStrokeTextWidget({
    required this.text,
    required this.fontSize,
    required this.textColor,
    required this.strokeColor,
    this.strokeWidth,
    this.fontWeight,
    this.decoration,
    this.decorationColor,
  });


  @override
  Widget build(BuildContext context) => Stack(
    alignment: Alignment.center,
    children: [
      Text(
        text,
        style: TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight??FontWeight.bold,
            fontFamily: fontWeight==FontWeight.w800||fontWeight==FontWeight.w700||fontWeight==FontWeight.w400?"scratchmagic":null,
            decoration: decoration,
            decorationColor: decorationColor,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = strokeWidth??1.w
              ..color = strokeColor
        ),
      ),
      Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: fontSize,
          fontWeight: fontWeight??FontWeight.bold,
          fontFamily: fontWeight==FontWeight.w800||fontWeight==FontWeight.w700||fontWeight==FontWeight.w400?"scratchmagic":null,
        ),
      ),
    ],
  );
}

