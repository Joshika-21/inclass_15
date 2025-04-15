import 'dart:convert';
import 'package:http/http.dart' as http;
import 'question.dart';

class ApiService {
  static Future<List<Question>> fetchQuestions({
    required int amount,
    required int category,
  }) async {
    final url =
        'https://opentdb.com/api.php?amount=$amount&category=$category&difficulty=easy&type=multiple';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<Question> questions = (data['results'] as List)
          .map((q) => Question.fromJson(q))
          .toList();
      return questions;
    } else {
      throw Exception('Failed to load questions');
    }
  }
}

