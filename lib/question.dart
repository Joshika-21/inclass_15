import 'package:html_unescape/html_unescape.dart';

class Question {
  final String question;
  final List<String> options;
  final String correctAnswer;
  final List<String> correctAnswers; // ✅ for multi-select

  Question({
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.correctAnswers,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    var unescape = HtmlUnescape();
    List<String> options =
        List<String>.from(
          json['incorrect_answers'],
        ).map((opt) => unescape.convert(opt)).toList();
    String correct = unescape.convert(json['correct_answer']);
    options.add(correct);
    options.shuffle();

    return Question(
      question: unescape.convert(json['question']),
      options: options,
      correctAnswer: correct,
      correctAnswers: [correct], // for compatibility
    );
  }

  factory Question.selectAll({
    required String question,
    required List<String> options,
    required List<String> correctAnswers,
  }) {
    return Question(
      question: question,
      options: options,
      correctAnswer: '',
      correctAnswers: correctAnswers,
    );
  }
}
