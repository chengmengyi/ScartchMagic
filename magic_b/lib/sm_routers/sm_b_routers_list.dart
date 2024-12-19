import 'package:magic_b/page/page/home/home/home_page.dart';
import 'package:magic_b/page/page/home/test.dart';
import 'package:magic_b/page/page/play/play_page.dart';
import 'package:magic_base/sm_router/all_routers_name.dart';
import 'package:magic_base/utils/sm_export.dart';
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
    GetPage(
        name: AllRoutersName.privacyB,
        page: ()=> PrivacyPage(),
        transition: Transition.fadeIn
    ),
    GetPage(
        name: AllRoutersName.test,
        page: ()=> Test(),
        transition: Transition.fadeIn
    ),
  ];
}