import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:module_flutter_channeledit/model/model.dart';
import 'package:module_flutter_channeledit/constants/constants.dart';

class ChannelsSortEdit extends StatefulWidget {
  final List<TabInfo> selectChannelList;
  final List<TabInfo> unselectChannelList;
  final double fontSizeRatio;
  final Function(int index, TabInfo item) onSave;
  final Function(int index, TabInfo item) onChannelClick;
  const ChannelsSortEdit({
    super.key,
    this.selectChannelList = const [],
    this.unselectChannelList = const [],
    this.fontSizeRatio = 1.0,
    required this.onSave,
    required this.onChannelClick,
  });

  @override
  State<ChannelsSortEdit> createState() => _ChannelSortEditState();
}

class _ChannelSortEditState extends State<ChannelsSortEdit> {
  bool _isEdit = false;

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Column(
          children: [
            _titleBuilder('自定义'),
            _channelBuilder('我的频道', '点击进入频道', true),
            Expanded(
              child: _channelItemBuilder(widget.selectChannelList, false),
            ),
            _channelBuilder('推荐频道', '点击添加', false),
            Expanded(
              child: _channelItemBuilder(widget.unselectChannelList, true),
            ),
          ],
        ));
  }

  Widget _titleBuilder(String title) {
    return Container(
      height: Constants.SPACE_80,
      padding: const EdgeInsets.symmetric(horizontal: Constants.SPACE_16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: Constants.FONT_16 * widget.fontSizeRatio,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          Container(
            width: Constants.SPACE_40,
            height: Constants.SPACE_40,
            decoration: BoxDecoration(
              color: Constants.SORT_EDIT_BACKGROUNDCOLOR,
              borderRadius: BorderRadius.circular(Constants.SPACE_25),
              border:
                  Border.all(color: Colors.black12, width: Constants.SPACE_1),
            ),
            child: IconButton(
              padding: const EdgeInsets.all(Constants.SPACE_12),
              icon: SvgPicture.asset(
                Constants.deleteImage,
                width: Constants.SPACE_15,
                height: Constants.SPACE_15,
                colorFilter: ColorFilter.mode(
                    Theme.of(context).colorScheme.primary, BlendMode.srcIn),
                fit: BoxFit.contain,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _channelBuilder(String title, String subTitle, bool isShowEdit) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: Constants.SPACE_16),
          height: Constants.SPACE_40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: Constants.FONT_16 * widget.fontSizeRatio,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(width: Constants.SPACE_8),
                  Text(
                    subTitle,
                    style: TextStyle(
                      fontSize: Constants.FONT_12 * widget.fontSizeRatio,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              if (isShowEdit)
                GestureDetector(
                  child: Text(
                    _isEdit ? '完成' : '编辑',
                    style: TextStyle(
                      fontSize: Constants.FONT_16 * widget.fontSizeRatio,
                      color: Constants.SORT_EDIT_TEXT_COLOR,
                    ),
                  ),
                  onTap: () {
                    setState(
                      () {
                        _isEdit = !_isEdit;
                      },
                    );
                  },
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _channelItemBuilder(List<TabInfo> list, bool isAdd) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Constants.SPACE_16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: Constants.SPACE_16,
          mainAxisSpacing: Constants.SPACE_16,
          childAspectRatio: Constants.SPACE_2,
        ),
        itemCount: list.length,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (_, index) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Constants.SPACE_25),
              border:
                  Border.all(color: Colors.black12, width: Constants.SPACE_1),
              color: Constants.SORT_EDIT_BACKGROUNDCOLOR,
            ),
            child: Center(
                child: GestureDetector(
              onLongPress: () => {
                if (!_isEdit && !isAdd)
                  {
                    setState(() {
                      _isEdit = true;
                    })
                  }
              },
              onTap: () => {
                if (isAdd)
                  {
                    setState(() {
                      TabInfo info = list[index];
                      info.selected = true;
                      widget.onSave(index, info);
                    })
                  }
                else if (!_isEdit)
                  {
                    setState(() {
                      Navigator.pop(context);
                      widget.onChannelClick(index, list[index]);
                    })
                  }
                else if (!list[index].disabled!)
                  {
                    setState(() {
                      TabInfo info = list[index];
                      info.selected = false;
                      widget.onSave(index, list[index]);
                    })
                  }
              },
              child: Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isAdd)
                    SvgPicture.asset(
                      Constants.addImage,
                      width: Constants.SPACE_10,
                      height: Constants.SPACE_10,
                      colorFilter: ColorFilter.mode(
                          Theme.of(context).colorScheme.primary,
                          BlendMode.srcIn),
                      fit: BoxFit.contain,
                    ),
                  const SizedBox(
                    width: Constants.SPACE_8,
                  ),
                  Text(list[index].text),
                  const SizedBox(
                    width: Constants.SPACE_8,
                  ),
                  if (_isEdit && !list[index].disabled! && !isAdd)
                    SvgPicture.asset(
                      Constants.deleteImage,
                      width: Constants.SPACE_10,
                      height: Constants.SPACE_10,
                      colorFilter: ColorFilter.mode(
                          Theme.of(context).colorScheme.primary,
                          BlendMode.srcIn),
                      fit: BoxFit.contain,
                    ),
                ],
              ),
            )),
          );
        },
      ),
    );
  }
}
