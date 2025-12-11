import 'package:flutter/material.dart';
import 'package:module_flutter_channeledit/module_channeledit.dart';

class Constants {
  static const double SPACE_0 = 0.0;
  static const double SPACE_1 = 1.0;
  static const double SPACE_2 = 2.0;
  static const double SPACE_3 = 3.0;
  static const double SPACE_4 = 4.0;
  static const double SPACE_5 = 5.0;
  static const double SPACE_8 = 8.0;
  static const double SPACE_9 = 9.0;
  static const double SPACE_10 = 10.0;
  static const double SPACE_12 = 12.0;
  static const double SPACE_15 = 15.0;
  static const double SPACE_16 = 16.0;
  static const double SPACE_18 = 18.0;
  static const double SPACE_20 = 20.0;
  static const double SPACE_22 = 22.0;
  static const double SPACE_24 = 24.0;
  static const double SPACE_25 = 25.0;
  static const double SPACE_30 = 30.0;
  static const double SPACE_32 = 32.0;
  static const double SPACE_40 = 40.0;
  static const double SPACE_41 = 41.0;
  static const double SPACE_44 = 44.0;
  static const double SPACE_45 = 45.0;
  static const double SPACE_50 = 50.0;
  static const double SPACE_55 = 55.0;
  static const double SPACE_56 = 56.0;
  static const double SPACE_59 = 59.0;
  static const double SPACE_60 = 60.0;
  static const double SPACE_70 = 70.0;
  static const double SPACE_80 = 80.0;
  static const double SPACE_100 = 100.0;
  static const double SPACE_150 = 150.0;
  static const double SPACE_200 = 200.0;
  static const double SPACE_260 = 260.0;
  static const double SPACE_290 = 290.0;
  static const double SPACE_335 = 335.0;
  static const double SPACE_400 = 400.0;
  static const double SPACE_480 = 480.0;
  static const double SPACE_670 = 670.0;

  static const double FONT_10 = 10.0;
  static const double FONT_12 = 12.0;
  static const double FONT_14 = 14.0;
  static const double FONT_16 = 16.0;
  static const double FONT_18 = 18.0;
  static const double FONT_20 = 20.0;

  static const Color backButtonColor = Color.fromARGB(255, 229, 226, 226);
  static const Color textColor = Color(0xFF212121);
  static const Color backgroundColor = Color(0xFF505050);
  static const Color nodataTextColor = Color(0xFFFFFFFF);
  static const Color nodataDescTextColor = Color(0xFFBFBFBF);

  static const String deleteImage =
      'packages/module_flutter_channeledit/assets/delete.svg';
  static const String icLeftArrowImage =
      'packages/business_video/assets/ic_left_arrow.svg';
  static const String icLiveImage =
      'packages/business_video/assets/ic_live.svg';
  static const String icPlaybackImage =
      'packages/business_video/assets/ic_playback.svg';
  static const String icShareImage =
      'packages/module_swipeplayer/assets/ic_share.svg';
  static const String icLikeImage =
      'packages/module_swipeplayer/assets/ic_like.svg';
  static const String icUnlikeImage =
      'packages/module_swipeplayer/assets/ic_unlike.svg';
  static const String icNoticeImage =
      'packages/business_video/assets/ic_notice.svg';
  static const String icFollowListImage =
      'packages/business_video/assets/ic_follow_list.svg';

  static final List<TabInfo> channelsList = [
    TabInfo(
        id: 'introduce', text: '介绍', selected: true, order: 1, disabled: true),
    TabInfo(
        id: 'recommend', text: '评论', selected: true, order: 2, disabled: true),
  ];

  static final List<String> livestreamPreviewList = [
    '【直播预告】“小白主播”打台球-十堰晚报主播探店DK台球俱乐部专场',
    '【直播预告】果园满园，新疆万亩沙漠葡萄迎丰收',
    '【直播预告】“小白主播”打台球-十堰晚报主播探店DK台球俱乐部专场',
  ];

  static final List<TabInfo> videoChannelsList = [
    TabInfo(id: 'follow', text: '关注', selected: true, order: 1),
    TabInfo(id: 'feature', text: '精选', selected: true, order: 2),
    TabInfo(id: 'citymsg', text: '南京', selected: true, order: 3),
    TabInfo(id: 'recommend', text: '推荐', selected: true, order: 4),
    TabInfo(id: 'live', text: '直播', selected: true, order: 5),
  ];
}
