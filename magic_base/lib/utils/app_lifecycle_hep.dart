import 'package:flutter_app_lifecycle/app_state_observer.dart';
import 'package:flutter_app_lifecycle/flutter_app_lifecycle.dart';
import 'package:magic_base/utils/voice/voice_utils.dart';

class AppLifecycleHep {
  static final AppLifecycleHep _instance = AppLifecycleHep();
  static AppLifecycleHep get instance => _instance;

  add(){
    FlutterAppLifecycle.instance.setCallObserver(
      AppStateObserver(call: (back){
        VoiceUtils.instance.appLifecycle(back);
      })
    );
  }
}