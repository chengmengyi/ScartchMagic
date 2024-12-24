import 'package:flutter/material.dart';
import 'package:magic_b/page/widget/dialog/good_comment/good_comment/good_comment_controller.dart';
import 'package:magic_b/page/widget/finger_widget/finger_lottie.dart';
import 'package:magic_base/base_widget/sm_base_dialog.dart';
import 'package:magic_base/base_widget/sm_gradient_text_widget.dart';
import 'package:magic_base/base_widget/sm_image_widget.dart';
import 'package:magic_base/base_widget/sm_text_widget.dart';
import 'package:magic_base/sm_router/sm_routers_utils.dart';
import 'package:magic_base/utils/sm_export.dart';
import 'package:magic_base/utils/sm_extension.dart';

class GoodCommentDialog extends SmBaseDialog<GoodCommentController>{
  Function(int index) call;
  GoodCommentDialog({required this.call});

  @override
  GoodCommentController setController() => GoodCommentController();

  @override
  Widget contentWidget() => Container(
    width: double.infinity,
    height: 348.h,
    margin: EdgeInsets.only(left: 36.w,right: 36.w),
    child: Stack(
      alignment: Alignment.center,
      children: [
        SmImageWidget(imageName: "cash_task1",width: double.infinity,height: 348.h, boxFit: BoxFit.fill,),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SmGradientTextWidget(
              text: "Give us a good review",
              size: 20.sp,
              fontWeight: FontWeight.w700,
              colors: ["#FFF6A9".toSmColor(),"#FFDF51".toSmColor()],
              shadows: [
                Shadow(
                    color: "#8E5602".toSmColor(),
                    blurRadius: 2.w,
                    offset: Offset(0,0.5.w)
                )
              ],
            ),
            SmImageWidget(imageName: "comment2",width: 140.w,height: 140.h,),
            SizedBox(
              height: 44.h,
              child: GetBuilder<GoodCommentController>(
                id: "list",
                builder: (_)=>ListView.builder(
                  itemCount: 5,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context,index)=>Container(
                    margin: EdgeInsets.only(left: 2.w,right: 2.w),
                    child: InkWell(
                      onTap: (){
                        smController.clickStar(index,call);
                      },
                      child: SmImageWidget(imageName: index<=smController.clickIndex?"star_sel":"star_uns",width: 44.w,height: 44.h,),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 8.h,),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SmTextWidget(text: "Complete reviews earn \$5", size: 12.sp, color: "#FFFFFF"),
                SmImageWidget(imageName: "b_coins",width: 20.w,height: 20.w,)
              ],
            ),
            SizedBox(height: 8.h,),
            InkWell(
              onTap: (){
                smController.clickStar(4,call);
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SmImageWidget(imageName: "btn",width: 200.w,height: 44.h,boxFit: BoxFit.fill,),
                  SmTextWidget(
                    text: "Give 5 stars",
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
        ),
        Align(
          alignment: Alignment.topRight,
          child: InkWell(
            onTap: (){
              SmRoutersUtils.instance.offPage();
            },
            child: SmImageWidget(imageName: "close",width: 32.w,height: 32.h,),
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: FingerLottie(),
        )
      ],
    ),
  );
}