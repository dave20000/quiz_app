import 'package:flutter/material.dart';
import 'package:quiz_app/ui_helper.dart';

class QuizBottomButtonBar extends StatelessWidget {
  final void Function() clearAnswer;
  final void Function() saveAndNextQuestion;
  final void Function() markForReview;
  final String btnText;
  const QuizBottomButtonBar({
    Key? key,
    required this.clearAnswer,
    required this.saveAndNextQuestion,
    required this.btnText,
    required this.markForReview,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.grey.withOpacity(0.5),
        //     spreadRadius: 0.5,
        //     blurRadius: 1,
        //     offset: const Offset(0, -1),
        //   ),
        // ],
        color: UIHelper.backgroundColor,
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          UIHelper.horizontalDividerSmall(),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.white,
              onPrimary: Colors.grey.shade300,
              side: const BorderSide(color: Colors.black, width: 1),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              clearAnswer();
            },
            child: Text(
              "Clear",
              style: TextStyle(
                color: UIHelper.mainThemeColor,
              ),
            ),
          ),
          UIHelper.horizontalDividerSmall(),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.white,
              onPrimary: Colors.grey.shade300,
              side: const BorderSide(color: Colors.black, width: 1),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              shadowColor: Colors.white,
            ),
            // padding: const EdgeInsets.all(8),
            // decoration: BoxDecoration(
            //     color: Colors.white,
            //     border: Border.all(
            //       width: 1,
            //       color: Colors.black,
            //     )),
            onPressed: () {
              markForReview();
            },

            child: Text(
              "Mark for Review",
              style: TextStyle(
                color: UIHelper.mainThemeColor,
              ),
            ),
          ),
          const Spacer(),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: UIHelper.mainThemeColor,
              onPrimary: Colors.white60,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              saveAndNextQuestion();
            },
            child: Text(
              btnText,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          UIHelper.horizontalDividerSmall(),
        ],
      ),
    );
  }
}
