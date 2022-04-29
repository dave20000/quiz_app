import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:quiz_app/models/question.dart';

part 'quiz_states.freezed.dart';

extension QuizGetters on QuizState {
  bool get isLoading => this is _Loading;
}

@freezed
class QuizState with _$QuizState {
  /// Data is present state
  const factory QuizState.data({required List<Question> questionList}) = _Data;

  /// Initial/default state
  const factory QuizState.initial() = _Initial;

  /// Data is loading state
  const factory QuizState.loading() = _Loading;

  /// Error when loading data state
  const factory QuizState.error([String? message]) = _Error;
}
