import 'package:flutter/material.dart';
import 'package:magic_base/base_widget/sm_base_dialog.dart';
import 'package:magic_base/base_widget/sm_gradient_text_widget.dart';
import 'package:magic_base/base_widget/sm_image_widget.dart';
import 'package:magic_base/base_widget/sm_text_widget.dart';
import 'package:magic_base/sm_router/sm_routers_utils.dart';
import 'package:magic_base/utils/sm_export.dart';
import 'package:magic_base/utils/sm_extension.dart';
import 'package:magic_normal/page/widget/dialog/unlock_dialog/unlock_dialog_controller.dart';
import 'package:magic_normal/utils/normal_sql/play_info_bean.dart';

class UnlockDialog extends SmBaseDialog<UnlockDialogController>{
  PlayInfoBean bean;
  String playType;
  UnlockDialog({required this.bean,required this.playType});

  @override
  UnlockDialogController setController() => UnlockDialogController();

  @override
  Widget contentWidget() => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      InkWell(
        onTap: (){
          SmRoutersUtils.instance.offPage();
        },
        child: SmImageWidget(imageName: "unlock1",width: 180.w,height: 64.h,),
      ),
      SizedBox(height: 28.h,),
      _itemWidget(),
      SizedBox(height: 28.h,),
      _btnWidget(),
    ],
  );

  _itemWidget()=>SizedBox(
    width: 164.w,
    height: 296.h,
    child: Stack(
      children: [
        SmImageWidget(imageName: bean.type??"",width: double.infinity,height: double.infinity,),
        Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  SmImageWidget(imageName: "up_bg",width:132.w,height: 70.h,),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SmImageWidget(imageName: "icon_coins",width: 24.w,height: 24.w,),
                          SizedBox(width: 4.w,),
                          SmTextWidget(
                            text: "Win Up To",
                            size: 14.sp,
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
                        ],
                      ),
                      SmGradientTextWidget(
                        text: "${bean.maxWin??0}",
                        size: 24.sp,
                        colors: [
                          "#FBCE01".toSmColor(),
                          "#F3FF01".toSmColor(),
                          "#E67701".toSmColor(),
                        ],
                        fontWeight: FontWeight.w800,
                      )
                    ],
                  )
                ],
              ),
              SizedBox(height: 70.h,),
            ],
          ),
        ),
      ],
    ),
  );

  _btnWidget()=>Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      InkWell(
        onTap: (){
          smController.watchAdUnlock(playType);
        },
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            SmImageWidget(imageName: "unlock2",width: 200.w,height: 48.h,),
            SmImageWidget(imageName: "unlock3",width: 32.w,height: 32.h,),
          ],
        ),
      ),
      SizedBox(height: 8.h,),
      InkWell(
        onTap: (){
          smController.spendMoneyUnlock(playType);
        },
        child: SmImageWidget(imageName: "unlock4",width: 200.w,height: 48.h,),
      ),
    ],
  );
}