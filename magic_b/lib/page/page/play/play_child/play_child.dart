import 'package:flutter/material.dart';
import 'package:magic_b/page/page/play/play_child/play_child_controller.dart';
import 'package:magic_b/page/page/play/play_child/play_fruit/play_fruit_child.dart';
import 'package:magic_b/page/widget/bubble/bubble_widget.dart';
import 'package:magic_b/page/widget/play_top_widget/play_top_widget.dart';
import 'package:magic_b/utils/b_sql/play_info_bean.dart';
import 'package:magic_base/base_widget/sm_base_widget.dart';
import 'package:magic_base/base_widget/sm_image_widget.dart';
import 'package:magic_base/utils/sm_export.dart';

class PlayChild extends SmBaseWidget<PlayChildController>{
  PlayType  playType;
  PlayChild({
    required this.playType,
});
  @override
  PlayChildController setController() => PlayChildController();

  @override
  Widget contentWidget() => Stack(
    children: [
      SmImageWidget(imageName: "fruit_bg",width: double.infinity,height: double.infinity,),
      Column(
        children: [
          PlayTopWidget(),
          Expanded(child: _getPlayChild()),
        ],
      ),
      _bubbleWidget(),
    ],
  );
  
  Widget _getPlayChild(){
    if(playType==PlayType.playfruit){
      return PlayFruitChild();
    }
    return Container();
  }

  _bubbleWidget()=>GetBuilder<PlayChildController>(
    id: "showBubble",
    builder: (_)=>smController.showBubble?BubbleWidget():Container(),
  );
}