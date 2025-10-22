import 'package:flutter/material.dart';
import 'account_model.dart';

// 发布模型：用于构建政务信息、新闻信息
class PostModel {
  final String id;
  final AccountModel account;
  final String category;
  final String title;
  final String content;
  final DateTime publishTime;
  final String? replyText;
  final DateTime? replyTime;
  final bool isReplied;
  final String? image;

  PostModel({
    required this.id,
    required this.account,
    this.category = '默认类别',
    required this.title,
    required this.content,
    required this.publishTime,
    this.replyText,
    this.replyTime,
    this.isReplied = false,
    this.image,
  });

  // 高亮标记方法
  List<TextSpan> highlightText(
      String text, String? keyword, TextStyle textStyle) {
    if (keyword == null || keyword.isEmpty) {
      return [TextSpan(text: text)];
    }

    final List<TextSpan> spans = [];
    final String lowerText = text.toLowerCase();
    final String lowerKeyword = keyword.toLowerCase();

    int start = 0;
    while (true) {
      final int index = lowerText.indexOf(lowerKeyword, start);
      if (index == -1) {
        if (start < text.length) {
          spans.add(TextSpan(
            text: text.substring(start),
            style: textStyle,
            // style: const TextStyle(color: Colors.black87),
          ));
        }
        break;
      }

      // 非匹配部分
      if (index > start) {
        spans.add(TextSpan(
          text: text.substring(start, index),
          style: const TextStyle(color: Colors.black87),
        ));
      }

      // 匹配部分（红色高亮）
      spans.add(TextSpan(
        text: text.substring(index, index + keyword.length),
        style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
      ));

      start = index + keyword.length;
    }

    return spans;
  }
}
