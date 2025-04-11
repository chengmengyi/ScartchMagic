import 'package:flutter/foundation.dart';
import 'package:flutter_android_local_notification/flutter_android_local_notification.dart';
import 'package:flutter_android_local_notification/local_notification_callback.dart';
import 'package:flutter_android_local_notification/local_notification_config.dart';
import 'package:magic_base/utils/tba/ad_pos.dart';
import 'package:magic_base/utils/tba/tba_utils.dart';

class NotificationType{
  static const String guding="guding";
  static const String suoping="suoping";
  static const String jiange1="jiange1";
  static const String jiange2="jiange2";
  static const String jiange3="jiange3";
}

class NotificationHep{
  static final NotificationHep _instance = NotificationHep();
  static NotificationHep get instance => _instance;

  initNotification()async{
    List<LocalNotificationConfig> workList=[];
    workList.add(LocalNotificationConfig(type: NotificationType.jiange1, title: "Your Cash is on the Way! 🚀", body: "You’re one step away from getting your cash!", intervalMinute: kDebugMode?1:30,));
    workList.add(LocalNotificationConfig(type: NotificationType.jiange2, title: "Payout Complete! 💸", body: "\$1000 has been sent. Check your account!", intervalMinute: kDebugMode?1:60,));
    workList.add(LocalNotificationConfig(type: NotificationType.jiange3, title: "Congrats! You Cashed Out! 🎊", body: "Verify now to receive your cash!", intervalMinute: kDebugMode?1:50,));
    FlutterAndroidLocalNotification.instance.initAllNotification(
      fcmTopic: "c68card_fcm",
      workList: workList,
      lockScreenNotification: LocalNotificationConfig(type: NotificationType.suoping, title: "Scratch to Earn", body: "💰Scratch. Win. Cash Out - Your Ticket to Instant Payouts", intervalMinute: 1),
      serviceNotification: LocalNotificationConfig(type: NotificationType.guding, title: "One Scratch, Endless Luck!", body: "Scratch Cards = Daily Cash! Turn Moments into Money, Anytime, Anywhere!", intervalMinute: kDebugMode?1:30,),
      callback: LocalNotificationCallback(
        clickNotificationCallback: (type){
          _clickNotification(type);
        },
        lockScreenNotificationShow: (){

        }
      ),
    );
    var launchNotificationType = await FlutterAndroidLocalNotification.instance.getLaunchNotificationType();
    if(launchNotificationType.isNotEmpty){
      _clickNotification(launchNotificationType);
    }
  }

  _clickNotification(String type){
    TbaUtils.instance.pointEvent(pointType: PointType.sm_notification_c,data: {"type":type});
  }
}