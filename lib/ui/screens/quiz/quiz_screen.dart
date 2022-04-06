import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_app/models/question.dart';

import 'package:quiz_app/models/result.dart';
import 'package:quiz_app/ui/providers/quiz/quiz_provider.dart';
import 'package:quiz_app/ui/providers/quiz/quiz_states.dart';
import 'package:quiz_app/ui/screens/quiz_result/quiz_result_screen.dart';
import 'package:quiz_app/ui_helper.dart';

import 'widgets/quiz_question.dart';
import 'widgets/questions_drawer.dart';
import 'widgets/quiz_bottom_button_bar.dart';
import 'widgets/submit_dialog.dart';

class QuizScreen extends ConsumerStatefulWidget {
  const QuizScreen({
    Key? key,
    required this.quizUrl,
  }) : super(key: key);

  final String quizUrl;

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  // static const countdownDuration = Duration(minutes: 20);
  // static const countDown = true;

  PageController pageController = PageController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    ref.read(quizProvider.notifier).fetchQuiz(widget.quizUrl);
  }

  // Timer? timer;

  // List<Question>? questions;

  // void startTimer() {
  //   timer = Timer.periodic(const Duration(seconds: 1), (_) => addTime());
  // }

  // void addTime() async {
  //   const addSeconds = countDown ? -1 : 1;
  //   setState(() {
  //     final seconds = ref.watch(durationProvider).inSeconds + addSeconds;
  //     if (seconds < 0) {
  //       timer?.cancel();
  //     } else {
  //       ref.read(durationProvider.notifier).state = Duration(seconds: seconds);
  //     }
  //   });
  //   if (!timer!.isActive) {
  //     // await submitQuiz(questions: questions!, isDialogOrSheetOpen: false);
  //   }
  // }

  // @override
  // void dispose() {
  //   pageController.dispose();
  //   if (timer != null) timer!.cancel();
  //   super.dispose();
  // }

  // void reset() {
  //   if (countDown) {
  //     ref.read(durationProvider.notifier).state = countdownDuration;
  //   } else {
  //     ref.read(durationProvider.notifier).state = const Duration();
  //   }
  // }

  submitTestBottomSheet(BuildContext context, List<Question> questions) async {
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
            UIHelper.verticalDivider,
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
                UIHelper.horizontalDivider,
                const Text(
                  "Submit Test",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            UIHelper.verticalDividerSmall,
            const Text(
              "Are you sure you want to submit the test and exit?",
              style: TextStyle(
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            UIHelper.verticalDividerSmall,
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
                        await submitQuiz(
                            questions: questions, isDialogOrSheetOpen: true);
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
  }

  Future<dynamic> testSubmitDialog(
      List<Question> questions, BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => SubmitDialog(
        submitQuiz: () async =>
            await submitQuiz(questions: questions, isDialogOrSheetOpen: true),
      ),
    );
  }

  Future<void> submitQuiz(
      {required List<Question> questions,
      required bool isDialogOrSheetOpen}) async {
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

  // Widget buildTime() {
  //   String twoDigits(int n) => n.toString().padLeft(2, '0');
  //   final minutes =
  //       twoDigits(ref.watch(durationProvider).inMinutes.remainder(60));
  //   final seconds =
  //       twoDigits(ref.watch(durationProvider).inSeconds.remainder(60));
  //   return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
  //     Text(
  //       minutes,
  //       style: const TextStyle(
  //         fontWeight: FontWeight.bold,
  //         color: Colors.black,
  //         fontSize: 16,
  //       ),
  //     ),
  //     UIHelper.horizontalDividerExtraSmall(),
  //     const Text(
  //       ":",
  //       style: TextStyle(
  //           fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16),
  //     ),
  //     UIHelper.horizontalDividerExtraSmall(),
  //     Text(
  //       seconds,
  //       style: const TextStyle(
  //         fontWeight: FontWeight.bold,
  //         color: Colors.black,
  //         fontSize: 16,
  //       ),
  //     ),
  //   ]);
  // }

  @override
  Widget build(BuildContext context) {
    final quizState = ref.watch(quizProvider);
    final quizNotifier = ref.watch(quizProvider.notifier);

    // quizNotifier.fetchQuiz(widget.quizUrl);

    // reset();

    final questions = quizState.maybeWhen(
        data: (questions) {
          // startTimer();
          return questions;
        },
        orElse: () => null);

    var statusBarHeight = MediaQuery.of(context).padding.top;
    var appBarHeight = kToolbarHeight;
    return WillPopScope(
      onWillPop: () async {
        testSubmitDialog(questions!, context);
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
              testSubmitDialog(questions!, context);
            },
            icon: const Icon(
              Icons.clear,
              color: Colors.black,
            ),
          ),
          title: GestureDetector(
            onTap: () async {
              await submitTestBottomSheet(context, questions!);
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(
                  Icons.timer_outlined,
                  color: Colors.black,
                  size: 16,
                ),
                UIHelper.verticalDividerExtraSmall,
                // buildTime(),
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
        endDrawer: quizState.isLoading
            ? const SizedBox()
            : QuestionsDrawer(
                statusBarHeight: statusBarHeight,
                appBarHeight: appBarHeight,
                questions: questions!,
                goToQuestion: (int questionPage) {
                  pageController.animateToPage(
                    questionPage,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                  );
                },
                currentPageIndex: ref.watch(quizPageProvider),
                submitTest: () {
                  testSubmitDialog(questions, context);
                },
              ),
        key: _scaffoldKey,
        body: questions != null
            ? questions.isEmpty
                ? const Center(
                    child: Text("No Questions Found"),
                  )
                // : quizQuestion(questions)
                : QuizQuestion(pageController: pageController)
            : const Center(
                child: CircularProgressIndicator(
                  color: UIHelper.mainThemeColor,
                ),
              ),
        // quizState.when(
        //   data: (questionList) => quizQuestion(questionList),
        //   initial: () => Center(
        //     child: CircularProgressIndicator(
        //       color: UIHelper.mainThemeColor,
        //     ),
        //   ),
        //   loading: () => Center(
        //     child: CircularProgressIndicator(
        //       color: UIHelper.mainThemeColor,
        //     ),
        //   ),
        //   error: (msg) => Center(
        //     child: Text(msg!),
        //   ),
        // ),
        bottomNavigationBar: quizState.isLoading
            ? const SizedBox()
            : QuizBottomButtonBar(
                clearAnswer: () {
                  quizNotifier.clearAnswer(ref.watch(quizPageProvider));
                },
                markForReview: () {
                  quizNotifier.markForReview(ref.watch(quizPageProvider), true);
                  pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                  );
                },
                saveAndNextQuestion: () {
                  if (ref.watch(quizPageProvider) == (questions!.length - 1)) {
                    testSubmitDialog(questions, context);
                  } else {
                    pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                    );
                  }
                },
                btnText: ref.watch(quizPageProvider) == (questions!.length - 1)
                    ? "Submit"
                    : "Save & Next",
              ),
      ),
    );
  }
}
