import 'package:magic_b/page/page/home/home/home_page.dart';
import 'package:magic_b/page/page/home/test.dart';
import 'package:magic_b/page/page/play/play_page.dart';
import 'package:magic_base/sm_router/all_routers_name.dart';
import 'package:magic_base/utils/sm_export.dart';
import 'package:magic_b/page/page/play_7/play_7_page.dart';
import 'package:magic_b/page/page/play_8/play_8_page.dart';
import 'package:magic_b/page/page/play_big/play_big_page.dart';
import 'package:magic_b/page/page/play_emoji/play_emoji_page.dart';
import 'package:magic_b/page/page/play_fruit/play_fruit_page.dart';
import 'package:magic_b/page/page/play_tiger/play_tiger_page.dart';
import 'package:magic_b/page/page/privacy/privacy_page.dart';

class SmBRoutersList{
  static final list=[
    GetPage(
          name: AllRoutersName.homePageB,
        page: ()=> HomePage(),
        transition: Transition.fadeIn
    ),
    GetPage(
        name: AllRoutersName.playB,
        page: ()=> PlayPage(),
        transition: Transition.fadeIn
    ),
    // GetPage(
    //     name: AllRoutersName.playFruitB,
    //     page: ()=> PlayFruitPage(),
    //     transition: Transition.fadeIn
    // ),
    // GetPage(
    //     name: AllRoutersName.playBigB,
    //     page: ()=> PlayBigPage(),
    //     transition: Transition.fadeIn
    // ),
    // GetPage(
    //     name: AllRoutersName.playTigerB,
    //     page: ()=> PlayTigerPage(),
    //     transition: Transition.fadeIn
    // ),
    // GetPage(
    //     name: AllRoutersName.play7B,
    //     page: ()=> Play7Page(),
    //     transition: Transition.fadeIn
    // ),
    // GetPage(
    //     name: AllRoutersName.playEmojiB,
    //     page: ()=> PlayEmojiPage(),
    //     transition: Transition.fadeIn
    // ),
    // GetPage(
    //     name: AllRoutersName.play8B,
    //     page: ()=> Play8Page(),
    //     transition: Transition.fadeIn
    // ),
    // GetPage(
    //     name: AllRoutersName.privacyB,
    //     page: ()=> PrivacyPage(),
    //     transition: Transition.fadeIn
    // ),
    GetPage(
        name: AllRoutersName.test,
        page: ()=> Test(),
        transition: Transition.fadeIn
    ),
  ];
}