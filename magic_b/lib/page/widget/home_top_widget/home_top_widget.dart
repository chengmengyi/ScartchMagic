import 'package:flutter/material.dart';
import 'package:magic_base/base_widget/sm_base_widget.dart';
import 'package:magic_base/base_widget/sm_image_widget.dart';
import 'package:magic_base/sm_router/sm_routers_utils.dart';
import 'package:magic_base/utils/sm_export.dart';
import 'package:magic_b/page/widget/coins_widget/coins_widget.dart';
import 'package:magic_b/page/widget/dialog/set/set_dialog.dart';
import 'package:magic_b/page/widget/home_top_widget/home_top_controller.dart';
import 'package:magic_b/page/widget/level_widget/level_widget.dart';

class HomeTopWidget extends SmBaseWidget<HomeTopController>{
  bool showSetIcon;
  HomeTopWidget({
    required this.showSetIcon,
});

  @override
  HomeTopController setController() => HomeTopController();

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
              CoinsWidget(),
              SizedBox(width: 10.w,),
              LevelWidget(isHome: true,),
              const Spacer(),
              Visibility(
                visible: showSetIcon,
                child: InkWell(
                  onTap: (){
                    SmRoutersUtils.instance.showDialog(widget: SetDialog());
                  },
                  child: SmImageWidget(imageName: "icon_set",width: 36.w,height: 36.h,),
                ),
              ),
              SizedBox(width: 12.w,),
            ],
          ),
          SizedBox(height: 14.h,)
        ],
      ),
    );
  }
}