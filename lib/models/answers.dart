import 'dart:convert';

class Answers {
  final String? answerA;
  final String? answerB;
  final String? answerC;
  final String? answerD;
  final String? answerE;
  final String? answerF;
  Answers({
    this.answerA,
    this.answerB,
    this.answerC,
    this.answerD,
    this.answerE,
    this.answerF,
  });

  Map<String, dynamic> toMap() {
    return {
      'answer_a': answerA,
      'answer_b': answerB,
      'answer_c': answerC,
      'answer_d': answerD,
      'answer_e': answerE,
      'answer_f': answerF,
    };
  }

  factory Answers.fromMap(Map<String, dynamic> map) {
    return Answers(
      answerA: map['answer_a'],
      answerB: map['answer_b'],
      answerC: map['answer_c'],
      answerD: map['answer_d'],
      answerE: map['answer_e'],
      answerF: map['answer_f'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Answers.fromJson(String source) =>
      Answers.fromMap(json.decode(source));
}
