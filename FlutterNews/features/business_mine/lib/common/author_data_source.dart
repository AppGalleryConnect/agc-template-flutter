import 'package:lib_news_api/observedmodels/author_model.dart';

class AuthorDataSource {
  Future<List<AuthorModel>> getAuthorList() async {
    return [];
  }

  Future<AuthorModel?> getAuthorById(String authorId) async {
    return null;
  }

  Future<bool> updateAuthorInfo(AuthorModel author) async {
    return true;
  }
}
