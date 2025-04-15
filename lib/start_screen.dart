import 'package:flutter/material.dart';
import 'quiz_screen.dart';

class StartScreen extends StatefulWidget {
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  int _selectedAmount = 5;
  int _selectedCategory = 9; // Default to General Knowledge

  final Map<String, int> _categories = {
    'General Knowledge': 9,
    'Books': 10,
    'Film': 11,
    'Music': 12,
    'Science & Nature': 17,
    'Computers': 18,
    'Mathematics': 19,
    'Sports': 21,
    'Geography': 22,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Quiz Setup')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            DropdownButtonFormField<int>(
              decoration: InputDecoration(labelText: 'Category'),
              value: _selectedCategory,
              items: _categories.entries
                  .map((entry) => DropdownMenuItem(
                        value: entry.value,
                        child: Text(entry.key),
                      ))
                  .toList(),
              onChanged: (val) => setState(() => _selectedCategory = val!),
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<int>(
              decoration: InputDecoration(labelText: 'Number of Questions'),
              value: _selectedAmount,
              items: [5, 10, 15, 20]
                  .map((val) => DropdownMenuItem(
                        value: val,
                        child: Text('$val'),
                      ))
                  .toList(),
              onChanged: (val) => setState(() => _selectedAmount = val!),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => QuizScreen(
                      amount: _selectedAmount,
                      category: _selectedCategory,
                    ),
                  ),
                );
              },
              child: Text('Start Quiz'),
            ),
          ],
        ),
      ),
    );
  }
}
