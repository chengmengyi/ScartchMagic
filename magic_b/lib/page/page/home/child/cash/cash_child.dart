import 'package:flutter/material.dart';
import 'package:magic_b/page/page/home/child/cash/cash_child_controller.dart';
import 'package:magic_b/utils/b_storage/b_storage_hep.dart';
import 'package:magic_b/utils/cash_task/cash_list_bean.dart';
import 'package:magic_base/base_widget/sm_base_tag_widget.dart';
import 'package:magic_base/base_widget/sm_image_widget.dart';
import 'package:magic_base/base_widget/sm_text_widget.dart';
import 'package:magic_base/utils/sm_export.dart';
import 'package:magic_base/utils/sm_extension.dart';

class CashChild extends SmBaseTagWidget<CashChildController>{
  bool home;
  CashChild({required this.home});

  @override
  String controllerTag() => "CashChildController$home";

  @override
  CashChildController setController() => CashChildController();

  @override
  Widget contentWidget() => Stack(
    children: [
      SmImageWidget(imageName: "cash_bg",width: double.infinity,height: double.infinity,boxFit: BoxFit.fill,),
      Column(
        children: [
          _cashTypeWidget(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _moneyWidget(),
                  _cashListWidget(),
                ],
              ),
            ),
          )
        ],
      )
    ],
  );

  _cashTypeWidget(){
    var height = MediaQuery.of(smController.smContext).padding.top;
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("magic_file/magic_image/top_bg.webp",),
          fit: BoxFit.fill,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: height,),
          SizedBox(
            width: double.infinity,
            height: 44.h,
            child: GetBuilder<CashChildController>(
              id: "cash_type",
              tag: controllerTag(),
              builder: (_)=>ListView.builder(
                itemCount: smController.cashTypeList.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context,index){
                  var bean = smController.cashTypeList[index];
                  return InkWell(
                    onTap: (){
                      smController.clickCashType(index);
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 12.w),
                      child: SmImageWidget(
                        imageName: smController.cashIndex==index?bean.selIcon:bean.unsIcon,
                        width: 108.w,
                        height: 44.h,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(height: 14.h,)
        ],
      ),
    );
  }

  _moneyWidget()=>Container(
    width: double.infinity,
    height: 136.h,
    margin: EdgeInsets.only(left: 12.w,right: 12.w,top: 16.h),
    child: Stack(
      alignment: Alignment.center,
      children: [
        SmImageWidget(imageName: "money_bg",width: double.infinity,height: 136.h,boxFit: BoxFit.fill,),
        Container(
          margin: EdgeInsets.only(left: 8.w,right: 8.w),
          child: Stack(
            children: [
              GetBuilder<CashChildController>(
                id: "money_bg",
                tag: controllerTag(),
                builder: (_)=>SmImageWidget(imageName: smController.getMoneyBg(),width: double.infinity,height: 120.h,boxFit: BoxFit.fill,),
              ),
              Positioned(
                top: 4.h,
                left: 4.w,
                child: Container(
                  padding: EdgeInsets.only(left: 8.w,right: 8.w,top: 3.h,bottom: 4.h),
                  decoration: BoxDecoration(
                    color: "#FFFFFF".toSmColor(),
                    borderRadius: BorderRadius.circular(12.w)
                  ),
                  child: SmTextWidget(
                    text: "100% Winning",
                    size: 12.sp, 
                    color: "#000000",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Positioned(
                right: 20.w,
                bottom: 10.h,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SmTextWidget(text: "\$", size: 20.sp, color: "#000000",fontWeight: FontWeight.bold,),
                    GetBuilder<CashChildController>(
                      id: "coins",
                      tag: controllerTag(),
                      builder: (_)=>SmTextWidget(text: "${coins.read()}", size: 32.sp, color: "#000000",fontWeight: FontWeight.bold,),
                    ),
                  ],
                ),
              )
            ],
          ),
        )
      ],
    ),
  );
  
  _cashListWidget()=>Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        margin: EdgeInsets.only(left: 12.w,top: 12.w,bottom: 12.w),
        child: SmTextWidget(text: "Choose withdraw amount", size: 18.sp, color: "#FFFFFF",fontWeight: FontWeight.bold,),
      ),
      GetBuilder<CashChildController>(
        id: "cash_list",
        tag: controllerTag(),
        builder: (_)=>MediaQuery.removePadding(
          removeTop: true,
          context: smController.smContext,
          child: ListView.builder(
            itemCount: smController.cashList.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context,index) => _cashItemWidget(smController.cashList[index]),
          ),
        ),
      )
    ],
  );
  
  _cashItemWidget(CashListBean bean)=>Container(
    width: double.infinity,
    height: 104.h,
    margin: EdgeInsets.only(left: 12.w,right: 12.w,bottom: 8.h),
    child: Stack(
      children: [
        SmImageWidget(imageName: "cash_list_bg", width: double.infinity,height: 104.h,boxFit: BoxFit.fill,),
        Container(
          width: double.infinity,
          height: 104.h,
          margin: EdgeInsets.all(8.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  SmTextWidget(text: "\$${bean.cashNum}", size: 24.sp, color: "#FFFFFF",fontWeight: FontWeight.bold,),
                  const Spacer(),
                  InkWell(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SmImageWidget(imageName: "cash_btn",width: 88.w,height: 28.h,),
                        InkWell(
                          onTap: (){
                            smController.clickCashOut(bean,home);
                          },
                          child: SmTextWidget(
                            text: smController.getBtnStr(bean.list),
                            size: 14.sp,
                            color: "#FFFFFF",
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                  color: "#825400".toSmColor(),
                                  blurRadius: 2.w,
                                  offset: Offset(0,0.5.w)
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(height: 4.h,),
              bean.list.isEmpty?Stack(
                alignment: Alignment.centerRight,
                children: [
                  LayoutBuilder(
                    builder: (context,bc){
                      var maxWidth = bc.maxWidth;
                      var pro = coins.read()/bean.cashNum;
                      if(pro>=1){
                        pro=1;
                      }
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: double.infinity,
                            height: 16.h,
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                              color: "#0F0942".toSmColor(),
                              borderRadius: BorderRadius.circular(8.w),
                            ),
                            child: Container(
                              width: maxWidth*pro,
                              height: 16.h,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.w),
                                  gradient: LinearGradient(colors: ["#FFD500".toSmColor(),"#FF7700".toSmColor(),])
                              ),
                            ),
                          ),
                          SmTextWidget(
                            text: "${(pro*100).toStringAsFixed(2)}%",
                            size: 12.sp,
                            color: "#FFFFFF",
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                  color: "#000000".toSmColor(),
                                  blurRadius: 2.w,
                                  offset: Offset(0,0.5.w)
                              )
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                  SmImageWidget(imageName: "b_coins",width: 24.w,height: 24.w,),
                ],
              ):
              _taskListWidget(bean.list),
            ],
          ),
        )
      ],
    ),
  );

  _taskListWidget(List<CashTaskBean> list)=>Row(
    children: [
      SmImageWidget(imageName: "icon_box2",width: 32.w,height: 32.h,),
      SizedBox(width: 8.w,),
      Expanded(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              height: 20.h,
              padding: EdgeInsets.only(left: 4.w,right: 4.w),
              margin: EdgeInsets.only(top: 2.h,bottom: 2.h),
              decoration: BoxDecoration(
                  color: "#3231A0".toSmColor(),
                  borderRadius: BorderRadius.circular(4.w)
              ),
              child: Row(
                children: [
                  Expanded(
                    child: SmTextWidget(text: smController.getTitleStr(list), size: 12.sp, color: "#FFFFFF"),
                  ),
                  SmTextWidget(text: smController.getTaskProStr(list), size: 12.sp, color: "#FFE32E",fontWeight: FontWeight.bold,),
                  SizedBox(width: 20.w,),
                  Container(
                    width: 16.w,
                    height: 16.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: "#140A5D".toSmColor(),
                        borderRadius: BorderRadius.circular(2.w)
                    ),
                    child: Visibility(
                      visible: smController.completeCurrentPro(list),
                      child: SmImageWidget(imageName: "gou",width: 16.w,height: 16.w,),
                    ),
                  )
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: 20.h,
              padding: EdgeInsets.only(left: 4.w,right: 4.w),
              margin: EdgeInsets.only(top: 2.h,bottom: 2.h),
              decoration: BoxDecoration(
                  color: "#3231A0".toSmColor(),
                  borderRadius: BorderRadius.circular(4.w)
              ),
              child: Row(
                children: [
                  Expanded(
                    child: SmTextWidget(text: "Play Game ${list.first.maxDays??0} days", size: 12.sp, color: "#FFFFFF"),
                  ),
                  SmTextWidget(text: smController.getDaysProStr(list), size: 12.sp, color: "#FFE32E",fontWeight: FontWeight.bold,),
                  SizedBox(width: 20.w,),
                  Container(
                    width: 16.w,
                    height: 16.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: "#140A5D".toSmColor(),
                        borderRadius: BorderRadius.circular(2.w)
                    ),
                    child: Visibility(
                      visible: smController.completeCurrentDays(list),
                      child: SmImageWidget(imageName: "gou",width: 16.w,height: 16.w,),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      )
    ],
  );
}