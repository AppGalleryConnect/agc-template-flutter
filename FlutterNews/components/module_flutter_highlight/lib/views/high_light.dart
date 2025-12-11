import 'package:flutter/cupertino.dart';
import '../model/model.dart';
import 'package:module_flutter_highlight/constants/constants.dart';

class Highlight extends StatefulWidget {
  /// 高亮关键字
  final List<String> keywords;

  /// 源文本
  final String sourceString;
  // /**
  //  * 文字颜色 默认 sys.color.font_primary (黑色)
  //  */
  final Color textColor;
  // /**
  //  * 高亮文字颜色
  //  */
  final Color highLightColor;
  // /**
  //  * 文字大小
  //  */
  final double textFontSize;
  // /**
  //  * 高亮文本weight
  //  */
  final FontWeight textFontWeight;
  // /**
  //  * 高亮文字大小
  //  */
  final double highLightFontSize;
  // /**
  //  * 最大行数 (null表示不限制，0会报错)
  //  */
  final int? maxLines;
  // /**
  //  * 超出隐藏
  //  */
  final TextOverflow overflow;

  final double fontSizeRatio;

  const Highlight({
    super.key,
    this.keywords = const [],
    this.sourceString = "",
    this.textColor = Constants.Text_COLOR,
    this.highLightColor = Constants.HIGHLIGHTCOLOR,
    this.textFontSize = Constants.FONT_16,
    this.textFontWeight = FontWeight.normal,
    this.highLightFontSize = Constants.FONT_16,
    this.maxLines,
    this.overflow = TextOverflow.fade,
    this.fontSizeRatio = 1.0,
  });

  @override
  State<Highlight> createState() => _HighlightState();
}

class _HighlightState extends State<Highlight> {
  Chunks get highlightChunks {
    // 步骤1：通过关键词匹配生成初始高亮块
    Chunks initialChunks = [];

    // 过滤空关键词并遍历
    for (final keyword in widget.keywords.where((k) => k.isNotEmpty)) {
      // 转义正则表达式特殊字符
      final escapedKeyword = _escapeRegExp(keyword);
      // 创建全局匹配正则
      final regex = RegExp(escapedKeyword, multiLine: false);

      // 模拟TS的while(regex.exec)循环
      int lastIndex = 0;
      while (lastIndex < widget.sourceString.length) {
        // 从lastIndex开始查找匹配
        final match =
            regex.firstMatch(widget.sourceString.substring(lastIndex));
        if (match == null) break;

        // 计算实际索引（考虑substring的偏移）
        final start = lastIndex + match.start;
        var end = lastIndex + match.end;

        // 处理零宽度匹配，避免死循环
        if (start >= end) {
          lastIndex = end + 1;
          continue;
        }

        // 添加高亮块
        initialChunks.add(Chunk(
          start: start,
          end: end,
          highlight: true,
        ));

        // 更新lastIndex，继续下一次匹配
        lastIndex = end;
      }
    }

    // 步骤2：排序、合并块并插入非高亮块
    Chunks processedChunks = [];

    // 按start升序排序
    final sortedChunks = List<Chunk>.from(initialChunks)
      ..sort((a, b) => a.start.compareTo(b.start));

    // 处理每个块
    for (final currentChunk in sortedChunks) {
      final prevChunk =
          processedChunks.isNotEmpty ? processedChunks.last : null;

      if (prevChunk == null) {
        // 没有前序块：添加前置非高亮块和当前块
        _addNonHighlightChunk(processedChunks, 0, currentChunk.start);
        processedChunks.add(currentChunk);
      } else {
        if (currentChunk.start > prevChunk.end) {
          // 当前块与前序块不重叠：添加中间非高亮块和当前块
          _addNonHighlightChunk(
              processedChunks, prevChunk.end, currentChunk.start);
          processedChunks.add(currentChunk);
        } else {
          // 重叠块：合并（取最大end）
          prevChunk.end = currentChunk.end > prevChunk.end
              ? currentChunk.end
              : prevChunk.end;
        }
      }
    }

    // 步骤3：补充首尾非高亮块
    final lastChunk = processedChunks.isNotEmpty ? processedChunks.last : null;
    final sourceLength = widget.sourceString.length;

    if (lastChunk == null) {
      // 没有任何块：添加整个文本的非高亮块
      processedChunks.add(Chunk(
        start: 0,
        end: sourceLength,
        highlight: false,
      ));
    } else if (lastChunk.end < sourceLength) {
      // 最后一块未覆盖全部文本：补充末尾非高亮块
      processedChunks.add(Chunk(
        start: lastChunk.end,
        end: sourceLength,
        highlight: false,
      ));
    }

    return processedChunks;
  }

  void _addNonHighlightChunk(Chunks chunks, int start, int end) {
    if (start < end) {
      chunks.add(Chunk(
        start: start,
        end: end,
        highlight: false,
      ));
    }
  }

  String _escapeRegExp(String text) {
    const pattern = r'[.*+?^${}()|[\]\\]';
    return text.replaceAllMapped(
      RegExp(pattern),
      (match) => '\\${match.group(0)}',
    );
  }

  @override
  Widget build(BuildContext context) {
    List<TextSpan> textSpans = [];

    for (var chunk in highlightChunks) {
      String chunkText = widget.sourceString.substring(chunk.start, chunk.end);

      if (chunk.highlight) {
        textSpans.add(TextSpan(
          text: chunkText,
          style: TextStyle(
            color: widget.highLightColor,
            fontSize: widget.highLightFontSize * widget.fontSizeRatio,
            fontWeight: widget.textFontWeight,
          ),
        ));
      } else {
        textSpans.add(TextSpan(
          text: chunkText,
          style: TextStyle(
            color: widget.textColor,
            fontSize: widget.textFontSize * widget.fontSizeRatio,
            fontWeight: widget.textFontWeight,
          ),
        ));
      }
    }
    return RichText(
      text: TextSpan(
        children: textSpans,
        style: TextStyle(
          color: widget.textColor,
          fontSize: widget.textFontSize * widget.fontSizeRatio,
          fontWeight: widget.textFontWeight,
        ),
      ),
      maxLines: widget.maxLines,
      overflow: widget.overflow,
    );
  }
}
