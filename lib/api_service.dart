import 'dart:convert';
import 'package:http/http.dart' as http;
import 'question.dart';

class ApiService {
  static Future<List<Question>> fetchQuestions({
    required int amount,
    required int category,
    required String difficulty,
    required String type,
  }) async {
    if (type == 'select_all') {
      return [
        Question.selectAll(
          question: "Which of the following are programming languages?",
          options: ["Python", "Snake", "Java", "Elephant"],
          correctAnswers: ["Python", "Java"],
        ),
        Question.selectAll(
          question: "Which are planets in our solar system?",
          options: ["Mars", "Moon", "Venus", "Sun"],
          correctAnswers: ["Mars", "Venus"],
        ),
      ];
    }

    final url =
        'https://opentdb.com/api.php?amount=$amount&category=$category&difficulty=$difficulty&type=$type';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<Question> questions =
          (data['results'] as List).map((q) => Question.fromJson(q)).toList();
      return questions;
    } else {
      throw Exception('Failed to load questions');
    }
  }
}
