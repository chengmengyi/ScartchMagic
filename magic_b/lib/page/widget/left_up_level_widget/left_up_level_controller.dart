import 'package:magic_base/base_widget/sm_base_controller.dart';
import 'package:magic_base/utils/event/event_code.dart';
import 'package:magic_base/utils/event/event_info.dart';
import 'package:magic_b/utils/b_sql/b_sql_utils.dart';

class LeftUpLevelController extends SmBaseController{
  var upLevelNum=0;

  @override
  void onReady() {
    super.onReady();
    updateUpLevelNum();
  }

  @override
  bool smRegisterEvent() => true;

  @override
  smEventReceived(EventInfo eventInfo) {
    if(eventInfo.eventCode==EventCode.updateUpLevelText){
      updateUpLevelNum();
    }
  }

  updateUpLevelNum()async{
    var list = await BSqlUtils.instance.queryPlayList();
    var allPlayedNum = list.map((item) => (item.playedNum??0)).reduce((a, b) => a + b);
    upLevelNum=5-allPlayedNum%5;
    update(["num"]);
  }
}