import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quiz_app/models/question.dart';
import 'package:http/http.dart' as http;
import 'package:quiz_app/models/result.dart';
import 'package:quiz_app/ui/screens/quiz_result/quiz_result_screen.dart';

class QuizViewModel extends ChangeNotifier {
  PageController pageController = PageController();

  int _currentPageIndex = 0;
  int get currentPageIndex => _currentPageIndex;
  set currentPageIndex(int value) {
    _currentPageIndex = value;
    notifyListeners();
  }

  List<Question> _questions = [];
  List<Question> get questions => _questions;
  set questions(List<Question> value) {
    _questions = value;
    notifyListeners();
  }

  double _progressValue = 0.1;
  double get progressValue => _progressValue;
  set progressValue(double val) {
    _progressValue = val;
    notifyListeners();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  static const countdownDuration = Duration(minutes: 20);

  Duration _duration = const Duration();
  Duration get duration => _duration;
  set duration(Duration value) {
    _duration = value;
    notifyListeners();
  }

  Timer? _timer;
  Timer? get timer => _timer;
  set timer(Timer? value) {
    _timer = value;
    notifyListeners();
  }

  bool _countDown = true;
  bool get countDown => _countDown;
  set countDown(bool value) {
    _countDown = value;
    notifyListeners();
  }

  Future<void> initData(String testUrl) async {
    await fetchQuestions(testUrl);
    reset();
  }

  Future<void> fetchQuestions(String testUrl) async {
    isLoading = true;
    try {
      var response = await http.get(Uri.parse(testUrl));
      if (response.statusCode == 200) {
        var questionsJson = jsonDecode(response.body) as List;
        List<Question> questionList = [];
        for (var questionJson in questionsJson) {
          questionList.add(Question.fromMap(questionJson));
        }
        questions = questionList;
      } else {
        questions = [];
      }
    } catch (e) {
      debugPrint(e.toString());
      questions = [];
    }
    startTimer();
    isLoading = false;
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) => addTime());
  }

  void addTime() async {
    final addSeconds = countDown ? -1 : 1;
    final seconds = duration.inSeconds + addSeconds;
    if (seconds < 0) {
      timer?.cancel();
    } else {
      duration = Duration(seconds: seconds);
    }
    if (!timer!.isActive) {
      await submitQuiz(isDialogOrSheetOpen: false);
    }
  }

  void reset() {
    if (countDown) {
      duration = countdownDuration;
    } else {
      duration = const Duration();
    }
  }

  Future<void> disposeData() async {
    pageController.dispose();
    if (timer != null) timer!.cancel();
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

    // if (isDialogOrSheetOpen) Navigator.pop(context);
    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => QuizResultScreen(
    //       result: result,
    //     ),
    //   ),
    // );
  }
}
