import 'dart:convert';

import 'package:quiz_app/models/tags.dart';

import 'answers.dart';
import 'correct_answers.dart';

class Question {
  final int id;
  final String? question;
  final String? description;
  final Answers? answers;
  final String? multipleCorrectAnswers;
  final CorrectAnswers? correctAnswers;
  final String? correctAnswer;
  final String? explanation;
  final String? tip;
  final List<Tags>? tags;
  final String? category;
  final String? difficulty;
  int? selectedOption;
  List<int>? selectedOptions;
  bool? isAnswered;
  bool? isMarkedForReview;
  Question({
    required this.id,
    this.question,
    this.description,
    this.answers,
    this.multipleCorrectAnswers,
    this.correctAnswers,
    this.correctAnswer,
    this.explanation,
    this.tip,
    this.tags,
    this.category,
    this.difficulty,
    this.selectedOption,
    this.selectedOptions,
    this.isAnswered,
    this.isMarkedForReview,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'question': question,
      'description': description,
      'answers': answers?.toMap(),
      'multiple_correct_answers': multipleCorrectAnswers,
      'correct_answers': correctAnswers?.toMap(),
      'correct_answer': correctAnswer,
      'explanation': explanation,
      'tip': tip,
      'tags': tags?.map((x) => x.toMap()).toList(),
      'category': category,
      'difficulty': difficulty,
      'selected_option': selectedOption,
      'selected_options': selectedOptions,
      'is_answered': isAnswered,
      'is_marked_for_review': isMarkedForReview,
    };
  }

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      id: map['id']?.toInt() ?? 0,
      question: map['question'],
      description: map['description'],
      answers: map['answers'] != null ? Answers.fromMap(map['answers']) : null,
      multipleCorrectAnswers: map['multiple_correct_answers'],
      correctAnswers: map['correct_answers'] != null
          ? CorrectAnswers.fromMap(map['correct_answers'])
          : null,
      correctAnswer: map['correct_answer'],
      explanation: map['explanation'],
      tip: map['tip'],
      tags: map['tags'] != null
          ? List<Tags>.from(map['tags']?.map((x) => Tags.fromMap(x)))
          : null,
      category: map['category'],
      difficulty: map['difficulty'],
      selectedOption: map['selected_option'],
      selectedOptions: map['selected_options'] ?? [],
      isAnswered: map['is_answered'] ?? false,
      isMarkedForReview: map['is_marked_for_review'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory Question.fromJson(String source) =>
      Question.fromMap(json.decode(source));
}

// class Question {
//   final int id;
//   final int answer;
//   final String question;
//   final List<String> options;
//   Question({
//     required this.id,
//     required this.answer,
//     required this.question,
//     required this.options,
//   });
// }

// const List sampleData = [
//   {
//     "id": 1,
//     "question":
//         "Flutter is an open-source UI software development kit created by ______",
//     "options": ['Apple', 'Google', 'Facebook', 'Microsoft'],
//     "answer_index": 1,
//   },
//   {
//     "id": 2,
//     "question": "When google release Flutter.",
//     "options": ['Jun 2017', 'Jun 2017', 'May 2017', 'May 2018'],
//     "answer_index": 2,
//   },
//   {
//     "id": 3,
//     "question": "A memory location that holds a single letter or number.",
//     "options": ['Double', 'Int', 'Char', 'Word'],
//     "answer_index": 2,
//   },
//   {
//     "id": 4,
//     "question": "What command do you use to output data to the screen?",
//     "options": ['Cin', 'Count>>', 'Cout', 'Output>>'],
//     "answer_index": 2,
//   },
// ];
