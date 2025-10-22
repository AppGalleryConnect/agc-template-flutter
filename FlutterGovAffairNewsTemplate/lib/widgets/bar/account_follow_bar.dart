import 'package:flutter/material.dart';
import '../follow_button.dart';

class AccountFollowBar extends StatefulWidget {
  final String avatarUrl;
  final String name;
  final bool initialFollowed;
  final Function(bool)? onFollowChanged;

  const AccountFollowBar({
    super.key,
    required this.avatarUrl,
    required this.name,
    required this.initialFollowed,
    this.onFollowChanged,
  });
  @override
  State<AccountFollowBar> createState() => _AccountFollowBarState();
}

class _AccountFollowBarState extends State<AccountFollowBar> {
  late bool _isFollowed;

  @override
  void initState() {
    super.initState();
    _isFollowed = widget.initialFollowed;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 10,
          backgroundImage: AssetImage(widget.avatarUrl),
          onBackgroundImageError: (_, __) => const Icon(Icons.person),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            widget.name,
            style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
                fontWeight: FontWeight.normal),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
        const SizedBox(width: 10),
        FollowButton(
          width: 56,
          height: 24,
          initialFollowed: _isFollowed,
          onFollowChanged: (isFollowed) {
            setState(() {
              _isFollowed = isFollowed;
            });
            if (widget.onFollowChanged != null) {
              widget.onFollowChanged!(isFollowed);
            }
          },
        ),
      ],
    );
  }
}
