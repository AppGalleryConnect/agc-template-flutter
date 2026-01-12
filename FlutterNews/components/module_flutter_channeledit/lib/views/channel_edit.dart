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

  const ChannelEdit({
    super.key,
    this.currentIndex = 1,
    this.channelsList = const [],
    this.fontSizeRatio = 1.0,
    this.isShowEdit = true,
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
                  ? const ColorFilter.mode(Colors.white, BlendMode.srcIn)
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
    showModalBottomSheet(
      context: context,
      builder: (ctx) => ChannelsSortEdit(
        selectChannelList: selectChannelList,
        unselectChannelList: unselectChannelList,
        fontSizeRatio: widget.fontSizeRatio,
        onSave: (index, item) => {
          setState(
            () {
              if (item.selected) {
                selectChannelList.add(item);
                unselectChannelList.remove(item);
                widget.onSave(selectChannelList + unselectChannelList);
              } else {
                selectChannelList.remove(item);
                unselectChannelList.add(item);
                widget.onSave(selectChannelList + unselectChannelList);
                if (widget.currentIndex == index) {
                  if (index <= selectChannelList.length - 1) {
                    widget.onChange(index, item);
                  } else {
                    widget.onChange(1, item);
                  }
                }
              }
            },
          )
        },
        onChannelClick: (index, item) => {
          setState(
            () {
              widget.onChange(index, item);
            },
          )
        },
      ),
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(Constants.SPACE_20)),
      ),
      clipBehavior: Clip.antiAlias,
    );
  }
}
