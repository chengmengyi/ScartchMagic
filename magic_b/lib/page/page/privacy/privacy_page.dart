import 'package:flutter/material.dart';
import 'package:magic_base/base_widget/sm_base_page.dart';
import 'package:magic_base/base_widget/sm_text_widget.dart';
import 'package:magic_base/sm_router/sm_routers_utils.dart';
import 'package:magic_base/utils/sm_export.dart';
import 'package:magic_base/utils/sm_extension.dart';
import 'package:magic_b/page/page/privacy/privacy_controller.dart';

class PrivacyPage extends SmBasePage<PrivacyController>{
  @override
  String backgroundName() => "launch_bg";

  @override
  PrivacyController setController() => PrivacyController();

  @override
  Widget? topTitleWidget() => null;

  @override
  Widget contentWidget() => Column(
    children: [
      _titleWidget(),
      Expanded(child: WebViewWidget(controller: smController.controller))
    ],
  );

  _titleWidget(){
    var height = MediaQuery.of(smController.smContext).padding.top;
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("magic_file/magic_image/top_bg.webp",),
          fit: BoxFit.fill,
        ),
      ),
      child: Container(
        width: double.infinity,
        height: 50.h,
        margin: EdgeInsets.only(top: height),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: SmTextWidget(
                text: "Privacy Policy",
                size: 16.sp,
                color: "#FFF84D",
                fontWeight: FontWeight.w500,
                shadows: [
                  Shadow(
                      color: "#A5460E".toSmColor(),
                      blurRadius: 2.w,
                      offset: Offset(0,0.5.w)
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: EdgeInsets.only(left: 10.w),
                child: InkWell(
                  onTap: (){
                    SmRoutersUtils.instance.offPage();
                  },
                  child: const Icon(Icons.arrow_back,),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}