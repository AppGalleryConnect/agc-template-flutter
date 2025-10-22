import 'package:flutter/material.dart';
import '../widgets/bar/custom_app_bar.dart';
import '../widgets/list/department_list.dart';
import '../widgets/bar/publish_search_bar.dart';
import '../widgets/list/question_list.dart';
import '../data/mock_data.dart';
import '../constants.dart';

// 问政
class AskGovQuestionPage extends StatelessWidget {
  const AskGovQuestionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: const CustomAppBar(title: "问政"),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 政务号横向滚动列表
            DepartmentList(
              accounts: MockData.accountItems,
              onMorePressed: () {
                Navigator.pushNamed(
                    context, AppConstants.selectDepartmentRoute);
              },
            ),
            // 发布和搜索组件
            PublishSearchBar(
              onSearchPressed: () {
                Navigator.pushNamed(context, AppConstants.searchRoute);
              },
            ),

            // 信息列表
            QuestionList(
              items: MockData.postItems,
              isScrollable: false,
            ),
          ],
        ),
      ),
    );
  }
}
