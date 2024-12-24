import 'package:flutter/material.dart';
import 'package:magic_b/page/page/home/home/home_bottom_bean.dart';
import 'package:magic_b/page/page/play/play_controller.dart';
import 'package:magic_b/page/widget/finger_widget/finger_lottie.dart';
import 'package:magic_base/base_widget/sm_b_base_page.dart';
import 'package:magic_base/base_widget/sm_gradient_text_widget.dart';
import 'package:magic_base/base_widget/sm_image_widget.dart';
import 'package:magic_base/utils/sm_export.dart';
import 'package:magic_base/utils/sm_extension.dart';

class PlayPage extends SmBaseBPage<PlayController>{

  @override
  PlayController setController() => PlayController();

  @override
  Widget contentWidget() => Stack(
    children: [
      GetBuilder<PlayController>(
        id: "page",
        builder: (_)=>Column(
          children: [
            Expanded(
              child: IndexedStack(
                index: smController.tabIndex,
                children: smController.pageList,
              ),
            ),
            _bottomWidget(),
          ],
        ),
      ),
      _cashFingerGuideWidget(),
      _moneyLottieWidget(),
      _wheelFingerGuideWidget(),
    ],
  );

  _bottomWidget()=>SizedBox(
    width: double.infinity,
    height: 80.h,
    child: Stack(
      children: [
        SmImageWidget(imageName: "b_bottom_bg",width: double.infinity,height: double.infinity,boxFit: BoxFit.fill,),
        GetBuilder<PlayController>(
          id: "bottom",
          builder: (_)=>StaggeredGridView.countBuilder(
            padding: const EdgeInsets.all(0),
            itemCount: smController.bottomList.length,
            shrinkWrap: true,
            crossAxisCount: 3,
            mainAxisSpacing: 0,
            crossAxisSpacing: 0,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context,index)=>_bottomItemWidget(index,smController.bottomList[index]),
            staggeredTileBuilder: (int index) => const StaggeredTile.fit(1),
          ),
        ),
      ],
    ),
  );

  _bottomItemWidget(index,HomeBottomBean bean)=>InkWell(
    onTap: (){
      smController.clickTab(index);
    },
    child: Container(
      width: double.infinity,
      height: 80.h,
      alignment: Alignment.topCenter ,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              SmImageWidget(
                imageName: index==1&&smController.wheelChance<=0?bean.unsIcon:bean.selIcon,
                width: 56.w,
                height: 56.h,
              ),
              Visibility(
                visible: index==1&&smController.wheelChance==0,
                child: SmImageWidget(imageName: "icon_luck",width: 22.w,height: 22.h,),
              ),
            ],
          ),
          Container(
              margin: EdgeInsets.only(top: 50.h),
              child: SmGradientTextWidget(
                text: bean.text,
                size: 16.sp,
                fontWeight: FontWeight.w700,
                colors: ["#FFFFFF".toSmColor(),"#FFEA4A".toSmColor(),],
                shadows: [
                  Shadow(
                      color: "#502C12".toSmColor(),
                      blurRadius: 2.w,
                      offset: Offset(0,0.5.w)
                  )
                ],
              )
          ),
        ],
      ),
    ),
  );

  _cashFingerGuideWidget()=>GetBuilder<PlayController>(
    id: "cashFingerGuide",
    builder: (_)=>Positioned(
      right: 0,
      bottom: 0,
      child: Offstage(
        offstage: !smController.showCashFingerGuide,
        child: InkWell(
          onTap: (){
            smController.clickTab(2);
          },
          child: FingerLottie(),
        ),
      ),
    ),
  );

  _moneyLottieWidget()=>GetBuilder<PlayController>(
    id: "money_lottie",
    builder: (_)=>Visibility(
      visible: smController.showMoneyLottie,
      child: Container(
        margin: EdgeInsets.only(left: 20.w),
        child: Lottie.asset("magic_file/magic_lottie/money.zip",repeat: false),
      ),
    ),
  );

  _wheelFingerGuideWidget()=>GetBuilder<PlayController>(
    id: "wheelFingerGuide",
    builder: (_)=>Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: EdgeInsets.only(left: 60.w),
        child: Visibility(
          visible: smController.showWheelFinger&&smController.tabIndex!=1,
          child: InkWell(
            onTap: (){
              smController.clickTab(1);
            },
            child: FingerLottie(
              width: 60.w,
              height: 60.w,
            ),
          ),
        ),
      ),
    ),
  );
}