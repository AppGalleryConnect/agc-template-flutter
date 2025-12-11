import 'package:flutter/foundation.dart';

class SearchHistory with ChangeNotifier {
  final List<String> _historyList = [];
  List<String> get historyList => List.unmodifiable(_historyList);
}
