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
  PageController pageController = PageController();

  late List<Question> questions;

  double progressValue = 0.1;

  bool isLoading = false;

  static const countdownDuration = Duration(minutes: 20);
  Duration duration = const Duration();
  Timer? timer;

  bool countDown = true;

  @override
  void initState() {
    questions = [];
    fetchQuestions();
    reset();
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    if (timer != null) timer!.cancel();
    super.dispose();
  }

  Future<void> fetchQuestions() async {
    setState(() {
      isLoading = true;
    });
    try {
      var response = await http.get(
        Uri.parse(
          widget.testUrl,
        ),
      );
      if (response.statusCode == 200) {
        var questionsJson = jsonDecode(response.body) as List;
        List<Question> questionList = [];
        for (var questionJson in questionsJson) {
          questionList.add(Question.fromMap(questionJson));
        }
        setState(() {
          questions = questionList;
        });
      } else {
        setState(() {
          questions = [];
        });
      }
    } catch (e) {
      print(e.toString());
      setState(() {
        questions = [];
      });
    }
    startTimer();

    setState(() {
      isLoading = false;
    });
  }

  void reset() {
    if (countDown) {
      setState(() => duration = countdownDuration);
    } else {
      setState(() => duration = const Duration());
    }
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) => addTime());
  }

  void addTime() async {
    final addSeconds = countDown ? -1 : 1;
    setState(() {
      final seconds = duration.inSeconds + addSeconds;
      if (seconds < 0) {
        timer?.cancel();
      } else {
        duration = Duration(seconds: seconds);
      }
    });
    if (!timer!.isActive) {
      await submitQuiz(isDialogOrSheetOpen: false);
    }
  }

  int currentPageIndex = 0;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  Widget buildTime() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
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
    return WillPopScope(
      onWillPop: () async {
        testSubmitDialog(context);
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
              testSubmitDialog(context);
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
                                  await submitQuiz(isDialogOrSheetOpen: true);
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
                buildTime(),
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
        endDrawer: isLoading
            ? const SizedBox()
            : QuestionsDrawer(
                statusBarHeight: statusBarHeight,
                appBarHeight: appBarHeight,
                questions: questions,
                goToQuestion: (int questionPage) {
                  pageController.animateToPage(
                    questionPage,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                  );
                },
                currentPageIndex: currentPageIndex,
                submitTest: () {
                  testSubmitDialog(context);
                },
              ),
        key: _scaffoldKey,
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: UIHelper.mainThemeColor,
                ),
              )
            : questions.isEmpty
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
                          setState(() {
                            currentPageIndex = pageNumber;
                            progressValue = (pageNumber + 1) / questions.length;
                          });
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
                                    UIHelper.horizontalDividerSmall(),
                                    if (questions[index]
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
                                        setState(() {
                                          questions[index].isMarkedForReview =
                                              questions[index]
                                                          .isMarkedForReview ==
                                                      null
                                                  ? true
                                                  : !questions[index]
                                                      .isMarkedForReview!;
                                        });
                                      },
                                      icon: questions[index].isMarkedForReview!
                                          ? Icon(
                                              Icons.bookmark,
                                              color: UIHelper.mainThemeColor,
                                            )
                                          : Icon(
                                              Icons.bookmark_border,
                                              color: UIHelper.mainThemeColor,
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
                                          questions[index].question ??
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
                                              isSelected: questions[index]
                                                          .multipleCorrectAnswers ==
                                                      "false"
                                                  ? questions[index]
                                                              .selectedOption ==
                                                          i
                                                      ? true
                                                      : false
                                                  : questions[index]
                                                          .selectedOptions!
                                                          .contains(i)
                                                      ? true
                                                      : false,
                                              selectOption:
                                                  (int selectedOptionNumber) {
                                                if (questions[index]
                                                        .multipleCorrectAnswers ==
                                                    "false") {
                                                  setState(() {
                                                    questions[index]
                                                            .selectedOption =
                                                        selectedOptionNumber;
                                                  });
                                                } else {
                                                  setState(() {
                                                    questions[index]
                                                        .selectedOptions!
                                                        .add(
                                                            selectedOptionNumber);
                                                  });
                                                }
                                                setState(() {
                                                  questions[index].isAnswered =
                                                      true;
                                                });
                                              },
                                              deSelectOption:
                                                  (int selectedOptionNumber) {
                                                if (questions[index]
                                                        .multipleCorrectAnswers ==
                                                    "false") {
                                                  setState(() {
                                                    questions[index]
                                                        .selectedOption = null;
                                                  });
                                                } else {
                                                  setState(() {
                                                    questions[index]
                                                        .selectedOptions!
                                                        .remove(
                                                            selectedOptionNumber);
                                                  });
                                                }
                                                setState(() {
                                                  questions[index].isAnswered =
                                                      false;
                                                });
                                              },
                                              optionNumber: i,
                                              optionValue: i == 0
                                                  ? questions[index]
                                                      .answers!
                                                      .answerA
                                                  : i == 1
                                                      ? questions[index]
                                                          .answers!
                                                          .answerB
                                                      : i == 2
                                                          ? questions[index]
                                                              .answers!
                                                              .answerC
                                                          : i == 3
                                                              ? questions[index]
                                                                  .answers!
                                                                  .answerD
                                                              : i == 4
                                                                  ? questions[
                                                                          index]
                                                                      .answers!
                                                                      .answerE
                                                                  : questions[
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
                        value: progressValue,
                        backgroundColor: Colors.grey,
                        valueColor: AlwaysStoppedAnimation<Color>(
                            UIHelper.mainThemeColor),
                      ),
                    ],
                  ),
        bottomNavigationBar: isLoading
            ? const SizedBox()
            : QuizBottomButtonBar(
                clearAnswer: () {
                  setState(() {
                    questions[currentPageIndex].selectedOption = null;
                    questions[currentPageIndex].selectedOptions = [];
                  });
                },
                markForReview: () {
                  setState(() {
                    questions[currentPageIndex].isMarkedForReview = true;
                  });
                  pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                  );
                },
                saveAndNextQuestion: () {
                  if (currentPageIndex == (questions.length - 1)) {
                    testSubmitDialog(context);
                  } else {
                    pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                    );
                  }
                },
                btnText: currentPageIndex == (questions.length - 1)
                    ? "Submit"
                    : "Save & Next",
              ),
      ),
    );
  }

  Future<dynamic> testSubmitDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => SubmitDialog(
        submitQuiz: () async => await submitQuiz(isDialogOrSheetOpen: true),
      ),
    );
  }

  Future<void> submitQuiz({required bool isDialogOrSheetOpen}) async {
    int correctAnswerNumber = 0;
    int incorrectAnswerNumber = 0;
    int unAnswered = 0;
    double score = 0.0;
    Result result;
    for (var question in questions) {
      if (question.isAnswered!) {
        List<String> answersSelected = [];
        if (question.selectedOption == 0) {
          answersSelected.add("true");
        } else {
          answersSelected.add("false");
        }
        if (question.selectedOption == 1) {
          answersSelected.add("true");
        } else {
          answersSelected.add("false");
        }
        if (question.selectedOption == 2) {
          answersSelected.add("true");
        } else {
          answersSelected.add("false");
        }
        if (question.selectedOption == 3) {
          answersSelected.add("true");
        } else {
          answersSelected.add("false");
        }
        if (question.selectedOption == 4) {
          answersSelected.add("true");
        } else {
          answersSelected.add("false");
        }
        if (question.selectedOption == 5) {
          answersSelected.add("true");
        } else {
          answersSelected.add("false");
        }

        if (question.correctAnswers!.answerACorrect == answersSelected[0] &&
            question.correctAnswers!.answerBCorrect == answersSelected[1] &&
            question.correctAnswers!.answerCCorrect == answersSelected[2] &&
            question.correctAnswers!.answerDCorrect == answersSelected[3] &&
            question.correctAnswers!.answerECorrect == answersSelected[4] &&
            question.correctAnswers!.answerFCorrect == answersSelected[5]) {
          correctAnswerNumber++;
        } else {
          incorrectAnswerNumber++;
        }
      } else {
        unAnswered++;
      }
    }
    score = (correctAnswerNumber / (questions.length)) * 100;
    result = Result(
      correctAnswers: correctAnswerNumber,
      incorrectAnswers: incorrectAnswerNumber,
      unAnswered: unAnswered,
      questions: questions,
      score: score,
    );

    if (isDialogOrSheetOpen) Navigator.pop(context);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => QuizResultScreen(
          result: result,
        ),
      ),
    );
  }
}
