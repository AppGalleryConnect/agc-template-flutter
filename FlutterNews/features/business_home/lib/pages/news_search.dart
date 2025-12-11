import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lib_news_api/constants/constants.dart';
import 'package:lib_common/constants/router_map.dart';
import 'package:lib_common/utils/router_utils.dart';
import 'package:business_video/models/video_model.dart';
import 'package:module_newsfeed/components/news_detail_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lib_news_api/params/response/layout_response.dart';
import 'package:lib_news_api/params/response/news_response.dart';
import 'package:lib_news_api/services/base_news_service.dart';
import '../commons/constants.dart' as BusinessConstants;
import '../generated/assets.dart';
import '../items_card/custom_item_card.dart';

class NewsSearch extends StatefulWidget {
  const NewsSearch({super.key});

  @override
  State<NewsSearch> createState() => _NewsSearchState();
}

class _NewsSearchState extends State<NewsSearch> {
  late TextEditingController _controller;
  final List<String> _historySearches = [];
  List<NewsResponse> _hotSearchNews = [];
  List<RequestListData> _searchResultsList = [];
  bool _isLoading = true;
  bool _showSearchResults = false;
  String _searchKeyword = '';
  bool _isFullResultsMode = false;
  bool _cleanHistory = true;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(_onSearchTextChanged);
    _loadHotSearchData();
    _loadHistorySearches();
  }

  void _onSearchTextChanged() {
    final keyword = _controller.text.trim();
    if (keyword.isEmpty) {
      setState(() {
        _searchKeyword = '';
        _searchResultsList.clear();
        _cleanHistory = true;
        _showSearchResults = false;
        _isFullResultsMode = false;
      });
      return;
    }

    final results = BaseNewsServiceApi.querySearchResultList(keyword);
    setState(() {
      _searchKeyword = keyword;
      _searchResultsList = results
          .take(BusinessConstants.Constants.newsSearchMaxResultsDisplay)
          .toList();
      _showSearchResults = true;
      _isFullResultsMode = false;
    });
  }

  void _onSearchResultTap(RequestListData item) {
    if (!_isFullResultsMode) {
      _handleSearchSubmit(_searchKeyword);
      return;
    }
    if (item.articles.isNotEmpty) {
      _pushToNewsDetail(context, item.articles.first);
    }
  }

  void _onHistoryItemTap(String keyword) {
    _controller.text = keyword;
    _handleSearchSubmit(keyword);
  }

  Future<void> _loadHotSearchData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final allNews = BaseNewsServiceApi.queryAllNewsList();
      setState(() {
        _hotSearchNews = allNews.take(10).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadHistorySearches() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyList = prefs.getStringList('search_history') ?? [];
      setState(() {
        _historySearches.clear();
        _historySearches.addAll(historyList);
      });
    } catch (e) {
      // 处理异常，例如打印日志或显示错误提示
    }
  }

  // 保存搜索历史到本地
  Future<void> _saveSearchHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('search_history', _historySearches);
    } catch (e) {
      // 处理异常，例如打印日志或显示错误提示
    }
  }

  // 清空历史搜索记录
  Future<void> clearHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('search_history');
      setState(() {
        _historySearches.clear();
      });
    } catch (e) {
      // 处理异常，例如打印日志或显示错误提示
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // 添加跳转到详情页的方法
  void _pushToNewsDetail(BuildContext context, NewsResponse news) {
    final isVideo = news.type == NewsEnum.video ||
        news.videoUrl != null ||
        (news.postImgList?.isNotEmpty == true &&
            news.postImgList!.first.surfaceUrl.isNotEmpty);
    if (isVideo) {
      final videoData = VideoNewsData.fromCommentResponse(news);
      RouterUtils.of.pushPathByName(
        RouterMap.VIDEO_PLAY_PAGE,
        param: videoData,
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NewsDetailPage(news: news)),
      );
    }
  }

  void _handleSearchSubmit(String value) {
    FocusScope.of(context).unfocus();
    if (value.isEmpty) {
      return;
    }
    final results = BaseNewsServiceApi.querySearchResultList(value);
    setState(
      () {
        if (!_historySearches.contains(value)) {
          _historySearches.insert(0, value);
          if (_historySearches.length >
              BusinessConstants.Constants.newsSearchHistoryMaxLength) {
            _historySearches.removeLast();
          }
        }
        _isFullResultsMode = true;
        _searchKeyword = value;
        _searchResultsList = results;
        _showSearchResults = true;
        _cleanHistory = false;
      },
    );
    _saveSearchHistory();
  }

  Widget _highlightKeyword(String text) {
    if (_searchKeyword.isEmpty ||
        !text.toLowerCase().contains(_searchKeyword.toLowerCase())) {
      return Text(
        text,
        style: const TextStyle(
          color: Colors.black,
          fontSize: BusinessConstants.Constants.newsSearchNormalFontSize,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }

    List<TextSpan> spans = [];
    int startIndex = 0;
    String lowerText = text.toLowerCase();
    String lowerKeyword = _searchKeyword.toLowerCase();
    int keywordIndex = lowerText.indexOf(lowerKeyword, startIndex);

    while (keywordIndex != -1) {
      if (keywordIndex > startIndex) {
        spans.add(
          TextSpan(
            text: text.substring(startIndex, keywordIndex),
            style: const TextStyle(
              color: BusinessConstants.Constants.newsSearchTextColorBlack,
              fontSize: BusinessConstants.Constants.newsSearchNormalFontSize,
            ),
          ),
        );
      }

      spans.add(TextSpan(
        text:
            text.substring(keywordIndex, keywordIndex + _searchKeyword.length),
        style: const TextStyle(
          color: BusinessConstants.Constants.newsSearchHighlightColor,
          fontSize: BusinessConstants.Constants.newsSearchNormalFontSize,
          fontWeight: FontWeight.bold,
        ),
      ));
      startIndex = keywordIndex + _searchKeyword.length;
      keywordIndex = lowerText.indexOf(lowerKeyword, startIndex);
    }

    if (startIndex < text.length) {
      spans.add(TextSpan(
        text: text.substring(startIndex),
        style: const TextStyle(
          color: Colors.black,
          fontSize: BusinessConstants.Constants.newsSearchNormalFontSize,
        ),
      ));
    }

    return RichText(
      text: TextSpan(children: spans),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  @override
  Widget build(BuildContext context) {
    // 历史搜索部分
    final historySection = Container(
      padding: BusinessConstants.Constants.newsSearchSectionPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '历史搜索',
                style: TextStyle(
                  color: BusinessConstants.Constants.newsSearchTextColorGrey600,
                  fontSize:
                      BusinessConstants.Constants.newsSearchNormalFontSize,
                ),
              ),
              TextButton(
                onPressed: clearHistory,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SvgPicture.asset(
                      Assets.assetsClear,
                      package: BusinessConstants.Constants.packageName,
                      width: 16,
                      height: 16,
                      colorFilter: const ColorFilter.mode(
                        BusinessConstants.Constants.newsSearchTextColorGrey,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(
                        width: BusinessConstants.Constants.newsSearchSpacingXs),
                    const Text(
                      '清空',
                      style: TextStyle(
                        color: BusinessConstants
                            .Constants.newsSearchTextColorGrey600,
                        fontSize: BusinessConstants
                            .Constants.newsSearchNormalFontSize,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (_historySearches.isEmpty)
            const Padding(
              padding:
                  BusinessConstants.Constants.newsSearchEmptyHistoryPadding,
              child: Center(
                child: Text(
                  '暂无历史搜索',
                  style: TextStyle(
                    color:
                        BusinessConstants.Constants.newsSearchTextColorGrey600,
                    fontSize:
                        BusinessConstants.Constants.newsSearchSmallFontSize,
                  ),
                ),
              ),
            ),
          if (_historySearches.isNotEmpty)
            Wrap(
              spacing: BusinessConstants.Constants.newsSearchSpacingM,
              runSpacing: BusinessConstants.Constants.newsSearchSpacingM,
              children: _historySearches.map(
                (searchText) {
                  return GestureDetector(
                    onTap: () => _onHistoryItemTap(searchText),
                    child: Container(
                      padding: BusinessConstants
                          .Constants.newsSearchHistoryTagPadding,
                      decoration: BoxDecoration(
                        color: BusinessConstants
                            .Constants.newsSearchHistoryTagBackgroundColor,
                        borderRadius: BorderRadius.circular(BusinessConstants
                            .Constants.newsSearchHistoryTagBorderRadius),
                      ),
                      child: Text(
                        searchText,
                        style: const TextStyle(
                          color: BusinessConstants
                              .Constants.newsSearchHistoryTagTextColor,
                          fontSize: BusinessConstants
                              .Constants.newsSearchNormalFontSize,
                        ),
                      ),
                    ),
                  );
                },
              ).toList(),
            ),
        ],
      ),
    );

    // 热搜榜部分
    final hotSearchSection = Container(
      padding: BusinessConstants.Constants.newsSearchSectionPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                Assets.assetsHotChart,
                package: BusinessConstants.Constants.packageName,
                width: BusinessConstants.Constants.newsSearchIconSizeMedium,
                height: BusinessConstants.Constants.newsSearchIconSizeMedium,
              ),
              const SizedBox(
                  width: BusinessConstants.Constants.newsSearchSpacingXs),
              const Text(
                '热搜榜',
                style: TextStyle(
                  color: BusinessConstants.Constants.newsSearchTextColorBlack,
                  fontSize: BusinessConstants.Constants.newsSearchTitleFontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(
              height: BusinessConstants.Constants.newsSearchSpacingL),
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _hotSearchNews.isEmpty
                  ? const Center(child: Text('暂无热搜数据'))
                  : Column(
                      children: _hotSearchNews.asMap().entries.map(
                        (entry) {
                          int index = entry.key + 1;
                          NewsResponse news = entry.value;
                          return GestureDetector(
                            onTap: () {
                              _pushToNewsDetail(context, news);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: BusinessConstants
                                      .Constants.newsSearchSpacingXs),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: BusinessConstants
                                        .Constants.newsSearchIndexWidth,
                                    margin: const EdgeInsets.only(
                                        right: BusinessConstants
                                            .Constants.newsSearchSpacingL),
                                    alignment: Alignment.center,
                                    child: Text(
                                      '$index',
                                      style: TextStyle(
                                        color: index <= 3
                                            ? BusinessConstants.Constants
                                                .newsSearchHotRankColor
                                            : BusinessConstants.Constants
                                                .newsSearchTextColorBlack,
                                        fontSize: BusinessConstants
                                            .Constants.newsSearchSmallFontSize,
                                        fontWeight: index <= 3
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      news.title,
                                      style: const TextStyle(
                                        color: BusinessConstants
                                            .Constants.newsSearchTextColorBlack,
                                        fontSize: BusinessConstants
                                            .Constants.newsSearchSmallFontSize,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ).toList(),
                    ),
        ],
      ),
    );
    final searchResultsSection = _showSearchResults &&
            _searchResultsList.isNotEmpty
        ? Container(
            margin: const EdgeInsets.all(
                BusinessConstants.Constants.newsSearchSpacingXl),
            child: _isFullResultsMode
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _searchResultsList.length,
                    itemBuilder: (context, index) {
                      final item = _searchResultsList[index];
                      item.extraInfo ??= {};
                      item.extraInfo!['searchKey'] = _searchKeyword;
                      for (var article in item.articles) {
                        article.extraInfo ??= {};
                        article.extraInfo!['searchKey'] = _searchKeyword;
                      }
                      return CustomItemCard(
                        context,
                        item,
                        onTap: (NewsResponse res) {
                          _onSearchResultTap(item);
                        },
                        searchKeyword: _searchKeyword,
                      );
                    },
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _searchResultsList.length <
                            BusinessConstants
                                .Constants.newsSearchMaxSuggestionsDisplay
                        ? _searchResultsList.length
                        : BusinessConstants
                            .Constants.newsSearchMaxSuggestionsDisplay,
                    itemBuilder: (context, index) {
                      final item = _searchResultsList[index];
                      final news =
                          item.articles.isNotEmpty ? item.articles.first : null;
                      if (news == null) return const SizedBox.shrink();
                      return GestureDetector(
                        onTap: () => _onSearchResultTap(item),
                        child: Container(
                          padding: BusinessConstants
                              .Constants.newsSearchResultItemPadding,
                          decoration: index <
                                  (_searchResultsList.length < 5
                                          ? _searchResultsList.length
                                          : 5) -
                                      1
                              ? const BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: BusinessConstants
                                          .Constants.newsSearchDividerColor,
                                    ),
                                  ),
                                )
                              : null,
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _handleSearchSubmit(_searchKeyword);
                                },
                                child: const Icon(
                                  Icons.search,
                                  size: BusinessConstants
                                      .Constants.newsSearchIconSizeLarge,
                                  color: BusinessConstants
                                      .Constants.newsSearchTextColorGrey,
                                ),
                              ),
                              const SizedBox(
                                  width: BusinessConstants
                                      .Constants.newsSearchSpacingS),
                              Expanded(
                                child: _highlightKeyword(news.title),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          )
        : _showSearchResults
            ? Visibility(
                visible: _cleanHistory ? true : false,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: const Center(child: Text('暂无热搜数据')),
                ),
              )
            : Container();
    return Material(
      color: BusinessConstants.Constants.newsSearchTextColorWhite,
      child: Scaffold(
        backgroundColor: BusinessConstants.Constants.newsSearchTextColorWhite,
        appBar: AppBar(
          leading: const BackButton(),
          title: Container(
            margin: BusinessConstants.Constants.newsSearchAppBarMargin,
            height: BusinessConstants.Constants.newsSearchTextFieldHeight,
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                  prefixIcon: GestureDetector(
                    onTap: () {
                      _cleanHistory = true;
                      _handleSearchSubmit(_controller.text);
                    },
                    child: const Icon(Icons.search,
                        color: BusinessConstants
                            .Constants.newsSearchTextColorGrey),
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear,
                        color: BusinessConstants
                            .Constants.newsSearchTextColorGrey),
                    onPressed: () {
                      _controller.clear();
                      setState(() {
                        _cleanHistory = true;
                      });
                    },
                  ),
                  hintText: '请输入关键词搜索',
                  filled: true,
                  fillColor: BusinessConstants
                      .Constants.newsSearchTextFieldBackgroundColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(BusinessConstants
                        .Constants.newsSearchTextFieldBorderRadius),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      BusinessConstants.Constants.newsSearchTextFieldPadding),
              onSubmitted: _handleSearchSubmit,
            ),
          ),
          backgroundColor: BusinessConstants.Constants.newsSearchTextColorWhite,
          elevation: 0,
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    searchResultsSection,
                    if (!_showSearchResults)
                      Column(
                        children: [
                          historySection,
                          hotSearchSection,
                        ],
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
