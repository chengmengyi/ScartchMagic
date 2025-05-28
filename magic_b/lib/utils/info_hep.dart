import 'package:in_app_review/in_app_review.dart';
import 'package:magic_b/page/widget/dialog/big_win/bigwin_dialog.dart';
import 'package:magic_b/page/widget/dialog/cash_win/cashwin_dialog.dart';
import 'package:magic_b/page/widget/dialog/good_comment/comment_success/comment_success_dialog.dart';
import 'package:magic_b/page/widget/dialog/good_comment/good_comment/good_comment_dialog.dart';
import 'package:magic_b/page/widget/dialog/incent/incent_dialog.dart';
import 'package:magic_b/utils/b_sql/play_info_bean.dart';
import 'package:magic_b/utils/b_value/b_value_hep.dart';
import 'package:magic_b/utils/utils.dart';
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
    if(firstGetMoney.read()){   InfoHep.instance.updatePlayedCardNum();
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

  checkShowRewardDialog({
    required PlayType playType,
    required int reward,
    required Function(int addNum) dismissDialog,
}){
    if(firstGetGuaKaReward.read()){
      SmRoutersUtils.instance.showDialog(
          widget: IncentDialog(
            incentType: IncentType.card,
            money: BValueHep.instance.getNewPrize(),
            dismissDialog: (addNum){
              firstGetGuaKaReward.write(false);
              updateCoins(addNum);
              updatePlayedCardNum();
              dismissDialog.call(addNum);
            },
          ),
          arguments: {"sourceFrom":Utils.getSourceFromByPlayType(playType)}
      );
    }else{
      var showBigWin = BValueHep.instance.checkShowBigWin(reward);
      if(showBigWin){
        SmRoutersUtils.instance.showDialog(
            widget: BigwinDialog(
              addNum: reward,
              dismissDialog: (addNum){
                updateCoins(addNum);
                updatePlayedCardNum();
                dismissDialog.call(addNum);
              },
            )
        );
      }else{
        SmRoutersUtils.instance.showDialog(
            widget: CashwinDialog(
              addNum: reward,
              dismissDialog: (addNum){
                updateCoins(addNum);
                updatePlayedCardNum();
                dismissDialog.call(addNum);
              },
            )
        );
      }
    }
  }

  _showGoodCommentDialog(){
    // if(hasShowedGoodComment.read()){
    //   return;
    // }
    // SmRoutersUtils.instance.showDialog(
    //   widget: GoodCommentDialog(
    //     call: (index)async{
    //       hasShowedGoodComment.write(true);
    //       if(index<3){
    //         SmRoutersUtils.instance.showDialog(widget: CommentSuccessDialog());
    //       }else{
    //         var instance = InAppReview.instance;
    //         var isAvailable = await instance.isAvailable();
    //         if(isAvailable){
    //           instance.requestReview();
    //         }
    //       }
    //     },
    //   ),
    // );
  }
}