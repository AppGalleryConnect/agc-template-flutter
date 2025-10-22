import 'package:flutter/material.dart';
import '../../widgets/list/question_list.dart';
import '../../data/mock_data.dart';
import '../../models/post_model.dart';
import '../../constants.dart';

// 搜索政务信息页面
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchKeyword = '';
  List<PostModel> _searchResults = [];

  @override
  void initState() {
    super.initState();
    // 初始显示全部数据
    _searchResults = MockData.postItems;
  }

  void _performSearch(String query) {
    setState(() {
      _searchKeyword = query;

      if (query.isEmpty) {
        // 搜索词为空时显示全部数据
        _searchResults = MockData.postItems;
      } else {
        // 搜索逻辑：匹配标题、内容、回复内容
        _searchResults = MockData.postItems.where((item) {
          final titleMatch =
              item.title.toLowerCase().contains(query.toLowerCase());
          final contentMatch =
              item.content.toLowerCase().contains(query.toLowerCase());
          final replyMatch =
              item.replyText?.toLowerCase().contains(query.toLowerCase()) ??
                  false;
          final categoryMatch =
              item.category.toLowerCase().contains(query.toLowerCase());
          final accountMatch =
              item.account.name.toLowerCase().contains(query.toLowerCase());

          return titleMatch ||
              contentMatch ||
              replyMatch ||
              categoryMatch ||
              accountMatch;
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextField(
            controller: _searchController,
            autofocus: true,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              border: InputBorder.none,
              hintText: '搜索政务信息',
              contentPadding: EdgeInsets.symmetric(vertical: 9),
            ),
            onChanged: _performSearch,
            onSubmitted: _performSearch,
          ),
        ),
        actions: [
          TextButton(
            child: const Text(
              '取消',
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, size: 60, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              _searchKeyword.isEmpty ? '暂无政务信息' : '未找到匹配"$_searchKeyword"的内容',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return QuestionList(
      items: _searchResults,
      highlightKeyword: _searchKeyword.isNotEmpty ? _searchKeyword : null,
      isScrollable: true,
    );
  }
}
