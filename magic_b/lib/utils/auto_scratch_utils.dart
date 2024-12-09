import 'package:flutter/material.dart';
import 'package:magic_base/utils/sm_export.dart';

class AutoScratchUtils{
  bool stopWhile=false;
  double width=0.0,height=0.0,marginTop=0.0,marginLeft=0.0;

  AutoScratchUtils(GlobalKey bgGlobalKey,GlobalKey scratchGlobalKey){
    var renderBox = scratchGlobalKey.currentContext!.findRenderObject() as RenderBox;
    width = renderBox.size.width;
    height = renderBox.size.height;
    var offset = renderBox.localToGlobal(Offset.zero);

    var contentRender = bgGlobalKey.currentContext!.findRenderObject() as RenderBox;
    var contentOffset = contentRender.localToGlobal(Offset.zero);
    marginTop = offset.dy-contentOffset.dy;
    marginLeft= offset.dx;
  }

  startAuto({
    required GlobalKey<ScratcherState> key,
    required Function(Offset offset) iconOffsetCall,
})async{
    var hang=1,currentDx=0;
    while(hang*15<height&&!stopWhile){
      if(hang%2!=0){
        if(currentDx<width){
          currentDx+=10;
          key.currentState?.addPoint(Offset(currentDx.toDouble(), hang==1?15:(hang-1)*15+30));
          iconOffsetCall.call(Offset(currentDx.toDouble(), (hang==1?15:(hang-1)*15+30)+marginTop));
        }else{
          hang++;
        }
      }else{
        if(currentDx>0){
          currentDx-=10;
          key.currentState?.addPoint(Offset(currentDx.toDouble(), (hang-1)*15+30));
          iconOffsetCall.call(Offset(currentDx.toDouble(), (hang-1)*15+30+marginTop));
        }else{
          hang++;
        }
      }
      await Future.delayed(const Duration(milliseconds: 1));
    }
  }
}