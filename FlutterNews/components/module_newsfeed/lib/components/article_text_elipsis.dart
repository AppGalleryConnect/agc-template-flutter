import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:module_newsfeed/constants/constants.dart';

class ArticleTextEllipsis extends StatefulWidget {
  // 是否支持展开/收起
  final bool enableExpand;
  // 原始文本
  final String text;
  // 省略后缀（默认“…”）
  final String omitContent;
  // 字体缩放比例
  final double fontSizeRatio;
  // 搜索关键词（用于高亮）
  final String searchKey;
  // 默认显示行数，null或0表示不限制行数
  final int? maxLines;

  const ArticleTextEllipsis({
    super.key,
    this.enableExpand = true,
    this.text = '',
    this.omitContent = '…',
    this.fontSizeRatio = 1.0,
    this.searchKey = '',
    this.maxLines = 3,
  });

  @override
  State<ArticleTextEllipsis> createState() => _ArticleTextEllipsisState();
}

class _ArticleTextEllipsisState extends State<ArticleTextEllipsis> {
  bool _isExpand = false;
  String _displayText = '';
  double _textContainerWidth = 0;
  TextStyle? _textStyle;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initTextStyle(); 
      _calculateDisplayText(); 
    });
  }

  void _initTextStyle() {
    final textColor = context.mounted
        ? (Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black87)
        : Colors.black87;

    _textStyle = TextStyle(
      fontSize: Constants.FONT_16 * widget.fontSizeRatio,
      fontWeight: FontWeight.w500,
      color: textColor, 
    );
  }

  @override
  void didUpdateWidget(covariant ArticleTextEllipsis oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text ||
        oldWidget.searchKey != widget.searchKey ||
        oldWidget.maxLines != widget.maxLines ||
        oldWidget.fontSizeRatio != widget.fontSizeRatio) {
      _initTextStyle();
      _calculateDisplayText();
    }
  }

  Future<void> _calculateDisplayText() async {
    if (_textContainerWidth == 0 || _textStyle == null) return;

    if (widget.maxLines == null ||
        widget.maxLines == 0 ||
        !widget.enableExpand) {
      setState(() => _displayText = widget.text);
      return;
    }

    final fullTextPainter = TextPainter(
      text: TextSpan(text: widget.text, style: _textStyle),
      maxLines: widget.maxLines ?? 3, 
      textDirection: TextDirection.ltr,
      textWidthBasis: TextWidthBasis.parent,
    )..layout(maxWidth: _textContainerWidth);

    if (!fullTextPainter.didExceedMaxLines) {
      setState(() => _displayText = widget.text);
      return;
    }

    if (_isExpand) {
      setState(() => _displayText = widget.text);
    } else {
      int left = 0;
      int right = widget.text.length;
      String bestMatch = '';

      while (left <= right) {
        final mid = (left + right) ~/ 2;
        if (mid <= 0) {
          left = mid + 1;
          continue;
        }
        final testText =
            '${widget.text.substring(0, mid)}${widget.omitContent}全文';
        final testPainter = TextPainter(
          text: TextSpan(text: testText, style: _textStyle),
          maxLines: widget.maxLines ?? 3, 
          textDirection: TextDirection.ltr,
          textWidthBasis: TextWidthBasis.parent,
        )..layout(maxWidth: _textContainerWidth);

        if (testPainter.didExceedMaxLines) {
          right = mid - 1;
        } else {
          bestMatch = testText;
          left = mid + 1;
        }
      }

      setState(() => _displayText = bestMatch);
    }
  }

  Widget _buildExpandableText() {
    if (_textStyle == null) return const SizedBox.shrink(); 

    if (!widget.enableExpand) {
      return Text(_displayText, style: _textStyle);
    }

    final String mainText;
    final bool showExpandBtn;

    if (_isExpand) {
      mainText = _displayText;
      showExpandBtn = false;
    } else {
      final omitIndex = _displayText.indexOf(widget.omitContent);
      if (omitIndex == -1) {
        mainText = _displayText;
        showExpandBtn = false;
      } else {
        mainText = _displayText.substring(0, omitIndex);
        showExpandBtn = true;
      }
    }

    return RichText(
      text: TextSpan(
        text: mainText,
        style: _textStyle,
        children: [
          if (showExpandBtn)
            TextSpan(
              text: '${widget.omitContent}全文',
              style: _textStyle?.copyWith(
                color: context.mounted
                    ? Theme.of(context).primaryColor
                    : Colors.blue, 
                decoration: TextDecoration.none,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  if (!mounted) return; 
                  setState(() => _isExpand = true);
                  _calculateDisplayText();
                },
            ),
          if (_isExpand)
            TextSpan(
              text: ' 收起',
              style: _textStyle?.copyWith(
                color: context.mounted
                    ? Theme.of(context).primaryColor
                    : Colors.blue,
                decoration: TextDecoration.none,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  if (!mounted) return;
                  setState(() => _isExpand = false);
                  _calculateDisplayText();
                },
            ),
        ],
      ),
    );
  }

  Widget _buildHighlightText() {
    if (_textStyle == null ||
        widget.searchKey.isEmpty ||
        !_displayText.contains(widget.searchKey)) {
      return _buildExpandableText();
    }

    final highlightIndex = _displayText.indexOf(widget.searchKey);
    if (highlightIndex < 0) return _buildExpandableText();

    final beforeText = _displayText.substring(0, highlightIndex);
    final highlightText = widget.searchKey;
    final afterText =
        _displayText.substring(highlightIndex + highlightText.length);

    return RichText(
      text: TextSpan(
        text: beforeText,
        style: _textStyle,
        children: [
          TextSpan(
            text: highlightText,
            style: _textStyle?.copyWith(
              backgroundColor: Constants.TEXT_COLOR.withOpacity(0.2),
              color: Constants.TEXT_COLOR,
            ),
          ),
          TextSpan(
            text: afterText,
            style: _textStyle,
            children: [
              if (_isExpand)
                TextSpan(
                  text: ' 收起',
                  style: _textStyle?.copyWith(
                    color: context.mounted
                        ? Theme.of(context).primaryColor
                        : Colors.blue,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      if (!mounted) return;
                      setState(() => _isExpand = false);
                      _calculateDisplayText();
                    },
                ),
              if (!_isExpand && _displayText.contains(widget.omitContent))
                TextSpan(
                  text: '${widget.omitContent}全文',
                  style: _textStyle?.copyWith(
                    color: context.mounted
                        ? Theme.of(context).primaryColor
                        : Colors.blue,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      if (!mounted) return;
                      setState(() => _isExpand = true);
                      _calculateDisplayText();
                    },
                ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (_textContainerWidth != constraints.maxWidth) {
          _textContainerWidth = constraints.maxWidth;
          if (context.mounted) {
            _initTextStyle();
            _calculateDisplayText();
          }
        }

        return widget.searchKey.isNotEmpty
            ? _buildHighlightText()
            : _buildExpandableText();
      },
    );
  }
}

class ArticleTextDemo extends StatelessWidget {
  const ArticleTextDemo({super.key});

  @override
  Widget build(BuildContext context) {
    const testText = 'Flutter 是谷歌推出的跨平台 UI 框架，支持一次编码多端运行，'
        '可以快速构建高性能、高保真的移动应用、Web 应用和桌面应用。'
        '本组件实现了文本多行省略和关键词高亮功能，适配不同屏幕尺寸。';

    return Scaffold(
      appBar: AppBar(title: const Text('文本省略示例')),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: Constants.SPACE_16, vertical: Constants.SPACE_20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('普通文本省略：',
                style: TextStyle(fontSize: Constants.FONT_18, fontWeight: FontWeight.bold)),
            SizedBox(height: Constants.SPACE_8),
            ArticleTextEllipsis(
              text: testText,
              maxLines: 2,
            ),
            SizedBox(height: Constants.SPACE_20),
            Text('关键词高亮（搜索“Flutter”）：',
                style: TextStyle(fontSize: Constants.FONT_18, fontWeight: FontWeight.bold)),
            SizedBox(height: Constants.SPACE_8),
            ArticleTextEllipsis(
              text: testText,
              searchKey: 'Flutter',
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }
}
