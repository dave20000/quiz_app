import 'package:quiz_app/models/question.dart';

class Result {
  final int correctAnswers;
  final int incorrectAnswers;
  final int unAnswered;
  final List<Question> questions;
  final double score;
  Result({
    required this.correctAnswers,
    required this.incorrectAnswers,
    required this.unAnswered,
    required this.questions,
    required this.score,
  });
}
