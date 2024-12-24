import 'package:flutter/material.dart';
import 'package:magic_base/utils/sm_export.dart';

class FingerLottie extends StatelessWidget{
  double? width;
  double? height;
  FingerLottie({
    this.width,
    this.height,
});
  @override
  Widget build(BuildContext context) => Lottie.asset("magic_file/magic_lottie/finger.json",width: width??72.w,height: height??72.h);
  
}