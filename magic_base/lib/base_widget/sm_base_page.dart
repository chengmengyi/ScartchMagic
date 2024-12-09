import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:magic_base/base_widget/sm_base_controller.dart';
import 'package:magic_base/base_widget/sm_image_widget.dart';

abstract class SmBasePage<T extends SmBaseController> extends StatelessWidget{
  late T smController;

  @override
  Widget build(BuildContext context) {
    smController=Get.put(setController());
    smController.smContext=context;
    return Scaffold(
      body: Stack(
        children: [
          SmImageWidget(imageName: backgroundName(),width: double.infinity,height: double.infinity,),
          Column(
            children: [
              topTitleWidget()??Container(),
              Expanded(
                child: contentWidget(),
              )
            ],
          )
        ],
      ),
    );
  }

  T setController();

  String backgroundName();

  Widget? topTitleWidget();

  Widget contentWidget();
}