import 'package:flutter/material.dart';
import 'package:magic_base/base_widget/sm_text_widget.dart';

class SmGradientTextWidget extends StatelessWidget{
  String text;
  double size;
  List<Color> colors;
  FontWeight? fontWeight;
  AlignmentGeometry? begin;
  AlignmentGeometry? end;
  List<Shadow>? shadows;
  TextAlign? textAlign;

  SmGradientTextWidget({
    required this.text,
    required this.size,
    required this.colors,
    this.fontWeight,
    this.begin,
    this.end,
    this.shadows,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) => ShaderMask(
    shaderCallback: (rect) {
      return LinearGradient(
        begin: begin??Alignment.topCenter,
        end: end??Alignment.bottomCenter,
        colors: colors,
      ).createShader(rect);
    },
    child: SmTextWidget(text: text, size: size, color: "#FFFFFF",fontWeight: fontWeight,shadows: shadows,textAlign: textAlign,),
  );

}