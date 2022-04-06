import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_app/models/question.dart';

import 'package:http/http.dart' as http;

final quizServiceProvider = Provider<IQuizService>(
  (ref) => QuizService(),
);

abstract class IQuizService {
  Future<List<Question>> getQuiz(String url);
}

class QuizService implements IQuizService {
  @override
  Future<List<Question>> getQuiz(String url) async {
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var questionsJson = jsonDecode(response.body) as List;
      List<Question> questionList = [];
      for (var questionJson in questionsJson) {
        questionList.add(Question.fromMap(questionJson));
      }
      return questionList;
    } else {
      return [];
    }
  }
}
