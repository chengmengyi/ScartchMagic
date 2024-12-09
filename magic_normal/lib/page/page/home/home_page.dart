import 'dart:math';

import 'package:flutter/material.dart';
import 'package:magic_base/base_widget/sm_base_page.dart';
import 'package:magic_base/base_widget/sm_gradient_text_widget.dart';
import 'package:magic_base/base_widget/sm_image_widget.dart';
import 'package:magic_base/base_widget/sm_sector_painter.dart';
import 'package:magic_base/base_widget/sm_text_widget.dart';
import 'package:magic_base/utils/sm_export.dart';
import 'package:magic_base/utils/sm_extension.dart';
import 'package:magic_normal/page/page/home/home_controller.dart';
import 'package:magic_normal/page/widget/home_top_widget/home_top_widget.dart';
import 'package:magic_normal/utils/normal_sql/play_info_bean.dart';

class HomePage extends SmBasePage<HomeController>{
  @override
  String backgroundName() => "launch_bg";

  @override
  HomeController setController() => HomeController();

  @override
  Widget? topTitleWidget() => InkWell(
    onTap: (){
      smController.test();
    },
    child: HomeTopWidget(),
  );

  @override
  Widget contentWidget() => Container(
    margin: EdgeInsets.only(left: 12.w,right: 12.w,top: 16.h),
    child: GetBuilder<HomeController>(
      id: "list",
      builder: (_)=>StaggeredGridView.countBuilder(
        padding: const EdgeInsets.all(0),
        itemCount: smController.playList.length,
        shrinkWrap: true,
        crossAxisCount: 2,
        mainAxisSpacing: 10.h,
        crossAxisSpacing: 10.w,
        itemBuilder: (context,index)=>_itemWidget(smController.playList[index],index),
        staggeredTileBuilder: (int index) => const StaggeredTile.fit(1),
      ),
    ),
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
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SmImageWidget(
                      imageName: bean.unlock==1?"free_btn":"lock",
                      width: 128.w,
                      height: 48.h,
                    ),
                    bean.unlock==1?
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
                    ):
                    SmTextWidget(
                      text: "Level ${index+1}",
                      size: 16.sp,
                      color: "#FFFFFF",
                      fontWeight: FontWeight.w700,
                    ),
                  ],
                ),
                SizedBox(height: 16.h,),
              ],
            ),
          ),
          (bean.time??0)>0?
          // true?
          Container(
            width: double.infinity,
            height: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.w),
              color: "#000000".toSmColor().withOpacity(0.6),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 50.w,
                      height: 50.w,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50.w),
                          border: Border.all(
                            width: 1.w,
                            color: "#FFFFFF".toSmColor(),
                          )
                      ),
                    ),
                    CustomPaint(
                        size: Size(100.w, 100.w),
                        painter: SmSectorPainter(
                          startAngle: -90,
                          endAngle: smController.getRefreshTimerEndAngle(bean),
                          color: "#FFFFFF".toSmColor(),
                        )
                    ),
                  ],
                ),
                SmTextWidget(text: "Refresh in", size: 18.sp, color: "#FFFFFF",fontWeight: FontWeight.w600,),
                SmTextWidget(text: smController.getRefreshTimerStr(bean), size: 18.sp, color: "#FFFFFF",fontWeight: FontWeight.w600,),
              ],
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
                  child: SmTextWidget(text: "${(bean.currentPro??0)>=10?10:bean.currentPro??0}/10", size: 14.sp, color: "#FFFEF8",fontWeight: FontWeight.w600,)
              ),
            ],
          ),
        ],
      ),
    ),
  );
}