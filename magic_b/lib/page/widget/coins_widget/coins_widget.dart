import 'dart:async';

import 'package:flutter/material.dart';
import 'package:magic_base/base_widget/sm_image_widget.dart';
import 'package:magic_base/base_widget/sm_text_widget.dart';
import 'package:magic_base/utils/event/event_code.dart';
import 'package:magic_base/utils/event/event_info.dart';
import 'package:magic_base/utils/sm_export.dart';
import 'package:magic_base/utils/sm_extension.dart';
import 'package:magic_b/utils/b_storage/b_storage_hep.dart';

class CoinsWidget extends StatefulWidget{
  @override
  State<StatefulWidget> createState() =>_CoinsWidgetState();
}

class _CoinsWidgetState extends State<CoinsWidget>{
  late StreamSubscription<EventInfo>? _ss;
  var currentCoins=coins.read();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _ss=eventBus.on<EventInfo>().listen((event) {
      if(event.eventCode==EventCode.updateCoins){
        _startCoinsTimer(event.intValue??0);
      }
    });
  }

  @override
  Widget build(BuildContext context) => Container(
    constraints: BoxConstraints(
      minWidth: 120.w,
    ),
    decoration: const BoxDecoration(
      image: DecorationImage(
        image: AssetImage("magic_file/magic_image/coins_bg.webp",),
        fit: BoxFit.fill,
      ),
    ),
    child: Container(
      margin: EdgeInsets.only(left: 4.w,top: 4.w,bottom: 4.w,right: 24.w),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SmImageWidget(imageName: "b_coins",width: 28.w,height: 28.w,),
          SizedBox(width: 4.w,),
          SmTextWidget(text: currentCoins.format(), size: 16.sp, color: "#FFFFFF",fontWeight: FontWeight.w600,),
        ],
      ),
    ),
  );

  _startCoinsTimer(int add){
    if(null!=_timer||0==add){
      return;
    }
    var d = add~/200;
    var c=0;
    _timer=Timer.periodic(const Duration(milliseconds: 1), (timer) {
      c++;
      currentCoins+=d;
      setState(() {});
      if(c>=200){
        _timer?.cancel();
        _timer=null;
        currentCoins=coins.read();
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _ss?.cancel();
    _timer?.cancel();
  }
}



// class CoinsWidget extends SmBaseWidget<CoinsWidgetController>{
//
//   @override
//   CoinsWidgetController setController() => CoinsWidgetController();
//
//   @override
//   Widget contentWidget() => Container(
//     constraints: BoxConstraints(
//       minWidth: 120.w,
//     ),
//     decoration: const BoxDecoration(
//       image: DecorationImage(
//         image: AssetImage("magic_file/magic_image/coins_bg.webp",),
//         fit: BoxFit.fill,
//       ),
//     ),
//     child: Container(
//       margin: EdgeInsets.only(left: 4.w,top: 4.w,bottom: 4.w,right: 24.w),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           SmImageWidget(imageName: "icon_coins",width: 28.w,height: 28.w,),
//           SizedBox(width: 4.w,),
//           SmTextWidget(text: "0", size: 16.sp, color: "#FFFFFF",fontWeight: FontWeight.w600,),
//         ],
//       ),
//     ),
//   );
// }