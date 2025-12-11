import 'package:event_bus/event_bus.dart';


final EventBus eventBus = EventBus(); 


class ShowTabbarEvent {
  final bool isShow;
  ShowTabbarEvent(this.isShow);
}

class IsCommendEvent {
  final bool isCommend;
  IsCommendEvent(this.isCommend);
}

class IsVideoItemEvent {
  final bool isVideo;
  IsVideoItemEvent(this.isVideo);
}

class VideoIsBlackEvent {
  final bool isBlack;
  VideoIsBlackEvent(this.isBlack);
}