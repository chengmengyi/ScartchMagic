import 'package:event_bus/event_bus.dart';

final EventBus eventBus=EventBus();

class EventInfo{
  int eventCode;
  int? intValue;

  EventInfo({
    required this.eventCode,
    this.intValue,
  }){
    eventBus.fire(this);
  }
}