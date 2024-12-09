import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

extension String2Color on String{
  Color toSmColor(){
    var hexStr = replaceAll("#", "");
    return Color(int.parse(hexStr, radix: 16)).withAlpha(255);
  }
}

extension StringBase64 on String{
  String base64()=>const Utf8Decoder().convert(base64Decode(this));
}

String formatDuration(int milliseconds) {
  var duration = Duration(milliseconds: milliseconds);
  var hours = duration.inHours;
  var minutes = duration.inMinutes % 60;
  var seconds = duration.inSeconds % 60;
  return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
}

extension RandomList on List{
  random()=> this[Random().nextInt(length)];
}

extension RandomMap on Map{
  List<int> random()=> this[Random().nextInt(length)];
}


showToast(String text){
  if(text.isEmpty){
    return;
  }
  Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black45,
      textColor: Colors.white,
      fontSize: 16
  );
}

extension NumberFor on int{
  String format()=>NumberFormat.decimalPattern().format(this);
}

