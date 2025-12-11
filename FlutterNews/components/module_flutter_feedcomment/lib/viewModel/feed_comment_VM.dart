import 'package:flutter/material.dart';
import '../model/model.dart';
import '../utils/event_dispatcher.dart';

class FeedCommentVM extends ChangeNotifier {
  static FeedCommentVM? _instance;

  double fontSizeRatio = 1.0;
  bool isDark = false;
  AuthorInfo author = AuthorInfo();

  CommentInfo commentDetailInfo = CommentInfo();

  FeedCommentVM._internal();

  static FeedCommentVM get instance {
    _instance ??= FeedCommentVM._internal();
    return _instance!;
  }

  void addComment(CommentInfo commentInfo, String replyContent) {
    CommentEventDispatcher.dispatchToAddComment(commentInfo, replyContent);
    notifyListeners();
  }

  void deleteComment(String commentId) {
    CommentEventDispatcher.dispatchToDeleteComment(commentId);
    notifyListeners();
  }

  void setFontSizeRatio(double fontSizeRatio) {
    this.fontSizeRatio = fontSizeRatio;
    notifyListeners();
  }

  void setIsDark(bool isDark) {
    this.isDark = isDark;
    notifyListeners();
  }

  void setAuthor(AuthorInfo author) {
    this.author = author;
    notifyListeners();
  }

  void giveLike(CommentInfo commentInfo, bool isLike) {
    CommentEventDispatcher.dispatchToGiveLike(commentInfo, isLike);
    notifyListeners();
  }

  void updateCommentDetailInfo(List<CommentInfo> list) {
    int i = 0;
    for (CommentInfo element in list) {
      if (element.commentId == commentDetailInfo.commentId) {
        i++;
      }
    }
    if (i == 0 && commentDetailInfo.commentId != '') {
      commentDetailInfo = CommentInfo();
      notifyListeners();
    }
  }
}
