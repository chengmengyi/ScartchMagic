import 'package:flutter/material.dart';
import 'package:magic_b/page/widget/watch_video_btn_widget/watch_video_btn_widget.dart';
import 'package:magic_base/base_widget/sm_base_dialog.dart';
import 'package:magic_base/base_widget/sm_gradient_text_widget.dart';
import 'package:magic_base/base_widget/sm_image_widget.dart';
import 'package:magic_base/base_widget/sm_text_widget.dart';
import 'package:magic_base/sm_router/sm_routers_utils.dart';
import 'package:magic_base/utils/sm_export.dart';
import 'package:magic_base/utils/sm_extension.dart';
import 'package:magic_b/page/widget/dialog/up_level_dialog/up_level_dialog_controller.dart';

class UpLevelDialog extends SmBaseDialog<UpLevelDialogController>{
  int addNum;
  int level;
  Function() call;
  UpLevelDialog({
    required this.addNum,
    required this.level,
    required this.call,
  });

  @override
  UpLevelDialogController setController() => UpLevelDialogController();

  @override
  Widget contentWidget() => Stack(
    alignment: Alignment.topCenter,
    children: [
      _contentWidget(),
      _topLevelWidget(),
    ],
  );

  _topLevelWidget()=>Stack(
    alignment: Alignment.topCenter,
    children: [
      SmImageWidget(imageName: "level1",width: 280.w,height: 155.h,),
      Container(
        margin: EdgeInsets.only(top: 22.h),
        child: SmGradientTextWidget(
          text: "$level",
          size: 60.sp,
          fontWeight: FontWeight.w800,
          colors: ["#FFA43F".toSmColor(),"#FBF35A".toSmColor(),"#F68D1A".toSmColor()],
        ),
      )
    ],
  );
  
  _contentWidget()=>Container(
    margin: EdgeInsets.only(top: 123.h),
    child: Stack(
      alignment: Alignment.bottomCenter,
      children: [
        SmImageWidget(imageName: "level2",width: 288.w,height: 275.h,),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _moneyWidget(),
            SizedBox(height: 20.h,),
            WatchVideoBtnWidget(
              text: "Claim \$${addNum*2}",
              onTap: (){
                smController.clickDouble(addNum,call);
              },
            ),
            SizedBox(height: 20.h,),
            InkWell(
              onTap: (){
                smController.clickSingle(addNum,call);
              },
              child: SmTextWidget(text: "Continue", size: 14.sp, color: "#FFFFFF",fontWeight: FontWeight.w700,),
            ),
            SizedBox(height: 20.h,),
          ],
        )
      ],
    ),
  );
  
  _moneyWidget()=>Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SmImageWidget(imageName: "b_coins",width: 60.w,height: 60.w,),
          SmTextWidget(text: "\$$addNum", size: 20.sp, color: "#FFE646",fontWeight: FontWeight.w700,),
        ],
      ),
      SizedBox(width: 20.w,),
      SmImageWidget(imageName: "level3",width: 28.w,height: 28.w,),
      SizedBox(width: 20.w,),
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SmImageWidget(imageName: "level4",width: 100.w,height: 60.w,),
          SmTextWidget(text: "\$${addNum*2}", size: 20.sp, color: "#FFE646",fontWeight: FontWeight.w700,),
        ],
      ),
    ],
  );
}