import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:magic_b/sm_routers/sm_b_routers_list.dart';
import 'package:magic_b/utils/b_sql/b_sql_utils.dart';
import 'package:magic_b/utils/b_value/b_value_hep.dart';
import 'package:magic_base/sm_router/all_routers_name.dart';
import 'package:magic_base/utils/b_ad/ad_utils.dart';
import 'package:magic_base/utils/check_user/check_user_utils.dart';
import 'package:magic_base/utils/firebase/firebase_utils.dart';
import 'package:magic_base/utils/sm_export.dart';
import 'package:magic_base/utils/tba/tba_utils.dart';
import 'package:magic_normal/sm_routers/sm_normal_routers_list.dart';
import 'package:magic_normal/utils/normal_ad/normal_ad_utils.dart';
import 'package:magic_normal/utils/normal_sql/normal_sql_utils.dart';
import 'package:magic_normal/utils/normal_value/normal_value_hep.dart';
import 'package:scratch_magic/launch_page/launch_page.dart';

void main() {
  _initApp();
  runApp(const SmMyApp());
}

_initApp()async{
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarDividerColor: null,
        statusBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
      )
  );
  await GetStorage.init();
  FirebaseUtils.instance.readFirebaseConf();
  //init a
  NormalValueHep.instance.initValue();
  NormalSqlUtils.instance.queryPlayList();
  NormalAdUtils.instance.initMax();

  //init b
  BValueHep.instance.initValue();
  BSqlUtils.instance.queryPlayList();
  AdUtils.instance.initAd();

  CheckUserUtils.instance.initCheck();

  TbaUtils.instance.install();
}

class SmMyApp extends StatelessWidget {
  const SmMyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 780),
      builder: (context, child) =>_smMaterialApp(),
    );
  }

  _smMaterialApp(){
    List<GetPage<dynamic>> list=[];
    list.add(
        GetPage(
            name: AllRoutersName.launchPage,
            page: ()=> LaunchPage(),
            transition: Transition.fadeIn
        )
    );
    list.addAll(SmNormalRoutersList.list);
    list.addAll(SmBRoutersList.list);
    return GetMaterialApp(
      title: 'ScratchMagic',
      enableLog: true,
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      initialRoute: AllRoutersName.launchPage,
      debugShowCheckedModeBanner: false,
      getPages: list,
      defaultTransition: Transition.rightToLeft,
      builder: (context,widget){
        return Material(
          child: InkWell(
            onTap: () {
              hideKeyboard(context);
            },
            child: MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: widget!,
            ),
          ),
        );
      },
    );
  }

  hideKeyboard(BuildContext context){
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }
}