import 'package:flutter/material.dart';
import 'package:module_feedback/common/constants.dart';
import '../common/feedback_model.dart';
import '../pages/submit_page.dart';

class Sample1 extends StatelessWidget {
  final FeedbackModel feedbackModel = FeedbackModel();

  Sample1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Constants.SPACE_16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              '意见反馈',
              style: TextStyle(
                fontSize: Constants.FONT_20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SubmitPage(),
                    ),
                  );
                },
                child: const Text('跳转'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
