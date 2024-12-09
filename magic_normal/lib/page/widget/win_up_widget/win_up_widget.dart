import 'package:flutter/material.dart';
import 'package:magic_base/base_widget/sm_base_widget.dart';
import 'package:magic_base/base_widget/sm_gradient_text_widget.dart';
import 'package:magic_base/base_widget/sm_stroke_text_widget.dart';
import 'package:magic_base/base_widget/sm_text_widget.dart';
import 'package:magic_base/utils/sm_export.dart';
import 'package:magic_base/utils/sm_extension.dart';
import 'package:magic_normal/page/widget/win_up_widget/win_up_widget_controller.dart';
import 'package:magic_normal/utils/normal_sql/play_info_bean.dart';
import 'package:magic_normal/utils/normal_value/normal_value_hep.dart';

class WinUpWidget extends SmBaseWidget<WinUpWidgetController>{
  PlayType playType;
  WinUpWidget({
    required this.playType,
  });

  @override
  WinUpWidgetController setController() => WinUpWidgetController();

  @override
  Widget contentWidget() => Stack(
    alignment: Alignment.topCenter,
    children: [
      SmGradientTextWidget(
        text: "${NormalValueHep.instance.getMaxWin(playType.name)}",
        size: 24.sp,
        colors: [
          "#FBCE01".toSmColor(),
          "#F3FF01".toSmColor(),
          "#E67701".toSmColor(),
        ],
        fontWeight: FontWeight.w800,
        shadows: [
          Shadow(
              color: "#2F1C06".toSmColor(),
              blurRadius: 2.w,
              offset: Offset(0,0.5.w)
          )
        ],
      ),
      Container(
        margin: EdgeInsets.only(top: 24.h),
        child: SmTextWidget(
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
      ),
    ],
  );
}