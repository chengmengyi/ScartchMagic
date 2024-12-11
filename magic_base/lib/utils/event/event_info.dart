import 'package:event_bus/event_bus.dart';

final EventBus eventBus=EventBus();

class EventInfo{
  int eventCode;
  int? intValue;
  bool? boolValue;

  EventInfo({
    required this.eventCode,
    this.intValue,
    this.boolValue,
  }){
    eventBus.fire(this);
  }
}