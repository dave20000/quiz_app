import 'package:flutter/material.dart';
import 'package:quiz_app/ui_helper.dart';

class SubmitDialog extends StatefulWidget {
  final Future<void> Function() submitQuiz;
  const SubmitDialog({
    Key? key,
    required this.submitQuiz,
  }) : super(key: key);

  @override
  State<SubmitDialog> createState() => _SubmitDialogState();
}

class _SubmitDialogState extends State<SubmitDialog> {
  bool isSubmiting = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => !isSubmiting,
      child: AlertDialog(
        title: const Text('Submit Test'),
        titleTextStyle: TextStyle(
          color: UIHelper.mainThemeColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        content: const Text("Are you sure you want to submit the test?"),
        contentTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.normal,
        ),
        titlePadding:
            const EdgeInsets.only(left: 16, top: 16, right: 16, bottom: 8),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        actionsPadding: EdgeInsets.zero,
        actions: <Widget>[
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.white,
              onPrimary: Colors.grey.shade300,
              elevation: 0,
              shadowColor: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: UIHelper.mainThemeColor,
              onPrimary: Colors.white60,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () async {
              setState(() {
                isSubmiting = true;
              });
              // await Future.delayed(const Duration(seconds: 2));
              await widget.submitQuiz();
              setState(() {
                isSubmiting = false;
              });
            },
            child: isSubmiting
                ? CircularProgressIndicator(
                    color: UIHelper.mainThemeColor,
                  )
                : const Text(
                    'Yes',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
