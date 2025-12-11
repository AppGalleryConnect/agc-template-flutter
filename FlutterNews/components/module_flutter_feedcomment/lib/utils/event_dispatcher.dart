import '../model/model.dart';

class CommentEventDispatcher {
  static Function(CommentInfo, String)? addCommentCallback;
  static Function(CommentInfo, bool)? giveLikeCallback;
  static Function(String)? goUserHome;
  static Function(Function(bool))? interceptLogin;
  static Function(String)? deleteComment;

  static void dispatchToAddComment(
      CommentInfo commentInfo, String replyContent) {
    if (addCommentCallback != null) {
      addCommentCallback!(commentInfo, replyContent);
    }
  }

  static void dispatchToDeleteComment(String commentId) {
    if (deleteComment != null) {
      deleteComment!(commentId);
    }
  }

  static void dispatchToGiveLike(CommentInfo commentInfo, bool isLike) {
    if (giveLikeCallback != null) {
      giveLikeCallback!(commentInfo, isLike);
    }
  }

  static void dispatchToInterceptLogin(Function(bool) isLoginCb) {
    if (interceptLogin != null) {
      interceptLogin!(isLoginCb);
    }
  }

  static void dispatchToUserHome(String authorId) {
    if (goUserHome != null) {
      goUserHome!(authorId);
    }
  }
}
