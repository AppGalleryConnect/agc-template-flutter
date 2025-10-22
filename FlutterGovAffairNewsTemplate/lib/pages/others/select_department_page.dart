import 'package:flutter/material.dart';
import '../../models/account_model.dart';
import '../../data/mock_data.dart';
import '../../constants.dart';

// 选择部门页面
class SelectDepartmentPage extends StatefulWidget {
  const SelectDepartmentPage({super.key});

  @override
  State<SelectDepartmentPage> createState() => _SelectDepartmentPageState();
}

class _SelectDepartmentPageState extends State<SelectDepartmentPage> {
  List<AccountModel> _filteredAccounts = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredAccounts = MockData.accountItems;
    _searchController.addListener(_filterAccounts);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterAccounts() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredAccounts = MockData.accountItems;
      } else {
        _filteredAccounts = MockData.accountItems
            .where((account) => account.name.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '选择部门',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Column(
        children: [
          // 搜索框
          _buildSearchBar(),
          // 部门列表
          Expanded(
            child: _buildDepartmentList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 16, right: 8),
              child: Icon(Icons.search, color: Colors.grey),
            ),
            Expanded(
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: '请输入想要选择的部门',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
                style: const TextStyle(fontSize: 16),
                onChanged: (value) => _filterAccounts(),
              ),
            ),
            if (_searchController.text.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.close, size: 20),
                onPressed: () {
                  _searchController.clear();
                  _filterAccounts();
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDepartmentList() {
    if (_filteredAccounts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, size: 60, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              _searchController.text.isEmpty
                  ? '暂无政务号数据'
                  : '未找到"${_searchController.text}"相关的部门',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 24),
      itemCount: _filteredAccounts.length,
      itemBuilder: (context, index) {
        final account = _filteredAccounts[index];
        return _buildDepartmentItem(account);
      },
      separatorBuilder: (BuildContext context, int index) {
        return Container(color: AppConstants.backgroundColor, height: 1.0);
      },
    );
  }

  Widget _buildDepartmentItem(AccountModel account) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      leading:
          CircleAvatar(radius: 15, backgroundImage: AssetImage(account.avatar)),
      title: Text(
        account.name,
        style: const TextStyle(
          fontSize: 16
        ),
      ),
      onTap: () {
        // 这里可以处理选择部门后的逻辑
        // Navigator.pop(context, account);
      },
    );
  }
}
