
import 'package:magic_base/base_widget/sm_base_controller.dart';
import 'package:magic_base/sm_router/all_routers_name.dart';
import 'package:magic_base/sm_router/sm_routers_utils.dart';
import 'package:magic_base/utils/sm_export.dart';
import 'package:magic_base/utils/voice/voice_utils.dart';

class SetController extends SmBaseController{
  toPrivacy(){
    SmRoutersUtils.instance.toNextPage(routersName: AllRoutersName.privacyA);
  }

  toEmail()async{
    var uri = Uri(scheme: "mailto",path: "bamello@bellezacb.com");
    var can = await canLaunchUrl(uri);
    if(can){
      launchUrl(uri);
    }
  }

  playVoiceMp3(){
    VoiceUtils.instance.setPlayOrStopVoice();
    update(["voice"]);
  }

  playBgMp3(){
    VoiceUtils.instance.setPlayOrStopBg();
    update(["bg"]);
  }
}