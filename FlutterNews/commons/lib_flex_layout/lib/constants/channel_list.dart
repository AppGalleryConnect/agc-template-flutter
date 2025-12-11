// 频道信息类
base class TabInfo {
  final String text;
  final String id;
  final bool selected;
  final int order;
  final bool disabled;

  const TabInfo({
    required this.text,
    required this.id,
    required this.selected,
    required this.order,
    this.disabled = false,
  });
}

// 频道列表常量
const List<TabInfo> channelList = [
  TabInfo(
    text: '关注',
    id: 'follow',
    selected: true,
    order: 1,
    disabled: true,
  ),
  TabInfo(
    text: '推荐',
    id: 'recommend',
    selected: true,
    order: 2,
    disabled: true,
  ),
  TabInfo(
    text: '热榜',
    id: 'hotService',
    selected: true,
    order: 3,
    disabled: true,
  ),
  TabInfo(
    text: '南京',
    id: 'location',
    selected: true,
    order: 4,
  ),
  TabInfo(
    text: '金融',
    id: 'finance',
    selected: true,
    order: 5,
  ),
  TabInfo(
    text: '体育',
    id: 'sports',
    selected: true,
    order: 6,
  ),
  TabInfo(
    text: '民生',
    id: 'people',
    selected: false,
    order: 6,
  ),
  TabInfo(
    text: '科普',
    id: 'science',
    selected: false,
    order: 6,
  ),
  TabInfo(
    text: '娱乐',
    id: 'fun',
    selected: false,
    order: 6,
  ),
  TabInfo(
    text: '夜读',
    id: 'read',
    selected: false,
    order: 6,
  ),
  TabInfo(
    text: '汽车',
    id: 'car',
    selected: false,
    order: 6,
  ),
  TabInfo(
    text: 'V观',
    id: 'view',
    selected: false,
    order: 6,
  ),
];
