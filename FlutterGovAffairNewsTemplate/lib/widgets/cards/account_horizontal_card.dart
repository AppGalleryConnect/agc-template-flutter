import 'package:flutter/material.dart';
import '../../models/account_model.dart';
import '../follow_button.dart';

class AccountHorizontalCard extends StatefulWidget {
  final AccountModel account;

  const AccountHorizontalCard({
    super.key,
    required this.account,
  });

  @override
  State<AccountHorizontalCard> createState() => _AccountHorizontalCardState();
}

class _AccountHorizontalCardState extends State<AccountHorizontalCard> {
  late bool _isFollowed;

  @override
  void initState() {
    super.initState();
    _isFollowed = widget.account.isFollowed;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 政务号头像
          CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage(widget.account.avatar),
            onBackgroundImageError: (_, __) =>
                const Icon(Icons.person, size: 30),
          ),
          const SizedBox(height: 10),
          // 政务号名称
          Text(
            widget.account.name,
            style: const TextStyle(fontSize: 14),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),
          // 关注按钮
          FollowButton(
            initialFollowed: _isFollowed,
            onFollowChanged: (isFollowed) {
              setState(() {
                _isFollowed = isFollowed;
              });
            },
            width: 56,
            height: 24,
          ),
        ],
      ),
    );
  }
}
