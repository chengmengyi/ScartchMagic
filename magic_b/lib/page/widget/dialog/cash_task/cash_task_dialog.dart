import 'package:flutter/material.dart';
import 'package:magic_b/page/widget/dialog/cash_task/cash_task_controller.dart';
import 'package:magic_b/utils/cash_task/cash_list_bean.dart';
import 'package:magic_base/base_widget/sm_base_dialog.dart';
import 'package:magic_base/base_widget/sm_gradient_text_widget.dart';
import 'package:magic_base/base_widget/sm_image_widget.dart';
import 'package:magic_base/base_widget/sm_text_widget.dart';
import 'package:magic_base/sm_router/sm_routers_utils.dart';
import 'package:magic_base/utils/sm_export.dart';
import 'package:magic_base/utils/sm_extension.dart';

class CashTaskDialog extends SmBaseDialog<CashTaskController>{
  List<CashTaskBean> list;
  bool fromHome;
  CashTaskDialog({
    required this.list,
    required this.fromHome,
  });

  @override
  CashTaskController setController() => CashTaskController();

  @override
  Widget contentWidget() => Container(
    width: double.infinity,
    height: 320.h,
    margin: EdgeInsets.only(left: 36.w,right: 36.w),
    child: Stack(
      alignment: Alignment.center,
      children: [
        SmImageWidget(imageName: "cash_task1",width: double.infinity,height: 320.h, boxFit: BoxFit.fill,),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SmGradientTextWidget(
              text: "Only one step left to\nspeed up withdrawal",
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
            SizedBox(height: 10.h,),
            SmImageWidget(imageName: "cash_task_card",width: 100.w,height: 100.w,),
            SizedBox(height: 10.h,),
            SmTextWidget(text: "${smController.getDescStr(list.first)}:", size: 12.sp, color: "#FFFFFF"),
            SmTextWidget(text: "(${smController.getProStr(list)})", size: 14.sp, color: "#FFE646"),
            SizedBox(height: 10.h,),
            InkWell(
              onTap: (){
                smController.clickGo(fromHome,list.first);
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SmImageWidget(imageName: "btn3",width: 200.w,height: 36.h,boxFit: BoxFit.fill,),
                  SmTextWidget(
                    text: "Go(${smController.getProStr(list)})",
                    size: 16.sp,
                    color: "#FFFFFF",
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
      ],
    ),
  );
}