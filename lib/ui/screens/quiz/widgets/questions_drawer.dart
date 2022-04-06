import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_app/models/question.dart';
import 'package:quiz_app/ui/providers/quiz/quiz_provider.dart';
import 'package:quiz_app/ui_helper.dart';

class QuestionsDrawer extends ConsumerWidget {
  final double statusBarHeight;
  final double appBarHeight;
  final List<Question> questions;
  final void Function(int index) goToQuestion;
  final int currentPageIndex;
  final void Function() submitTest;

  const QuestionsDrawer({
    Key? key,
    required this.statusBarHeight,
    required this.appBarHeight,
    required this.questions,
    required this.goToQuestion,
    required this.currentPageIndex,
    required this.submitTest,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int questionsAnswered = 0;
    int questionsMarked = 0;
    int questionsNotAnswered = 0;
    for (var question in questions) {
      if (question.isAnswered == true) {
        questionsAnswered++;
      } else {
        questionsNotAnswered++;
      }
      if (question.isMarkedForReview == true) {
        questionsMarked++;
      }
    }
    return Container(
      padding: EdgeInsets.only(top: statusBarHeight + appBarHeight),
      child: Drawer(
        backgroundColor: UIHelper.backgroundColor,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Ink(
                    height: 36,
                    decoration: const BoxDecoration(
                      border: Border.symmetric(
                        horizontal: BorderSide(
                          color: Colors.blueGrey,
                          width: 1,
                        ),
                      ),
                    ),
                    child: InkWell(
                      onTap: () {
                        // if (!isListView) {
                        //   setState(() {
                        //     isListView = true;
                        //   });
                        // }
                        ref.read(isListViewProvider.notifier).state =
                            !ref.watch(isListViewProvider);
                      },
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.list_outlined),
                            UIHelper.horizontalDividerExtraSmall(),
                            const Text(
                              "List View",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Ink(
                    height: 36,
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.blueGrey,
                          width: 1,
                        ),
                        top: BorderSide(
                          color: Colors.blueGrey,
                          width: 1,
                        ),
                        left: BorderSide(
                          color: Colors.blueGrey,
                          width: 1,
                        ),
                      ),
                    ),
                    child: InkWell(
                      onTap: () {
                        // if (isListView) {
                        //   setState(() {
                        //     isListView = false;
                        //   });
                        // }

                        ref.read(isListViewProvider.notifier).state =
                            !ref.watch(isListViewProvider);
                      },
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.grid_view_outlined),
                            UIHelper.horizontalDividerExtraSmall(),
                            const Text(
                              "Grid View",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            UIHelper.verticalDividerExtraSmall(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    const Text(
                      "Answered",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                    UIHelper.horizontalDividerExtraSmall(),
                    Row(
                      children: [
                        Container(
                          height: 24,
                          width: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: UIHelper.questionAnsweredColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        UIHelper.horizontalDividerSmall(),
                        Text(
                          questionsAnswered.toString(),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text(
                      "Marked",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                    UIHelper.verticalDividerExtraSmall(),
                    Row(
                      children: [
                        Container(
                          height: 24,
                          width: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: UIHelper.questionMarkedColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        UIHelper.horizontalDividerSmall(),
                        Text(
                          questionsMarked.toString(),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text(
                      "Not Answered",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                    UIHelper.verticalDividerExtraSmall(),
                    Row(
                      children: [
                        Container(
                          height: 24,
                          width: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              width: 3,
                              color: UIHelper.questionNotAnsweredBorderColor,
                            ),
                          ),
                        ),
                        UIHelper.horizontalDividerSmall(),
                        Text(
                          questionsNotAnswered.toString(),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            UIHelper.verticalDivider(),
            Expanded(
              child: !ref.watch(isListViewProvider)
                  ? GridView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: questions.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                        crossAxisSpacing: 16.0,
                        mainAxisSpacing: 12.0,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            goToQuestion(index);
                            //ToDo: Isko uncomment karna hai
                            // Navigator.pop(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: questions[index].isMarkedForReview!
                                  ? UIHelper.questionMarkedColor
                                  : questions[index].isAnswered!
                                      ? UIHelper.questionAnsweredColor
                                      : UIHelper.questionNotAnsweredColor,
                              borderRadius: BorderRadius.circular(8),
                              border: !questions[index].isAnswered! &&
                                      !questions[index].isMarkedForReview!
                                  ? Border.all(
                                      width: 4,
                                      color: UIHelper
                                          .questionNotAnsweredBorderColor,
                                    )
                                  : const Border(),
                            ),
                            child: Center(
                              child: Text(
                                "${index + 1}",
                                style: TextStyle(
                                  color: questions[index].isMarkedForReview!
                                      ? Colors.black
                                      : questions[index].isAnswered!
                                          ? Colors.white
                                          : Colors.black,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemCount: questions.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            goToQuestion(index);
                            //ToDo: Isko uncomment karna hai
                            // Navigator.pop(context);
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 12,
                            ),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              border: currentPageIndex == index
                                  ? Border.all(
                                      color: UIHelper.mainThemeColor,
                                      width: 3,
                                    )
                                  : null,
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  height: 32,
                                  width: 32,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    color: questions[index].isMarkedForReview!
                                        ? UIHelper.questionMarkedColor
                                        : questions[index].isAnswered!
                                            ? UIHelper.questionAnsweredColor
                                            : UIHelper.questionNotAnsweredColor,
                                    borderRadius: BorderRadius.circular(8),
                                    border: !questions[index].isAnswered! &&
                                            !questions[index].isMarkedForReview!
                                        ? Border.all(
                                            width: 4,
                                            color: UIHelper
                                                .questionNotAnsweredBorderColor,
                                          )
                                        : const Border(),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "${index + 1}",
                                      style: TextStyle(
                                        color:
                                            questions[index].isMarkedForReview!
                                                ? Colors.black
                                                : questions[index].isAnswered!
                                                    ? Colors.white
                                                    : Colors.black,
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                UIHelper.horizontalDividerExtraSmall(),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      questions[index].question!,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              child: Ink(
                width: MediaQuery.of(context).size.width,
                height: 48,
                decoration: BoxDecoration(
                  color: UIHelper.mainThemeColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    submitTest();
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: const Center(
                    child: Text(
                      "Submit Test",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  splashColor: Colors.white10,
                ),
              ),
            ),
          ],
        ),
      ), //write your drawer code
    );
  }
}
