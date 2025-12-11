import 'package:business_video/views/video_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constants/constants.dart';

class VideoNodata extends StatelessWidget {
  const VideoNodata({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.black,
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height / 2 - Constants.SPACE_70),
            SizedBox(
              child: SvgPicture.asset(
                Constants.icFollowListImage,
                width: Constants.SPACE_60,
                height: Constants.SPACE_55,
              ),
            ),
            const SizedBox(height: Constants.SPACE_10),
            const Text('暂无登录，登录后查看关注内容',
                style: TextStyle(fontSize: Constants.FONT_14, color: Constants.nodataDescTextColor)),
            const SizedBox(height: Constants.SPACE_10),
            GestureDetector(
              onTap: () => VideoSheet.showLoginSheet(context),
              child: Container(
                width: MediaQuery.of(context).size.width / 3,
                height: Constants.SPACE_40,
                decoration: BoxDecoration(
                    color: Constants.backgroundColor,
                    borderRadius: BorderRadius.circular(Constants.SPACE_5)),
                child: const Center(
                    child: Text('登录',
                        style:
                            TextStyle(fontSize: Constants.FONT_14, color: Constants.nodataTextColor))),
              ),
            )
          ],
        ),
      ),
    );
  }
}
