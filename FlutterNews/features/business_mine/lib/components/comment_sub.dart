import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lib_common/constants/common_constants.dart';
import 'package:lib_common/utils/router_utils.dart';
import 'package:lib_common/constants/router_map.dart';
import 'package:lib_common/utils/time_utils.dart';
import 'package:lib_news_api/observedmodels/comment_model.dart';

class CommentSub extends StatefulWidget {
  final CommentModel data;
  final Color bgColor;
  final double fontSizeRatio;
  final VoidCallback onReply;

  const CommentSub({
    super.key,
    required this.data,
    this.bgColor = Colors.transparent,
    this.fontSizeRatio = 1.0,
    required this.onReply,
  });

  @override
  State<CommentSub> createState() => _CommentSubState();
}

class _CommentSubState extends State<CommentSub> {
  late Color _bgColor;

  @override
  void initState() {
    super.initState();
    _bgColor = widget.bgColor;
    resetBg();
  }

  void resetBg() {
    Timer(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _bgColor = Colors.transparent;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _bgColor,
      padding: const EdgeInsets.only(
        left: CommonConstants.PADDING_PAGE,
        right: CommonConstants.PADDING_PAGE,
        top: CommonConstants.PADDING_M,
        bottom: CommonConstants.PADDING_M,
      ),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  RouterUtils.of.pushPathByName(RouterMap.PROFILE_HOME,
                      param: widget.data.author?.authorId ?? '');
                },
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundImage: widget.data.author?.authorIcon != null
                          ? NetworkImage(widget.data.author!.authorIcon)
                          : null,
                      child: widget.data.author?.authorIcon == null
                          ? Text(
                              widget.data.author?.authorNickName != null
                                  ? widget.data.author!.authorNickName
                                      .substring(0, 1)
                                  : '',
                              style: const TextStyle(fontSize: 12),
                            )
                          : null,
                    ),
                    const SizedBox(width: CommonConstants.SPACE_S),
                    Text(
                      widget.data.author?.authorNickName ?? '',
                      style: TextStyle(
                        fontSize: 12 * widget.fontSizeRatio,
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                    ),
                  ],
                ),
              ),
              // 评论时间
              Text(
                TimeUtils.getDateDiff(widget.data.createTime),
                style: TextStyle(
                  fontSize: 10 * widget.fontSizeRatio,
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
              ),
            ],
          ),

          // 评论内容
          Padding(
            padding: const EdgeInsets.only(left: CommonConstants.PADDING_XXL),
            child: Text(
              widget.data.commentBody,
              style: TextStyle(
                fontSize: 14 * widget.fontSizeRatio,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ),

          // 引用评论
          if (widget.data.parentComment != null)
            Padding(
              padding: const EdgeInsets.only(left: CommonConstants.PADDING_XXL),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(CommonConstants.RADIUS_M),
                ),
                padding: const EdgeInsets.all(CommonConstants.PADDING_S),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '@',
                      style: TextStyle(
                        fontSize: 10 * widget.fontSizeRatio,
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                    ),
                    Text(
                      widget.data.parentComment?.author?.authorNickName ?? '',
                      style: TextStyle(
                        fontSize: 10 * widget.fontSizeRatio,
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                    ),
                    Text(
                      ': ',
                      style: TextStyle(
                        fontSize: 10 * widget.fontSizeRatio,
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        widget.data.parentComment?.commentBody ?? '',
                        style: TextStyle(
                          fontSize: 10 * widget.fontSizeRatio,
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // 回复按钮
          Padding(
            padding: const EdgeInsets.only(left: CommonConstants.PADDING_XXL),
            child: GestureDetector(
              onTap: widget.onReply,
              child: Text(
                '回复',
                style: TextStyle(
                  fontSize: 10 * widget.fontSizeRatio,
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
