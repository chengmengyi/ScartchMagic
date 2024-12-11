import 'dart:math';

import 'package:flutter/material.dart';
import 'package:magic_b/page/page/home/child/wheel/wheel_child_controller.dart';
import 'package:magic_b/page/widget/home_top_widget/home_top_widget.dart';
import 'package:magic_base/base_widget/sm_base_tag_widget.dart';
import 'package:magic_base/base_widget/sm_gradient_text_widget.dart';
import 'package:magic_base/base_widget/sm_image_widget.dart';
import 'package:magic_base/base_widget/sm_text_widget.dart';
import 'package:magic_base/utils/sm_export.dart';
import 'package:magic_base/utils/sm_extension.dart';

class WheelChild extends SmBaseTagWidget<WheelChildController>{
  bool home;
  WheelChild({required this.home});

  @override
  String controllerTag() => "WheelChildController$home";

  @override
  WheelChildController setController() => WheelChildController();

  @override
  Widget contentWidget() => Stack(
    children: [
      SmImageWidget(imageName: "wheel1",width: double.infinity,height: double.infinity,boxFit: BoxFit.fill,),
      Column(
        children: [
          HomeTopWidget(showSetIcon: false,),
          Expanded(child: _contentWidget(),)
        ],
      )
    ],
  );

  _contentWidget()=>Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SmImageWidget(imageName: "wheel2",height: 60.h,),
      Container(
        width: double.infinity,
        margin: EdgeInsets.only(left: 12.w,right: 12.w,top: 30.h,bottom: 20.h),
        child: Stack(
          alignment: Alignment.center,
          children: [
            GetBuilder<WheelChildController>(
              id: "wheel",
              tag: controllerTag(),
              builder: (_)=>Transform.rotate(
                angle: smController.currentWheelAngle*(pi/180),
                child: SmImageWidget(
                  imageName: "wheel3",
                  width: double.infinity,
                  boxFit: BoxFit.fitWidth,
                ),
              ),
            ),
            SmImageWidget(imageName: "wheel4",width: 140.w,height: 140.w,),
          ],
        ),
      ),
      InkWell(
        onTap: (){
          smController.startWheel();
        },
        child: SizedBox(
          width: 240.w,
          height: 60.h,
          child: Stack(
            children: [
              SmImageWidget(imageName: "btn2",width: 240.w,height: 60.h,),
              Align(
                alignment: Alignment.center,
                child: SmTextWidget(text: "Spin", size: 20.sp, color: "#FFFFFF",fontWeight: FontWeight.w700,),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: InkWell(
                  child: Container(
                    width: 40.w,
                    height: 40.w,
                    margin: EdgeInsets.only(left: 10.w),
                    child: Stack(
                      children: [
                        SmImageWidget(imageName: "wheel5",width: 40.w,height: 40.w,),
                        Align(
                          alignment: Alignment.center,
                          child: SmImageWidget(imageName: "wheel6",width: 36.w,height: 36.w,),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              SmImageWidget(imageName: "wheel7",width: 18.w,height: 18.w,),
                              SmTextWidget(text: "x1", size: 12.sp, color: "#FFFFFF"),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      )
    ],
  );
}