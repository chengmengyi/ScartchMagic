import 'package:flutter/material.dart';
import 'package:magic_base/base_widget/sm_base_widget.dart';
import 'package:magic_base/base_widget/sm_image_widget.dart';
import 'package:magic_base/sm_router/sm_routers_utils.dart';
import 'package:magic_base/utils/sm_export.dart';
import 'package:magic_normal/page/widget/coins_widget/coins_widget.dart';
import 'package:magic_normal/page/widget/level_widget/level_widget.dart';
import 'package:magic_normal/page/widget/play_top_widget/play_top_controller.dart';

class PlayTopWidget extends SmBaseWidget<PlayTopController>{

  @override
  PlayTopController setController() => PlayTopController();

  @override
  Widget contentWidget() {
    var height = MediaQuery.of(smController.smContext).padding.top;
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("magic_file/magic_image/top_bg.webp",),
          fit: BoxFit.fill,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: height,),
          Row(
            children: [
              SizedBox(width: 12.w,),
              InkWell(
                onTap: (){
                  SmRoutersUtils.instance.offPage();
                },
                child: SmImageWidget(imageName: "icon_home",width: 36.w,height: 36.h,),
              ),
              SizedBox(width: 10.w,),
              CoinsWidget(),
              SizedBox(width: 10.w,),
              LevelWidget(isHome: false,),
            ],
          ),
          SizedBox(height: 14.h,)
        ],
      ),
    );
  }
}