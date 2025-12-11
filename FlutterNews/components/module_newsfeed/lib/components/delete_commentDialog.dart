import 'package:flutter/material.dart';
import 'package:module_newsfeed/constants/constants.dart';

class DeleteCommentDialog extends StatelessWidget {
  final VoidCallback onDelete; 
  final VoidCallback onCancel; 
  final String? title; 

  const DeleteCommentDialog({
    super.key,
    required this.onDelete,
    required this.onCancel,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white, 

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.SPACE_20),
      ),
      content: Text(
        title ?? "确定要删除此评论？",
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: Constants.FONT_18,
          fontWeight: FontWeight.normal,
        ),
      ),
      actions: [
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: (){
                  onCancel(); 
                },
                child: const Text(
                  '取消',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: Constants.FONT_16,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  onDelete(); 
                },
                child: const Text(
                  '确定',
                  style: TextStyle(
                    color: Constants.TEXT_COLOR,
                    fontSize: Constants.FONT_16,
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  static void show(BuildContext context, {required VoidCallback onDelete,required VoidCallback onCancel, String? title}) {
    showDialog(
      context: context,
      builder: (context) => DeleteCommentDialog(onDelete: onDelete,onCancel: onCancel,title: title,),
    );
  }
}
