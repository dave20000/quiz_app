import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:quiz_app/models/question.dart';
import 'package:quiz_app/models/result.dart';
import 'package:quiz_app/ui/screens/quiz/widgets/question_option.dart';
import 'package:quiz_app/ui/screens/quiz/widgets/questions_drawer.dart';
import 'package:quiz_app/ui/screens/quiz/widgets/quiz_bottom_button_bar.dart';
import 'package:quiz_app/ui/screens/quiz/widgets/submit_dialog.dart';
import 'package:quiz_app/ui/screens/quiz_result/quiz_result_screen.dart';
import 'package:quiz_app/ui/view_models/quiz.dart';
import 'package:quiz_app/ui/widgets/base_widget.dart';
import 'package:quiz_app/ui_helper.dart';

class QuizScreen extends StatefulWidget {
  final String testUrl;
  const QuizScreen({
    Key? key,
    required this.testUrl,
  }) : super(key: key);

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  Widget buildTime(QuizViewModel quizViewModel) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(quizViewModel.duration.inMinutes.remainder(60));
    final seconds = twoDigits(quizViewModel.duration.inSeconds.remainder(60));
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(
        minutes,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: 16,
        ),
      ),
      UIHelper.horizontalDividerExtraSmall(),
      const Text(
        ":",
        style: TextStyle(
            fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16),
      ),
      UIHelper.horizontalDividerExtraSmall(),
      Text(
        seconds,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: 16,
        ),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    var statusBarHeight = MediaQuery.of(context).padding.top;
    var appBarHeight = kToolbarHeight;
    return BaseWidget<QuizViewModel>(
      onModelReady: (quizViewModel) {
        quizViewModel.initData(widget.testUrl);
      },
      onDispose: (quizViewModel) {
        quizViewModel.dispose();
      },
      builder: (context, quizViewModel, _) {
        return WillPopScope(
          onWillPop: () async {
            testSubmitDialog(quizViewModel, context);
            return false;
          },
          child: Scaffold(
            backgroundColor: UIHelper.backgroundColor,
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: UIHelper.backgroundColor,
              elevation: 0,
              automaticallyImplyLeading: false,
              leading: IconButton(
                onPressed: () {
                  testSubmitDialog(quizViewModel, context);
                },
                icon: const Icon(
                  Icons.clear,
                  color: Colors.black,
                ),
              ),
              title: GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    )),
                    context: context,
                    builder: (context) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          UIHelper.verticalDivider(),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    width: 4,
                                    color: UIHelper.mainThemeColor,
                                  ),
                                ),
                                child: const Icon(Icons.pause),
                              ),
                              UIHelper.horizontalDivider(),
                              const Text(
                                "Submit Test",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          UIHelper.verticalDividerSmall(),
                          const Text(
                            "Are you sure you want to submit the test and exit?",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          UIHelper.verticalDividerSmall(),
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: UIHelper.mainThemeColor,
                                      onPrimary: Colors.white60,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      "Cancel",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: UIHelper.mainThemeColor,
                                      onPrimary: Colors.white60,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    onPressed: () async {
                                      await quizViewModel.submitQuiz(
                                          isDialogOrSheetOpen: true);
                                    },
                                    child: const Text(
                                      "Yes, Submit",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.timer_outlined,
                      color: Colors.black,
                      size: 16,
                    ),
                    UIHelper.verticalDividerExtraSmall(),
                    buildTime(quizViewModel),
                  ],
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    if (_scaffoldKey.currentState!.isDrawerOpen) {
                      Navigator.pop(context);
                    } else {
                      _scaffoldKey.currentState!.openEndDrawer();
                    }
                  },
                  icon: const Icon(
                    Icons.menu,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            drawerScrimColor: Colors.transparent,
            endDrawer: quizViewModel.isLoading
                ? const SizedBox()
                : QuestionsDrawer(
                    statusBarHeight: statusBarHeight,
                    appBarHeight: appBarHeight,
                    questions: quizViewModel.questions,
                    goToQuestion: (int questionPage) {
                      quizViewModel.pageController.animateToPage(
                        questionPage,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                      );
                    },
                    currentPageIndex: quizViewModel.currentPageIndex,
                    submitTest: () {
                      testSubmitDialog(quizViewModel, context);
                    },
                  ),
            key: _scaffoldKey,
            body: quizViewModel.isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: UIHelper.mainThemeColor,
                    ),
                  )
                : quizViewModel.questions.isEmpty
                    ? Center(
                        child: Text(
                          "Unable to load test plz exit",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: UIHelper.mainThemeColor,
                          ),
                        ),
                      )
                    : Stack(
                        children: [
                          PageView.builder(
                            onPageChanged: (pageNumber) {
                              quizViewModel.currentPageIndex = pageNumber;
                              quizViewModel.progressValue = (pageNumber + 1) /
                                  quizViewModel.questions.length;
                            },
                            physics: const BouncingScrollPhysics(),
                            controller: quizViewModel.pageController,
                            itemCount: quizViewModel.questions.length,
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
                                            borderRadius:
                                                BorderRadius.circular(8),
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
                                        UIHelper.horizontalDividerSmall(),
                                        if (quizViewModel.questions[index]
                                                .multipleCorrectAnswers ==
                                            "true")
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
                                            quizViewModel.questions[index]
                                                    .isMarkedForReview =
                                                quizViewModel.questions[index]
                                                            .isMarkedForReview ==
                                                        null
                                                    ? true
                                                    : !quizViewModel
                                                        .questions[index]
                                                        .isMarkedForReview!;
                                          },
                                          icon: quizViewModel.questions[index]
                                                  .isMarkedForReview!
                                              ? Icon(
                                                  Icons.bookmark,
                                                  color:
                                                      UIHelper.mainThemeColor,
                                                )
                                              : Icon(
                                                  Icons.bookmark_border,
                                                  color:
                                                      UIHelper.mainThemeColor,
                                                ),
                                        ),
                                      ],
                                    ),
                                    UIHelper.verticalDivider(),
                                    Expanded(
                                      child: SingleChildScrollView(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              quizViewModel.questions[index]
                                                      .question ??
                                                  "Unable to load que",
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 18,
                                              ),
                                              textAlign: TextAlign.left,
                                            ),
                                            UIHelper.verticalDivider(),
                                            for (int i = 0; i < 6; i++)
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 16),
                                                child: QuestionOption(
                                                  isSelected: quizViewModel
                                                              .questions[index]
                                                              .multipleCorrectAnswers ==
                                                          "false"
                                                      ? quizViewModel
                                                                  .questions[
                                                                      index]
                                                                  .selectedOption ==
                                                              i
                                                          ? true
                                                          : false
                                                      : quizViewModel
                                                              .questions[index]
                                                              .selectedOptions!
                                                              .contains(i)
                                                          ? true
                                                          : false,
                                                  selectOption: (int
                                                      selectedOptionNumber) {
                                                    if (quizViewModel
                                                            .questions[index]
                                                            .multipleCorrectAnswers ==
                                                        "false") {
                                                      quizViewModel
                                                              .questions[index]
                                                              .selectedOption =
                                                          selectedOptionNumber;
                                                    } else {
                                                      quizViewModel
                                                          .questions[index]
                                                          .selectedOptions!
                                                          .add(
                                                              selectedOptionNumber);
                                                    }
                                                    quizViewModel
                                                        .questions[index]
                                                        .isAnswered = true;
                                                  },
                                                  deSelectOption: (int
                                                      selectedOptionNumber) {
                                                    if (quizViewModel
                                                            .questions[index]
                                                            .multipleCorrectAnswers ==
                                                        "false") {
                                                      quizViewModel
                                                              .questions[index]
                                                              .selectedOption =
                                                          null;
                                                    } else {
                                                      quizViewModel
                                                          .questions[index]
                                                          .selectedOptions!
                                                          .remove(
                                                              selectedOptionNumber);
                                                    }
                                                    quizViewModel
                                                        .questions[index]
                                                        .isAnswered = false;
                                                  },
                                                  optionNumber: i,
                                                  optionValue: i == 0
                                                      ? quizViewModel
                                                          .questions[index]
                                                          .answers!
                                                          .answerA
                                                      : i == 1
                                                          ? quizViewModel
                                                              .questions[index]
                                                              .answers!
                                                              .answerB
                                                          : i == 2
                                                              ? quizViewModel
                                                                  .questions[
                                                                      index]
                                                                  .answers!
                                                                  .answerC
                                                              : i == 3
                                                                  ? quizViewModel
                                                                      .questions[
                                                                          index]
                                                                      .answers!
                                                                      .answerD
                                                                  : i == 4
                                                                      ? quizViewModel
                                                                          .questions[
                                                                              index]
                                                                          .answers!
                                                                          .answerE
                                                                      : quizViewModel
                                                                          .questions[
                                                                              index]
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
                            value: quizViewModel.progressValue,
                            backgroundColor: Colors.grey,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                UIHelper.mainThemeColor),
                          ),
                        ],
                      ),
            bottomNavigationBar: quizViewModel.isLoading
                ? const SizedBox()
                : QuizBottomButtonBar(
                    clearAnswer: () {
                      quizViewModel.questions[quizViewModel.currentPageIndex]
                          .selectedOption = null;
                      quizViewModel.questions[quizViewModel.currentPageIndex]
                          .selectedOptions = [];
                    },
                    markForReview: () {
                      quizViewModel.questions[quizViewModel.currentPageIndex]
                          .isMarkedForReview = true;

                      quizViewModel.pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                      );
                    },
                    saveAndNextQuestion: () {
                      if (quizViewModel.currentPageIndex ==
                          (quizViewModel.questions.length - 1)) {
                        testSubmitDialog(quizViewModel, context);
                      } else {
                        quizViewModel.pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                        );
                      }
                    },
                    btnText: quizViewModel.currentPageIndex ==
                            (quizViewModel.questions.length - 1)
                        ? "Submit"
                        : "Save & Next",
                  ),
          ),
        );
      },
    );
  }

  Future<dynamic> testSubmitDialog(
      QuizViewModel quizViewModel, BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => SubmitDialog(
        submitQuiz: () async =>
            await quizViewModel.submitQuiz(isDialogOrSheetOpen: true),
      ),
    );
  }
}
