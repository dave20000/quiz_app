import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_app/providers/quiz/quiz_provider.dart';
import 'package:quiz_app/ui_helper.dart';

import 'question_option.dart';

class QuizQuestion extends ConsumerWidget {
  final PageController pageController;

  const QuizQuestion({
    Key? key,
    required this.pageController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questions = ref.watch(quizProvider.notifier).questionList;

    return Stack(
      children: [
        PageView.builder(
          onPageChanged: (pageNumber) {
            ref.read(quizPageProvider.notifier).state = pageNumber;
          },
          physics: const BouncingScrollPhysics(),
          controller: pageController,
          itemCount: questions.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: UIHelper.mainThemeColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "${index + 1}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      UIHelper.horizontalDividerSmall,
                      if (questions[index].multipleCorrectAnswers == "true")
                        const Text(
                          "Multiple Choice",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          ref.watch(quizProvider.notifier).markForReview(
                              index,
                              questions[index].isMarkedForReview == null
                                  ? true
                                  : !questions[index].isMarkedForReview!);
                        },
                        icon: questions[index].isMarkedForReview!
                            ? const Icon(
                                Icons.bookmark,
                                color: UIHelper.mainThemeColor,
                              )
                            : const Icon(
                                Icons.bookmark_border,
                                color: UIHelper.mainThemeColor,
                              ),
                      ),
                    ],
                  ),
                  UIHelper.verticalDivider,
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            questions[index].question ?? "Unable to load que",
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          UIHelper.verticalDivider,
                          for (int i = 0; i < 6; i++)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: QuestionOption(
                                isSelected:
                                    questions[index].multipleCorrectAnswers ==
                                            "false"
                                        ? questions[index].selectedOption == i
                                            ? true
                                            : false
                                        : questions[index]
                                                .selectedOptions!
                                                .contains(i)
                                            ? true
                                            : false,
                                selectOption: (int selectedOptionNumber) {
                                  final quizNotifier =
                                      ref.watch(quizProvider.notifier);
                                  if (questions[index].multipleCorrectAnswers ==
                                      "false") {
                                    quizNotifier.answerQuestion(
                                        index, selectedOptionNumber);
                                  } else {
                                    quizNotifier.answerMultipleChoiceQuestion(
                                        index, selectedOptionNumber);
                                  }
                                },
                                deSelectOption: (int selectedOptionNumber) {
                                  final quizNotifier =
                                      ref.watch(quizProvider.notifier);
                                  if (questions[index].multipleCorrectAnswers ==
                                      "false") {
                                    quizNotifier.removeAnswer(index);
                                  } else {
                                    quizNotifier.removeMultipleChoiceAnswer(
                                        index, selectedOptionNumber);
                                  }
                                },
                                optionNumber: i,
                                optionValue: i == 0
                                    ? questions[index].answers!.answerA
                                    : i == 1
                                        ? questions[index].answers!.answerB
                                        : i == 2
                                            ? questions[index].answers!.answerC
                                            : i == 3
                                                ? questions[index]
                                                    .answers!
                                                    .answerD
                                                : i == 4
                                                    ? questions[index]
                                                        .answers!
                                                        .answerE
                                                    : questions[index]
                                                        .answers!
                                                        .answerF,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        LinearProgressIndicator(
          value: ref.watch(progressProvider),
          backgroundColor: Colors.grey,
          valueColor:
              const AlwaysStoppedAnimation<Color>(UIHelper.mainThemeColor),
        ),
      ],
    );
  }
}
