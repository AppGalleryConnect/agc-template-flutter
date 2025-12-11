import 'package:business_video/models/video_enevtbus.dart';
import 'package:business_video/pages/video_slider_page.dart';
import 'package:flutter/material.dart';
import 'package:business_video/types/page_type.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lib_common/lib_common.dart';
import 'package:business_video/models/video_model.dart';
import '../constants/constants.dart';

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
  Widget build(BuildContext context) {

    final routeArgs = ModalRoute.of(context)?.settings.arguments as VideoNewsData;

    Orientation orientation = MediaQuery.of(context).orientation;
    bool isLandscape = orientation == Orientation.portrait;
    
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
        if (isLandscape) Positioned(
          left: Constants.SPACE_0,
          top: Constants.SPACE_30,
          child: GestureDetector(
            onTap: () => {
              if (isCommending) {
                setState(() {
                  isCommending = false;
                  eventBus.fire(IsCommendEvent(false));
                }), 
              },
              
              RouterUtils.of.popWithResult(result: currentDuration),
            },
            child:Container(
              color: Colors.transparent,
              width: Constants.SPACE_80,
              height: Constants.SPACE_60,
              child:  SvgPicture.asset(
                Constants.icLeftArrowImage,
                fit: BoxFit.none,  
                width: Constants.SPACE_18, 
                height: Constants.SPACE_32,
              ),
            ),
          ),
        ),
      ]
    );
  }
}
     