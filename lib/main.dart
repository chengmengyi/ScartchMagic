import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:magic_base/sm_router/all_routers_name.dart';
import 'package:magic_base/utils/sm_export.dart';
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
  NormalValueHep.instance.initValue();
  NormalSqlUtils.instance.queryPlayList();
  NormalAdUtils.instance.initMax();
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
    return GetMaterialApp(
      title: 'ScratchMagic',
      enableLog: true,
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      initialRoute: AllRoutersName.launchPage,
      debugShowCheckedModeBanner: false,
      getPages: list,
      defaultTransition: Transition.rightToLeft,
      // builder: (context, widget) => Material(
      //   child: InkWell(
      //     onTap: () {
      //       FocusScopeNode currentFocus = FocusScope.of(context);
      //       if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      //         FocusManager.instance.primaryFocus?.unfocus();
      //       }
      //     },
      //     child: MediaQuery(
      //       data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      //       child: widget!,
      //     ),
      //   ),
      // ),
      builder: (context,widget){
        return  MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: widget!,
        );
      },
    );
  }
}