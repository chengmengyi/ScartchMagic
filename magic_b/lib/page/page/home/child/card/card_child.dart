import 'dart:math';

import 'package:flutter/material.dart';
import 'package:magic_b/page/page/home/child/card/card_child_controller.dart';
import 'package:magic_b/page/widget/finger_widget/finger_lottie.dart';
import 'package:magic_b/page/widget/home_top_widget/home_top_widget.dart';
import 'package:magic_b/utils/b_sql/play_info_bean.dart';
import 'package:magic_base/base_widget/sm_base_tag_widget.dart';
import 'package:magic_base/base_widget/sm_gradient_text_widget.dart';
import 'package:magic_base/base_widget/sm_image_widget.dart';
import 'package:magic_base/base_widget/sm_sector_painter.dart';
import 'package:magic_base/base_widget/sm_text_widget.dart';
import 'package:magic_base/utils/sm_export.dart';
import 'package:magic_base/utils/sm_extension.dart';

class CardChild extends SmBaseTagWidget<CardChildController>{

  @override
  String controllerTag() => "CardChildController";

  @override
  CardChildController setController() => CardChildController();

  @override
  Widget contentWidget() => Stack(
    children: [
      SmImageWidget(imageName: "launch_bg",width: double.infinity,height: double.infinity,boxFit: BoxFit.fill,),
      Column(
        children: [
          InkWell(
            onTap: (){
              smController.test();
            },
            child: HomeTopWidget(showSetIcon: true,),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 12.w,right: 12.w,top: 16.h),
              child: GetBuilder<CardChildController>(
                id: "list",
                tag: controllerTag(),
                builder: (_)=>StaggeredGridView.countBuilder(
                  key: smController.playListGlobal,
                  padding: const EdgeInsets.all(0),
                  itemCount: smController.playList.length,
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  mainAxisSpacing: 10.h,
                  crossAxisSpacing: 10.w,
                  controller: smController.scrollController,
                  itemBuilder: (context,index)=>_itemWidget(smController.playList[index],index),
                  staggeredTileBuilder: (int index) => const StaggeredTile.fit(1),
                ),
              ),
            ),
          )
        ],
      ),
    ],
  );

  _itemWidget(PlayInfoBean bean,index)=>InkWell(
    onTap: (){
      smController.clickItem(bean);
    },
    child: SizedBox(
      width: double.infinity,
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
                          text: "\$${bean.maxWin??0}",
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
          (bean.secondsNum??0)>0?
          Container(
            width: double.infinity,
            height: 28.h,
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: 40.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.w),
              color: "#000000".toSmColor().withOpacity(0.8),
            ),
            child: RichText(
              //The next card 180 second
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "The next card ",
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: "#FFFFFF".toSmColor(),
                    )
                  ),
                  TextSpan(
                      text: smController.getRefreshTimerStr(bean),
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: "#F3FC01".toSmColor(),
                      )
                  ),
                  TextSpan(
                      text: " second",
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: "#FFFFFF".toSmColor(),
                      )
                  ),
                ]
              ),
            ),
          ):
          Container(),
          Stack(
            alignment: Alignment.center,
            children: [
              SmImageWidget(imageName: "icon_flag",width: 50.w,height: 28.h,),
              Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()..rotateZ(8.0 * (pi / 180.0)),
                  child: SmTextWidget(text: "${bean.hasNum}/10", size: 14.sp, color: "#FFFEF8",fontWeight: FontWeight.w600,)
              ),
            ],
          ),
          Align(
            alignment: Alignment.center,
            child: Visibility(
              visible: index==smController.fingerIndex,
              child: FingerLottie(),
            ),
          )
        ],
      ),
    ),
  );
}