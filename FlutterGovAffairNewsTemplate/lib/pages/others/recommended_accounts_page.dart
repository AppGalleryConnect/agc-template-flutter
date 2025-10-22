import 'package:flutter/material.dart';
import '../../models/account_model.dart';
import '../../data/mock_data.dart';
import '../../widgets/follow_button.dart';
import '../../constants.dart';

// 推荐关注列表页面
class RecommendedAccountsPage extends StatefulWidget {
  const RecommendedAccountsPage({super.key});

  @override
  State<RecommendedAccountsPage> createState() =>
      _RecommendedAccountsPageState();
}

class _RecommendedAccountsPageState extends State<RecommendedAccountsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.of(context).pop()),
        title: const Text('推荐关注', style: TextStyle(fontSize: 18)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: MockData.accountItems.length,
        itemBuilder: (context, index) {
          final account = MockData.accountItems[index];
          return _buildAccountItem(account);
        },
      ),
    );
  }

  Widget _buildAccountItem(AccountModel account) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          radius: 20,
          backgroundImage: AssetImage(account.avatar),
          onBackgroundImageError: (_, __) => const Icon(Icons.person, size: 25),
        ),
        title: Text(
          account.name,
          style: const TextStyle(fontSize: 16),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: SizedBox(
          width: 56,
          child: FollowButton(
            initialFollowed: account.isFollowed,
            onFollowChanged: (isFollowed) {
              // 可以在这里处理关注状态变化
            },
            width: 48,
            height: 24,
          ),
        ),
      ),
    );
  }
}
