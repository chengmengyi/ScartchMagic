import 'package:event_bus/event_bus.dart';

final EventBus eventBus=EventBus();

class EventInfo{
  int eventCode;
  int? intValue;
  bool? boolValue;
  dynamic dynamicValue;

  EventInfo({
    required this.eventCode,
    this.intValue,
    this.boolValue,
    this.dynamicValue,
  }){
    eventBus.fire(this);
  }
}