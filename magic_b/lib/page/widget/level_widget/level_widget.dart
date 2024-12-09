import 'dart:async';

import 'package:flutter/material.dart';
import 'package:magic_base/base_widget/sm_base_widget.dart';
import 'package:magic_base/base_widget/sm_image_widget.dart';
import 'package:magic_base/base_widget/sm_text_widget.dart';
import 'package:magic_base/utils/event/event_code.dart';
import 'package:magic_base/utils/event/event_info.dart';
import 'package:magic_base/utils/sm_export.dart';
import 'package:magic_base/utils/sm_extension.dart';
import 'package:magic_b/page/widget/level_widget/level_widget_controller.dart';
import 'package:magic_b/utils/b_sql/b_sql_utils.dart';

class LevelWidget extends StatefulWidget{
  bool isHome;
  LevelWidget({
    required this.isHome,
});

  @override
  State<StatefulWidget> createState() => _LevelWidgetState();
}

class _LevelWidgetState extends State<LevelWidget>{
  var level=0,currentPro=0.0;
  late StreamSubscription<EventInfo>? _ss;

  @override
  void initState() {
    super.initState();
    _ss=eventBus.on<EventInfo>().listen((event) {
      if(event.eventCode==EventCode.updateLevelPro){
        _initLevel();
      }
    });
    Future((){
      _initLevel();
    });
  }

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 120.w,
    height: 36.h,
    child: Stack(
      children: [
        SmImageWidget(imageName: "level_bg",width: double.infinity,height: double.infinity,),
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            margin: EdgeInsets.only(left: 3.h),
            child: ClipRect(
              child: Align(
                alignment: Alignment.centerLeft,
                widthFactor: currentPro,
                child: SmImageWidget(imageName: "level_pro",width: 114.w,height: 30.h,),
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 3.w),
          child: SmImageWidget(imageName: "level_star",width: 36.w,height: 36.h,),
        ),
        Align(
          child: SmTextWidget(
            text: "Lv $level",
            size: 16.sp,
            color: "#FFFFFF",
            fontWeight: FontWeight.w600,
            shadows: [
              Shadow(
                  color: "#000000".toSmColor(),
                  blurRadius: 2.w,
                  offset: Offset(0,0.5.w)
              )
            ],
          ),
        )
      ],
    ),
  );

  _initLevel()async{
    var list = await BSqlUtils.instance.queryPlayList();
    var allPlayedNum=0;
    for (var value in list) {
      allPlayedNum+=(value.playedNum??0);
    }
    level=allPlayedNum~/5;
    if(widget.isHome){
      var pro = allPlayedNum/60;
      if(pro>=1.0){
        currentPro=1.0;
      }else{
        currentPro=pro;
      }
    }else{
      currentPro=(allPlayedNum%5)/5;
    }
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _ss?.cancel();
  }
}

// class LevelWidget extends SmBaseWidget<LevelWidgetController>{
//
//   @override
//   LevelWidgetController setController() => LevelWidgetController();
//
//   @override
//   Widget contentWidget() => SizedBox(
//     width: 120.w,
//     height: 36.h,
//     child: Stack(
//       children: [
//         SmImageWidget(imageName: "level_bg",width: double.infinity,height: double.infinity,),
//         Align(
//           alignment: Alignment.centerLeft,
//           child: Container(
//             margin: EdgeInsets.only(left: 3.h),
//             child: ClipRect(
//               child: Align(
//                 alignment: Alignment.centerLeft,
//                 widthFactor: 0.5,
//                 child: SmImageWidget(imageName: "level_pro",width: 114.w,height: 30.h,),
//               ),
//             ),
//           ),
//         ),
//         Container(
//           margin: EdgeInsets.only(left: 3.w),
//           child: SmImageWidget(imageName: "level_star",width: 36.w,height: 36.h,),
//         ),
//         Align(
//           child: SmTextWidget(
//             text: "Lv 2",
//             size: 16.sp,
//             color: "#FFFFFF",
//             fontWeight: FontWeight.w600,
//             shadows: [
//               Shadow(
//                 color: "#000000".toSmColor(),
//                 blurRadius: 2.w,
//                 offset: Offset(0,0.5.w)
//               )
//             ],
//           ),
//         )
//       ],
//     ),
//   );
// }