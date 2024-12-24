import 'dart:math';

import 'package:flutter/material.dart';
import 'package:magic_b/page/widget/finger_widget/finger_lottie.dart';
import 'package:magic_b/utils/b_value/b_value_hep.dart';
import 'package:magic_b/utils/guide/guide_step.dart';
import 'package:magic_b/utils/guide/guide_utils.dart';
import 'package:magic_base/base_widget/sm_gradient_text_widget.dart';
import 'package:magic_base/base_widget/sm_image_widget.dart';
import 'package:magic_base/base_widget/sm_text_widget.dart';
import 'package:magic_base/utils/sm_export.dart';
import 'package:magic_base/utils/sm_extension.dart';
import 'package:magic_base/utils/tba/ad_pos.dart';
import 'package:magic_base/utils/tba/tba_utils.dart';

class FirstPlayGuideOverlay extends StatelessWidget{
  Offset offset;
  FirstPlayGuideOverlay({
    required this.offset,
  });

  @override
  Widget build(BuildContext context) => Material(
    type: MaterialType.transparency,
    child: InkWell(
      child: LayoutBuilder(
        builder: (c,bc){
          var w = (bc.maxWidth/2)-12.w;
          return Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black.withOpacity(0.6),
            child: Stack(
              children: [
                Positioned(
                  top: offset.dy,
                  left: offset.dx,
                  child: _itemWidget(w),
                ),
                Positioned(
                  top: offset.dy+260.h,
                  left: 136.w,
                  child: FingerLottie(),
                )
              ],
            ),
          );
        },
      ),
    ),
  );

  _itemWidget(w)=>InkWell(
    onTap: (){
      TbaUtils.instance.pointEvent(pointType: PointType.sm_home_guide_c);
      GuideUtils.instance.hideOver();
      GuideUtils.instance.updateGuideStep(GuideStep.showFruitFingerGuide);
    },
    child: SizedBox(
      width: w,
      height: 296.h,
      child: Stack(
        children: [
          SmImageWidget(imageName: "playfruit",width: double.infinity,height: double.infinity,),
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
                            SmImageWidget(imageName: "b_coins",width: 24.w,height: 24.w,),
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
                          text: "\$${BValueHep.instance.getMaxWin("playfruit")}",
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
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SmImageWidget(
                      imageName: "free_btn",
                      width: 128.w,
                      height: 48.h,
                    ),
                    SmTextWidget(
                      text: "Play",
                      size: 18.sp,
                      color: "#FFFFFF",
                      fontWeight: FontWeight.w700,
                      shadows: [
                        Shadow(
                            color: "#0C5500".toSmColor(),
                            blurRadius: 2.w,
                            offset: Offset(0,0.5.w)
                        )
                      ],
                    )
                  ],
                ),
                SizedBox(height: 16.h,),
              ],
            ),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              SmImageWidget(imageName: "icon_flag",width: 50.w,height: 28.h,),
              Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()..rotateZ(8.0 * (pi / 180.0)),
                  child: SmTextWidget(text: "0/10", size: 14.sp, color: "#FFFEF8",fontWeight: FontWeight.w600,)
              ),
            ],
          ),
        ],
      ),
    ),
  );
}