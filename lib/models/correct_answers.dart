import 'dart:convert';

class CorrectAnswers {
  final String answerACorrect;
  final String answerBCorrect;
  final String answerCCorrect;
  final String answerDCorrect;
  final String answerECorrect;
  final String answerFCorrect;
  CorrectAnswers({
    required this.answerACorrect,
    required this.answerBCorrect,
    required this.answerCCorrect,
    required this.answerDCorrect,
    required this.answerECorrect,
    required this.answerFCorrect,
  });

  Map<String, dynamic> toMap() {
    return {
      'answer_a_correct': answerACorrect,
      'answer_b_correct': answerBCorrect,
      'answer_c_correct': answerCCorrect,
      'answer_d_correct': answerDCorrect,
      'answer_e_correct': answerECorrect,
      'answer_f_correct': answerFCorrect,
    };
  }

  factory CorrectAnswers.fromMap(Map<String, dynamic> map) {
    return CorrectAnswers(
      answerACorrect: map['answer_a_correct'] ?? '',
      answerBCorrect: map['answer_b_correct'] ?? '',
      answerCCorrect: map['answer_c_correct'] ?? '',
      answerDCorrect: map['answer_d_correct'] ?? '',
      answerECorrect: map['answer_e_correct'] ?? '',
      answerFCorrect: map['answer_f_correct'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory CorrectAnswers.fromJson(String source) =>
      CorrectAnswers.fromMap(json.decode(source));
}
