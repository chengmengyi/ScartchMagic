import 'package:in_app_review/in_app_review.dart';
import 'package:magic_b/page/widget/dialog/good_comment/comment_success/comment_success_dialog.dart';
import 'package:magic_b/page/widget/dialog/good_comment/good_comment/good_comment_dialog.dart';
import 'package:magic_base/sm_router/sm_routers_utils.dart';
import 'package:magic_base/utils/event/event_code.dart';
import 'package:magic_base/utils/event/event_info.dart';
import 'package:magic_b/utils/b_storage/b_storage_hep.dart';
import 'package:magic_base/utils/tba/ad_pos.dart';
import 'package:magic_base/utils/tba/tba_utils.dart';

class InfoHep{
  factory InfoHep()=>_getInstance();
  static InfoHep get instance => _getInstance();
  static InfoHep? _instance;
  static InfoHep _getInstance(){
    _instance??=InfoHep._internal();
    return _instance!;
  }

  InfoHep._internal();

  updateCoins(int addNum,{showLottie=true}){
    coins.add(addNum);
    if(addNum>0&&showLottie){
      var i = countMoney.read()+100;
      if(coins.read()>i){
        TbaUtils.instance.pointEvent(pointType: PointType.sm_cash_money_detail,data: {"money":i});
        countMoney.write(i);
      }
      EventInfo(eventCode: EventCode.showMoneyGetLottie,intValue: addNum);
    }else{
      EventInfo(eventCode: EventCode.updateCoins,intValue: addNum);
    }
    if(firstGetMoney.read()){
      firstGetMoney.write(false);
      _showGoodCommentDialog();
    }
  }

  updatePlayedCardNum(){
    playedCardNum.add(1);
    var num = playedCardNum.read();
    if(num==2){
      EventInfo(eventCode: EventCode.showRevealAllFingerGuide);
    }
    if(num==3){
      EventInfo(eventCode: EventCode.showBubble);
    }
  }

  updateBoxProgress(){
    if(currentBoxProgress.read()<5){
      currentBoxProgress.add(1);
    }
    EventInfo(eventCode: EventCode.updateBoxProgress);
  }

  notFirstLaunchAppShowCommentDialog(){
    if(firstLaunchApp.read()){
      firstLaunchApp.write(false);
      return;
    }
    _showGoodCommentDialog();
  }

  _showGoodCommentDialog(){
    SmRoutersUtils.instance.showDialog(
      widget: GoodCommentDialog(
        call: (index)async{
          if(index<3){
            SmRoutersUtils.instance.showDialog(widget: CommentSuccessDialog());
          }else{
            var instance = InAppReview.instance;
            var isAvailable = await instance.isAvailable();
            if(isAvailable){
              instance.requestReview();
            }
          }
        },
      ),
    );
  }
}