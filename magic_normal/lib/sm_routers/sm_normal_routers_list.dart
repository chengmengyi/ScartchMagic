import 'package:magic_base/sm_router/all_routers_name.dart';
import 'package:magic_base/utils/sm_export.dart';
import 'package:magic_normal/page/page/home/home_page.dart';
import 'package:magic_normal/page/page/play_7/play_7_page.dart';
import 'package:magic_normal/page/page/play_8/play_8_page.dart';
import 'package:magic_normal/page/page/play_big/play_big_page.dart';
import 'package:magic_normal/page/page/play_emoji/play_emoji_page.dart';
import 'package:magic_normal/page/page/play_fruit/play_fruit_page.dart';
import 'package:magic_normal/page/page/play_tiger/play_tiger_page.dart';
import 'package:magic_normal/page/page/privacy/privacy_page.dart';

class SmNormalRoutersList{
  static final list=[
    GetPage(
        name: AllRoutersName.homePageA,
        page: ()=> HomePage(),
        transition: Transition.fadeIn
    ),
    GetPage(
        name: AllRoutersName.playFruitA,
        page: ()=> PlayFruitPage(),
        transition: Transition.fadeIn
    ),
    GetPage(
        name: AllRoutersName.playBigA,
        page: ()=> PlayBigPage(),
        transition: Transition.fadeIn
    ),
    GetPage(
        name: AllRoutersName.playTigerA,
        page: ()=> PlayTigerPage(),
        transition: Transition.fadeIn
    ),
    GetPage(
        name: AllRoutersName.play7A,
        page: ()=> Play7Page(),
        transition: Transition.fadeIn
    ),
    GetPage(
        name: AllRoutersName.playEmojiA,
        page: ()=> PlayEmojiPage(),
        transition: Transition.fadeIn
    ),
    GetPage(
        name: AllRoutersName.play8A,
        page: ()=> Play8Page(),
        transition: Transition.fadeIn
    ),
    GetPage(
        name: AllRoutersName.privacyA,
        page: ()=> PrivacyPage(),
        transition: Transition.fadeIn
    ),
  ];
}