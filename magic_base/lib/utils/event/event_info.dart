import 'package:event_bus/event_bus.dart';

final EventBus eventBus=EventBus();

class EventInfo{
  int eventCode;
  int? intValue;
  bool? boolValue;
  String? strValue;
  dynamic dynamicValue;

  EventInfo({
    required this.eventCode,
    this.intValue,
    this.boolValue,
    this.dynamicValue,
    this.strValue,
  }){
    eventBus.fire(this);
  }
}