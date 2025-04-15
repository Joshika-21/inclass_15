import 'package:flutter/material.dart';
import 'question.dart';
import 'api_service.dart';

class QuizScreen extends StatefulWidget {
  final int amount;
  final int category;
  final String difficulty;
  final String type;

  QuizScreen({
    required this.amount,
    required this.category,
    required this.difficulty,
    required this.type,
  });

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final Color _beige = const Color(0xFFF5F5DC);
  final Color _brown = const Color.fromARGB(
    255,
    184,
    110,
    36,
  ); // Lightened brown

  List<Question> _questions = [];
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _loading = true;
  bool _answered = false;
  String _feedbackText = "";
  String _selectedAnswer = "";
  Set<String> _multiSelections = {};

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    try {
      final questions = await ApiService.fetchQuestions(
        amount: widget.amount,
        category: widget.category,
        difficulty: widget.difficulty,
        type: widget.type,
      );
      setState(() {
        _questions = questions;
        _loading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  void _submitAnswer(String selectedAnswer) {
    setState(() {
      _answered = true;
      _selectedAnswer = selectedAnswer;

      final question = _questions[_currentQuestionIndex];
      final correct = question.correctAnswer;

      if (selectedAnswer == correct) {
        _score++;
        _feedbackText = "✅ Correct! The answer is $correct.";
      } else {
        _feedbackText = "❌ Incorrect. The correct answer is $correct.";
      }
    });
  }

  void _submitMultiAnswer() {
    final question = _questions[_currentQuestionIndex];
    final correctAnswers = question.correctAnswers.toSet();

    setState(() {
      _answered = true;

      if (_multiSelections.containsAll(correctAnswers) &&
          correctAnswers.containsAll(_multiSelections)) {
        _score++;
        _feedbackText =
            "✅ Correct! You selected all applicable correct answers.";
      } else {
        _feedbackText =
            "❌ Incorrect. Correct answers: ${correctAnswers.join(', ')}";
      }
    });
  }

  void _nextQuestion() {
    setState(() {
      _answered = false;
      _selectedAnswer = "";
      _multiSelections.clear();
      _feedbackText = "";
      _currentQuestionIndex++;
    });
  }

  Widget _buildOptionButton(String option) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: ElevatedButton(
        onPressed: _answered ? null : () => _submitAnswer(option),
        style: ElevatedButton.styleFrom(
          backgroundColor: _brown,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(option),
      ),
    );
  }

  Widget _buildCheckbox(String option) {
    return CheckboxListTile(
      title: Text(option, style: TextStyle(color: Colors.brown[800])),
      value: _multiSelections.contains(option),
      onChanged:
          _answered
              ? null
              : (val) {
                setState(() {
                  if (val!) {
                    _multiSelections.add(option);
                  } else {
                    _multiSelections.remove(option);
                  }
                });
              },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        backgroundColor: _beige,
        body: Center(child: CircularProgressIndicator(color: _brown)),
      );
    }

    if (_currentQuestionIndex >= _questions.length) {
      return Scaffold(
        backgroundColor: _beige,
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Quiz Finished!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: _brown,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Your Score: $_score/${_questions.length}',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, color: _brown),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _brown,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text('Return to Home'),
              ),
            ],
          ),
        ),
      );
    }

    final question = _questions[_currentQuestionIndex];
    final isMulti = widget.type == 'select_all';

    return Scaffold(
      backgroundColor: _beige,
      appBar: AppBar(backgroundColor: _brown, title: Text('Quiz App')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Question ${_currentQuestionIndex + 1}/${_questions.length}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: _brown,
                ),
              ),
              SizedBox(height: 16),
              Text(
                question.question,
                style: TextStyle(fontSize: 18, color: Colors.brown[900]),
              ),
              SizedBox(height: 16),
              if (isMulti)
                ...question.options.map((opt) => _buildCheckbox(opt))
              else
                ...question.options.map((opt) => _buildOptionButton(opt)),
              SizedBox(height: 20),
              if (_answered)
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color:
                        _feedbackText.startsWith("✅")
                            ? Colors.green[50]
                            : Colors.red[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color:
                          _feedbackText.startsWith("✅")
                              ? Colors.green
                              : Colors.red,
                    ),
                  ),
                  child: Text(
                    _feedbackText,
                    style: TextStyle(
                      fontSize: 16,
                      color:
                          _feedbackText.startsWith("✅")
                              ? Colors.green[700]
                              : Colors.red[700],
                    ),
                  ),
                ),
              if (!_answered && isMulti)
                ElevatedButton(
                  onPressed: _submitMultiAnswer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _brown,
                    foregroundColor: Colors.white,
                  ),
                  child: Text('Submit Answer'),
                ),
              if (_answered)
                ElevatedButton(
                  onPressed: _nextQuestion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _brown,
                    foregroundColor: Colors.white,
                  ),
                  child: Text('Next Question'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
