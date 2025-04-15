import 'package:html_unescape/html_unescape.dart';  // ✅ Import

class Question {
  final String question;
  final List<String> options;
  final String correctAnswer;

  Question({
    required this.question,
    required this.options,
    required this.correctAnswer,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    var unescape = HtmlUnescape();

    List<String> options = List<String>.from(json['incorrect_answers'])
        .map((opt) => unescape.convert(opt)) // ✅ decode options
        .toList();

    options.add(unescape.convert(json['correct_answer']));
    options.shuffle();

    return Question(
      question: unescape.convert(json['question']),  // ✅ decode question
      options: options,
      correctAnswer: unescape.convert(json['correct_answer']),
    );
  }
}
