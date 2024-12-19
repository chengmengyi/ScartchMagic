import 'package:flutter/material.dart';
import 'package:magic_b/page/widget/bubble/bubble_widget_controller.dart';
import 'package:magic_base/base_widget/sm_base_widget.dart';
import 'package:magic_base/base_widget/sm_image_widget.dart';
import 'package:magic_base/base_widget/sm_text_widget.dart';
import 'package:magic_base/utils/sm_export.dart';
import 'package:magic_base/utils/sm_extension.dart';

class BubbleWidget extends SmBaseWidget<BubbleWidgetController>{
  @override
  BubbleWidgetController setController() => BubbleWidgetController();

  @override
  Widget contentWidget() => LayoutBuilder(
    builder: (context,bc){
      smController.width=bc.maxWidth-64.w;
      smController.height=bc.maxHeight-64.h;
      return SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            GetBuilder<BubbleWidgetController>(
              id: "bubble",
              builder: (_)=>Positioned(
                top: smController.currentY,
                left: smController.currentX,
                child: smController.showBubble?
                InkWell(
                  onTap: (){
                    smController.clickBubble();
                  },
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      SmImageWidget(imageName: "bubble",width: 64.w,height: 64.w,),
                      SmTextWidget(
                        text: "\$${smController.addNum}",
                        size: 16.sp,
                        color: "#FFDE26",
                        fontWeight: FontWeight.w700,
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
                ):
                Container(),
              ),
            )
          ],
        ),
      );
    },
  );
}