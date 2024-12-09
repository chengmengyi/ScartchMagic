import 'package:flutter/material.dart';
import 'package:magic_b/page/page/home/home/home_bottom_bean.dart';
import 'package:magic_b/page/page/home/home/home_controller.dart';
import 'package:magic_base/base_widget/sm_b_base_page.dart';
import 'package:magic_base/base_widget/sm_gradient_text_widget.dart';
import 'package:magic_base/base_widget/sm_image_widget.dart';
import 'package:magic_base/base_widget/sm_text_widget.dart';
import 'package:magic_base/utils/sm_export.dart';
import 'package:magic_base/utils/sm_extension.dart';

class HomePage extends SmBaseBPage<HomeController>{
  @override
  HomeController setController() => HomeController();

  @override
  Widget contentWidget() => GetBuilder<HomeController>(
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
  );

  _bottomWidget()=>SizedBox(
    width: double.infinity,
    height: 80.h,
    child: Stack(
      children: [
        SmImageWidget(imageName: "b_bottom_bg",width: double.infinity,height: double.infinity,boxFit: BoxFit.fill,),
        StaggeredGridView.countBuilder(
          padding: const EdgeInsets.all(0),
          itemCount: smController.bottomList.length,
          shrinkWrap: true,
          crossAxisCount: 3,
          mainAxisSpacing: 0,
          crossAxisSpacing: 0,
          itemBuilder: (context,index)=>_bottomItemWidget(index,smController.bottomList[index]),
          staggeredTileBuilder: (int index) => const StaggeredTile.fit(1),
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
          SmImageWidget(imageName: index==smController.tabIndex?bean.selIcon:bean.unsIcon,width: 56.w,height: 56.h,),
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
}