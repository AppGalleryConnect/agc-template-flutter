import 'package:business_video/models/video_enevtbus.dart';
import 'package:business_video/pages/video_slider_page.dart';
import 'package:flutter/material.dart';
import 'package:business_video/types/page_type.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lib_common/lib_common.dart';
import 'package:business_video/models/video_model.dart';
import '../constants/constants.dart';
import 'package:newsflutterstemplate/notifier/fullScreenProvider.dart';

class VideoDetailPage extends StatefulWidget {
  const VideoDetailPage({
    super.key,
  });

  @override
  State<VideoDetailPage> createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage> {

  Duration currentDuration = Duration.zero;
  SettingModel settingInfo = StorageUtils.connect(
    create: () => SettingModel.getInstance(),
    type: StorageType.persistence,
  );

  bool isCommending = false;
  @override
  void initState() {
    super.initState();
    FullScreenProvider().addListener(_onFullScreenChanged);
  }

  @override
  void dispose() {
    FullScreenProvider().removeListener(_onFullScreenChanged);
    super.dispose();
  }

  void _onFullScreenChanged() {
    if (mounted) {
      setState(() {});
    }
  }
  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context)?.settings.arguments as VideoNewsData;
    return Stack(
      children: [
        VideoSliderPage(
          type: PageType.RECOMMEND,
          videoInfo: routeArgs,
          settingInfo: settingInfo,
          isVideo: true,
          onDuation: (duation) => {
            currentDuration = duation,
          },
          isCommend: isCommending,
          onCommend: (isCommend) => setState(() => isCommending = isCommend),
        ),

        if (!FullScreenProvider().isFullScreen)
        Positioned(
          left: 10,
          top: MediaQuery.of(context).padding.top + 10,
          child: GestureDetector(
            onTap: () {
              if (isCommending) {
                setState(() {
                  isCommending = false;
                  eventBus.fire(IsCommendEvent(false));
                });
              }
              RouterUtils.of.popWithResult(result: currentDuration);
            },
            child: Container(
              color: Colors.transparent,
              width: 80,
              height: 60,
              child: SvgPicture.asset(
                Constants.icLeftArrowImage,
                fit: BoxFit.none,
                width: 18,
                height: 32,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
