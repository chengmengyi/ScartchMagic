import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:magic_b/utils/local_notification/local_notification_id.dart';
import 'package:magic_base/utils/event/event_code.dart';
import 'package:magic_base/utils/event/event_info.dart';
import 'package:magic_base/utils/sm_extension.dart';
import 'package:magic_base/utils/tba/ad_pos.dart';
import 'package:magic_base/utils/tba/tba_utils.dart';

class LocalNotificationUtils{
  factory LocalNotificationUtils()=>_getInstance();
  static LocalNotificationUtils get instance => _getInstance();
  static LocalNotificationUtils? _instance;
  static LocalNotificationUtils _getInstance(){
    _instance??=LocalNotificationUtils._internal();
    return _instance!;
  }

  LocalNotificationUtils._internal();

  var plugins=FlutterLocalNotificationsPlugin();
  var playPageShowing=false;

  initLocalNotification()async{
    var result = await plugins.initialize(
      const InitializationSettings(
          iOS: DarwinInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: true,
          )
      ),
      onDidReceiveNotificationResponse: (res){
        var type = res.notificationResponseType;
        if(type==NotificationResponseType.selectedNotification||type==NotificationResponseType.selectedNotificationAction){
          _clickNotification(res.id);
        }
      }
    );
    if(result==true){
      _showNotification(
        id: LocalNotificationId.guding,
        title: "Scratch to Earn",
        desc: ["💰Scratch. Win. Cash Out - Your Ticket to Instant Payouts","🎁Turn Virtual Cards Into Real Cash","🔥Uncover Instant Rewards with Scratch BigWin"].random(),
        repeatInterval: RepeatInterval.daily,
      );

      _showNotification(
        id: LocalNotificationId.qiandao,
        title: "Cash in check daily",
        desc: "Scratch your way to real cash prizes with Scratch Luck!",
        repeatInterval: RepeatInterval.hourly,
      );

      _showNotification(
        id: LocalNotificationId.guaguaka,
        title: "Go Scratch , Big Win!",
        desc: ["💰Earn money on the go with Scratch BigWin's instant payouts.","🎁Reveal hidden rewards and get paid out instantly."].random(),
        repeatInterval: RepeatInterval.hourly,
      );

      _showNotification(
        id: LocalNotificationId.tixian,
        title: "Pending withdraw amount",
        desc: "\$500 has arrived in your account",
        repeatInterval: RepeatInterval.daily,
      );
    }
  }

  _showNotification({
    required int id,
    required String title,
    required String desc,
    required RepeatInterval repeatInterval,
  }){
    plugins.periodicallyShow(
      id,
      title,
      desc,
      // kDebugMode?RepeatInterval.everyMinute:repeatInterval,
      repeatInterval,
      const NotificationDetails(),
      androidScheduleMode: AndroidScheduleMode.alarmClock,
    );
  }

  _clickNotification(int? id){
    switch(id){
      case LocalNotificationId.guding:
        TbaUtils.instance.pointEvent(pointType: PointType.sm_fix_inform_c);
        break;
      case LocalNotificationId.tixian:
        TbaUtils.instance.pointEvent(pointType: PointType.sm_cash_inform_c);
        break;
      case LocalNotificationId.qiandao:
        TbaUtils.instance.pointEvent(pointType: PointType.sm_sign_inform_c);
        break;
      case LocalNotificationId.guaguaka:
        TbaUtils.instance.pointEvent(pointType: PointType.sm_card_inform_c);
        break;
    }
  }

  checkFromNotificationLaunchApp()async{
    var details = await plugins.getNotificationAppLaunchDetails();
    if(details?.didNotificationLaunchApp==true){
      _clickNotification(details?.notificationResponse?.id);
    }
    TbaUtils.instance.pointEvent(pointType: PointType.sm_launch_page,data: {"source_from":details?.didNotificationLaunchApp==true?"push":"icon"});
  }

  checkClickNotificationShowTab()async{
    var details = await plugins.getNotificationAppLaunchDetails();
    if(details?.didNotificationLaunchApp==true&&details?.notificationResponse?.id==LocalNotificationId.tixian){
      EventInfo(eventCode: playPageShowing?EventCode.updatePlayPageTabIndex:EventCode.updateHomeTabIndex,intValue: 2);
    }
  }
  
  checkHasPermission()async{
    var notificationsPlugin = plugins.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
    var permissions = await notificationsPlugin?.checkPermissions();
    TbaUtils.instance.pointEvent(pointType: PointType.sm_push_status,data: {"status":permissions?.isEnabled==true?"on":"off"});
  }
}