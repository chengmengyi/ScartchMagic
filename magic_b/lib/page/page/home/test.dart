import 'package:flutter/material.dart';
import 'package:magic_base/base_widget/sm_text_widget.dart';
import 'package:magic_base/sm_router/all_routers_name.dart';
import 'package:magic_base/sm_router/sm_routers_utils.dart';
import 'package:magic_base/utils/sm_export.dart';

class Test extends StatelessWidget{
  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: InkWell(
        onTap: (){
          SmRoutersUtils.instance.toNextPage(routersName: AllRoutersName.homePageB);
        },
        child: SmTextWidget(text: "点击", size: 20.sp, color: "#000000"),
      ),
    ),
  );
}