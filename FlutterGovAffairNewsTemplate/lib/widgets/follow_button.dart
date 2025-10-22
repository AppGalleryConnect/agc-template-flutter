import 'package:flutter/material.dart';

class FollowButton extends StatefulWidget {
  final bool initialFollowed;
  final Function(bool) onFollowChanged;
  final double? width;
  final double? height;
  final double? fontSize;

  const FollowButton({
    super.key,
    required this.initialFollowed,
    required this.onFollowChanged,
    this.width,
    this.height,
    this.fontSize = 12,
  });

  @override
  State<FollowButton> createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton> {
  late bool _isFollowed;
  bool _isHovering = false;

  @override
  void initState() {
    super.initState();
    _isFollowed = widget.initialFollowed;
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isFollowed = !_isFollowed;
          });
          widget.onFollowChanged(_isFollowed);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: widget.width,
          height: widget.height,
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
          decoration: BoxDecoration(
            color: _isFollowed
                ? (_isHovering ? Colors.red[50] : Colors.transparent)
                : (_isHovering ? Colors.red[100] : Colors.transparent),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _isFollowed
                  ? (_isHovering ? Colors.red : Colors.grey)
                  : Colors.red,
              width: 1,
            ),
          ),
          child: Center(
            child: Text(
              _isFollowed ? (_isHovering ? '取消关注' : '已关注') : '+ 关注',
              style: TextStyle(
                color: _isFollowed
                    ? (_isHovering ? Colors.red : Colors.grey[700])
                    : Colors.red,
                fontSize: widget.fontSize,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
