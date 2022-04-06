import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_app/models/question.dart';
import 'package:quiz_app/services/quiz_service.dart';
import 'package:quiz_app/ui/providers/quiz/quiz_states.dart';

final quizPageProvider = StateProvider.autoDispose<int>((ref) => 0);

final progressProvider = StateProvider.autoDispose<double>((ref) {
  final queLength = ref.read(quizProvider.notifier).questionList.length;
  return (ref.watch(quizPageProvider) + 1) / queLength;
});

final isListViewProvider = StateProvider.autoDispose<bool>((ref) => true);

final isQuizSubmittingProvider =
    StateProvider.autoDispose<bool>((ref) => false);

final durationProvider =
    StateProvider.autoDispose<Duration>((ref) => const Duration());

final quizProvider = StateNotifierProvider.autoDispose<QuizNotifier, QuizState>(
  (ref) => QuizNotifier(
    quizService: ref.watch(quizServiceProvider),
  ),
);

class QuizNotifier extends StateNotifier<QuizState> {
  final IQuizService _quizService;

  late List<Question> questionList;

  QuizNotifier({
    required IQuizService quizService,
  })  : _quizService = quizService,
        super(const QuizState.initial());

  Future<void> fetchQuiz(String quizUrl) async {
    state = const QuizState.loading();
    try {
      final quiz = await _quizService.getQuiz(quizUrl);
      questionList = quiz;
      state = QuizState.data(questionList: questionList);
    } catch (_) {
      state = const QuizState.error('Error!');
    }
  }

  void clearAnswer(int questionIndex) {
    questionList[questionIndex].selectedOption = null;
    questionList[questionIndex].selectedOptions = [];

    state = QuizState.data(questionList: questionList);
  }

  void markForReview(int questionIndex, bool val) {
    questionList[questionIndex].isMarkedForReview = val;

    state = QuizState.data(questionList: questionList);
  }

  void answerQuestion(int questionIndex, int selectedOption) {
    questionList[questionIndex].selectedOption = selectedOption;
    questionList[questionIndex].isAnswered = true;

    state = QuizState.data(questionList: questionList);
  }

  void removeAnswer(int questionIndex) {
    questionList[questionIndex].selectedOption = null;
    questionList[questionIndex].isAnswered = false;

    state = QuizState.data(questionList: questionList);
  }

  void answerMultipleChoiceQuestion(int questionIndex, int selectedOption) {
    questionList[questionIndex].selectedOptions!.add(selectedOption);
    questionList[questionIndex].isAnswered = true;

    state = QuizState.data(questionList: questionList);
  }

  void removeMultipleChoiceAnswer(int questionIndex, int selectedOption) {
    questionList[questionIndex].selectedOptions!.remove(selectedOption);
    if (questionList[questionIndex].selectedOptions!.isEmpty) {
      questionList[questionIndex].isAnswered = false;
    }

    state = QuizState.data(questionList: questionList);
  }
}

// final myViewProvider = Provider<MyViewProvider>((ref) {
//   return MyViewProvider(ref.read);
// });

// class MyViewProvider {
//   MyViewProvider(this._read);

//   final Reader _read;

//   void setLoading(bool value) {
//     _read(isLoadingProvider).state = value;
//   }

//   void setImageLoading(bool value) {
//     _read(isImageLoadingProvider).state = value;
//   }

//   void setObscurePassword() {
//     final isObscure = _read(isLoadingProvider).state;
//     _read(isObscurePasswordProvider).state = !isObscure;
//   }
// }

// class QuizTimerProvider extends StateNotifier<Timer> {
//   bool countDown = true;

//   QuizTimerProvider()
//       : super(Timer.periodic(const Duration(seconds: 1), (_) => addTime()));

//   void addTime() async {
//     final addSeconds = countDown ? -1 : 1;
//     setState(() {
//       final seconds = duration.inSeconds + addSeconds;
//       if (seconds < 0) {
//         timer?.cancel();
//       } else {
//         duration = Duration(seconds: seconds);
//       }
//     });
//     if (!timer!.isActive) {
//       await submitQuiz(isDialogOrSheetOpen: false);
//     }
//   }
// }
