import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:module_flutter_channeledit/model/model.dart';
import 'package:module_flutter_channeledit/components/channels_sort_edit.dart';
import 'package:module_flutter_channeledit/components/custom_tab_bar.dart';
import 'package:module_flutter_channeledit/constants/constants.dart';

class ChannelEdit extends StatefulWidget {
  final int currentIndex;
  final List<TabInfo> channelsList;
  final double fontSizeRatio;
  final bool isShowEdit;
  final Function(List<TabInfo> channelsList) onSave;
  final Function(int index, TabInfo item) onChange;
  final int index;
  final bool isDark;
  final Color fontColor;
  final Color backgroundColor;
  final Color backgroundColorTertiary;
  final String editType;

  const ChannelEdit({
    super.key,
    this.currentIndex = 1,
    this.channelsList = const [],
    this.fontSizeRatio = 1.0,
    this.editType = '',
    this.isShowEdit = true,
    this.fontColor = Colors.black,
    this.backgroundColor = Colors.white,
    this.backgroundColorTertiary = Colors.grey,
    required this.onSave,
    required this.onChange,
    this.index = 0,
    this.isDark = false,
  });

  @override
  State<ChannelEdit> createState() => _ChannelEditState();
}

class _ChannelEditState extends State<ChannelEdit> {
  List<TabInfo> selectChannelList = [];
  List<TabInfo> unselectChannelList = [];
  final ScrollController listScroller = ScrollController();

  @override
  void initState() {
    super.initState();
    _updateChannelLists();
  }

  @override
  void didUpdateWidget(covariant ChannelEdit oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 当父组件传递的channelsList更新时，重新计算选中和未选中的频道列表
    if (oldWidget.channelsList != widget.channelsList) {
      _updateChannelLists();
    }
  }

  void _updateChannelLists() {
    selectChannelList =
        widget.channelsList.where((element) => element.selected).toList();
    unselectChannelList =
        widget.channelsList.where((element) => !element.selected).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.isDark ? Colors.black : Colors.transparent,
      height: Constants.SPACE_56,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: CustomTabBar(
              listScroller: listScroller,
              myChannels: selectChannelList,
              fontColor: widget.fontColor,
              fontSizeRatio: widget.fontSizeRatio,
              currentIndex: widget.currentIndex,
              onIndexChange: (index, item) => widget.onChange(index, item),
              isShowEdit: widget.isShowEdit,
              index: widget.index,
              isDark: widget.isDark,
            ),
          ),
          IconButton(
            icon: SvgPicture.asset(
              widget.isShowEdit ? Constants.moreImage : Constants.searchImage,
              width: Constants.SPACE_24,
              height: Constants.SPACE_24,
              colorFilter: widget.currentIndex < widget.index
                  ? ColorFilter.mode(
                      widget.editType == 'video'
                          ? Colors.white
                          : widget.isDark
                              ? Colors.white
                              : Colors.black,
                      BlendMode.srcIn)
                  : ColorFilter.mode(
                      widget.isDark ? Colors.white : Colors.black,
                      BlendMode.srcIn),
              fit: BoxFit.fill,
            ),
            onPressed: () {
              widget.isShowEdit
                  ? _showEditSheet(context)
                  : widget.onSave(selectChannelList + unselectChannelList);
            },
          ),
        ],
      ),
    );
  }

  void _showEditSheet(BuildContext context) {
    List<TabInfo> localSelected = List.from(selectChannelList);
    List<TabInfo> localUnSelected = List.from(unselectChannelList);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(Constants.SPACE_20)),
      ),
      clipBehavior: Clip.antiAlias,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight:
                    MediaQuery.of(context).size.height * 0.7,
              ),
              child: ChannelsSortEdit(
                selectChannelList: localSelected,
                unselectChannelList: unselectChannelList,
                fontSizeRatio: widget.fontSizeRatio,
                backgroundColor: widget.backgroundColor,
                backgroundColorTertiary: widget.backgroundColorTertiary,
                fontColor: widget.fontColor,
                onSave: (index, item) {
                  setState(() {
                    if (item.selected) {
                      localSelected.add(item);
                      localUnSelected.remove(item);
                    } else {
                      localSelected.remove(item);
                      localUnSelected.add(item);
                    }
                  });

                  this.setState(() {
                    selectChannelList = List.from(localSelected);
                    unselectChannelList = List.from(localUnSelected);
                  });

                  widget.onSave(selectChannelList + unselectChannelList);
                },
                onChannelClick: (index, item) {
                  widget.onChange(index, item);
            },
              ),
            );
          },
        );
      },
    );
  }
}
