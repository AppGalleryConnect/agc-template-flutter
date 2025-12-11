import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

/// 共享的发送按钮组件
/// 根据输入内容实时改变按钮背景色和状态
class SendButton extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onPressed;
  final String iconPath;
  final Color activeColor;
  final Color inactiveColor;
  final Color iconColor;
  final bool isFocused;

  const SendButton({
    super.key,
    required this.controller,
    required this.onPressed,
    this.iconPath = 'assets/icons/publish.svg',
    this.activeColor = const Color.fromARGB(255, 92, 121, 217),
    this.inactiveColor = const Color.fromARGB(255, 189, 200, 239),
    this.iconColor = Colors.white,
    this.isFocused = false,
  });

  @override
  _SendButtonState createState() => _SendButtonState();
}

class _SendButtonState extends State<SendButton> {
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _isButtonEnabled = widget.controller.text.isNotEmpty;
    // 监听文本变化
    widget.controller.addListener(_handleTextChange);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleTextChange);
    super.dispose();
  }

  void _handleTextChange() {
    setState(() {
      _isButtonEnabled = widget.controller.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor =
        _isButtonEnabled ? widget.activeColor : widget.inactiveColor;

    return Container(
      width: 36,
      height: 36,
      margin: const EdgeInsets.only(left: 8),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor,
      ),
      child: IconButton(
        icon: SvgPicture.asset(
          widget.iconPath,
          color: widget.iconColor,
          width: 18,
          height: 18,
        ),
        iconSize: 18,
        padding: EdgeInsets.zero,
        onPressed: _isButtonEnabled ? widget.onPressed : null,
        splashRadius: 18,
      ),
    );
  }
}
