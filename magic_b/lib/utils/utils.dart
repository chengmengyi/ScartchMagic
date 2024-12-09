import 'package:magic_base/sm_router/all_routers_name.dart';
import 'package:magic_base/sm_router/sm_routers_utils.dart';
import 'package:magic_b/utils/b_sql/b_sql_utils.dart';
import 'package:magic_b/utils/b_sql/play_info_bean.dart';

class Utils{
  static toNextPlay(PlayType playType)async{
    var list = await BSqlUtils.instance.queryPlayList();
    var indexWhere = list.indexWhere((element) => (element.time??0)<=0,list.indexWhere((element) => element.type==playType.name)+1);
    if(indexWhere<0){
      SmRoutersUtils.instance.offPage();
      return;
    }

    var currentType = list[indexWhere].type??"";
    // PlayType? nextPlay;
    String routersName="";
    if(currentType==PlayType.playfruit.name){
      // nextPlay=PlayType.playbig;
      routersName=AllRoutersName.playFruitA;
    }else if(currentType==PlayType.playbig.name){
      // nextPlay=PlayType.playtiger;
      routersName=AllRoutersName.playBigA;
    }else if(currentType==PlayType.playtiger.name){
      // nextPlay=PlayType.play7;
      routersName=AllRoutersName.playTigerA;
    }else if(currentType==PlayType.play7.name){
      // nextPlay=PlayType.playemoji;
      routersName=AllRoutersName.play7A;
    }else if(currentType==PlayType.playemoji.name){
      // nextPlay=PlayType.play8;
      routersName=AllRoutersName.playEmojiA;
    }else if(currentType==PlayType.play8.name){
      // nextPlay=PlayType.playfruit;
      routersName=AllRoutersName.play8A;
    }
    // if(null==nextPlay){
    //   SmRoutersUtils.instance.offPage();
    //   return;
    // }
    await BSqlUtils.instance.unlockNextPlay(currentType);
    SmRoutersUtils.instance.toNextPageAndOffCurrent(routersName: routersName);
  }
}