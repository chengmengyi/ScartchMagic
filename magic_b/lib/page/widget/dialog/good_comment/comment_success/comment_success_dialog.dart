import 'package:flutter/material.dart';
import 'package:magic_b/page/widget/dialog/good_comment/comment_success/comment_success_controller.dart';
import 'package:magic_base/base_widget/sm_base_dialog.dart';
import 'package:magic_base/base_widget/sm_image_widget.dart';
import 'package:magic_base/base_widget/sm_text_widget.dart';
import 'package:magic_base/utils/sm_export.dart';
import 'package:magic_base/utils/sm_extension.dart';

class CommentSuccessDialog extends SmBaseDialog<CommentSuccessController>{

  @override
  CommentSuccessController setController() => CommentSuccessController();

  @override
  Widget contentWidget() => Container(
    width: double.infinity,
    height: 232.h,
    margin: EdgeInsets.only(left: 36.w,right: 36.w),
    child: Stack(
      alignment: Alignment.center,
      children: [
        SmImageWidget(imageName: "comment_success1",width: double.infinity,height: 232.h, boxFit: BoxFit.fill,),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SmImageWidget(imageName: "comment_success2",width: 84.w,height: 84.h,),
            SizedBox(height: 16.h,),
            SmTextWidget(text: "Thanks for your feedback", size: 14.sp, color: "#FFFFFF"),
            SizedBox(height: 16.h,),
            InkWell(
              onTap: (){
                smController.clickOk();
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SmImageWidget(imageName: "btn",width: 200.w,height: 44.h,boxFit: BoxFit.fill,),
                  SmTextWidget(
                    text: "OK",
                    size: 16.sp,
                    color: "#FFFFFF",
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                          color: "#825400".toSmColor(),
                          blurRadius: 2.w,
                          offset: Offset(0,0.5.w)
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        )
      ],
    ),
  );
}