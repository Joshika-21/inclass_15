import 'package:flutter/material.dart';
import 'quiz_screen.dart';

class StartScreen extends StatefulWidget {
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  int _selectedAmount = 5;
  int _selectedCategory = 9;
  String _selectedDifficulty = 'easy';
  String _selectedType = 'multiple';

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

  final List<int> _amounts = [5, 10, 15, 20];
  final List<String> _difficulties = ['easy', 'medium', 'hard'];
  final Map<String, String> _types = {
    'Multiple Choice': 'multiple',
    'True / False': 'boolean',
    'Select All That Apply': 'select_all',
  };

  final Color _beige = const Color(0xFFF5F5DC);
  final Color _brown = const Color.fromARGB(255, 184, 110, 36);

  Future<void> _showSelectionDialog<T>({
    required String title,
    required List<T> options,
    required T selectedValue,
    required void Function(T) onSelected,
  }) async {
    await showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            backgroundColor: _beige,
            title: Text(title, style: TextStyle(color: _brown)),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children:
                    options
                        .map(
                          (option) => ListTile(
                            title: Text(
                              option.toString()[0].toUpperCase() +
                                  option.toString().substring(1),
                              style: TextStyle(color: _brown),
                            ),
                            onTap: () {
                              onSelected(option);
                              Navigator.pop(context);
                            },
                          ),
                        )
                        .toList(),
              ),
            ),
          ),
    );
  }

  Widget _buildSelectionButton({
    required String label,
    required String value,
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 14, color: _brown.withOpacity(0.8)),
          ),
          SizedBox(height: 6),
          ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 45),
              backgroundColor: _brown,
              foregroundColor: Colors.white,
              textStyle: TextStyle(fontSize: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(value),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String selectedCategoryLabel =
        _categories.entries
            .firstWhere((entry) => entry.value == _selectedCategory)
            .key;

    String selectedTypeLabel =
        _types.entries.firstWhere((entry) => entry.value == _selectedType).key;

    return Scaffold(
      backgroundColor: _beige,
      appBar: AppBar(title: Text('Quiz Setup'), backgroundColor: _brown),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSelectionButton(
              label: 'Category',
              value: selectedCategoryLabel,
              onPressed:
                  () => _showSelectionDialog<String>(
                    title: 'Select Category',
                    options: _categories.keys.toList(),
                    selectedValue: selectedCategoryLabel,
                    onSelected: (val) {
                      setState(() {
                        _selectedCategory = _categories[val]!;
                      });
                    },
                  ),
            ),
            _buildSelectionButton(
              label: 'Number of Questions',
              value: _selectedAmount.toString(),
              onPressed:
                  () => _showSelectionDialog<int>(
                    title: 'Select Number of Questions',
                    options: _amounts,
                    selectedValue: _selectedAmount,
                    onSelected: (val) {
                      setState(() {
                        _selectedAmount = val;
                      });
                    },
                  ),
            ),
            _buildSelectionButton(
              label: 'Difficulty',
              value:
                  _selectedDifficulty[0].toUpperCase() +
                  _selectedDifficulty.substring(1),
              onPressed:
                  () => _showSelectionDialog<String>(
                    title: 'Select Difficulty',
                    options: _difficulties,
                    selectedValue: _selectedDifficulty,
                    onSelected: (val) {
                      setState(() {
                        _selectedDifficulty = val;
                      });
                    },
                  ),
            ),
            _buildSelectionButton(
              label: 'Question Type',
              value: selectedTypeLabel,
              onPressed:
                  () => _showSelectionDialog<String>(
                    title: 'Select Question Type',
                    options: _types.keys.toList(),
                    selectedValue: selectedTypeLabel,
                    onSelected: (val) {
                      setState(() {
                        _selectedType = _types[val]!;
                      });
                    },
                  ),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder:
                        (_, __, ___) => QuizScreen(
                          amount: _selectedAmount,
                          category: _selectedCategory,
                          difficulty: _selectedDifficulty,
                          type: _selectedType,
                        ),
                    transitionsBuilder: (_, animation, __, child) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: const Color.fromARGB(255, 184, 110, 36),
                foregroundColor: Colors.white,
                textStyle: const TextStyle(fontSize: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text('Start Quiz'),
            ),
          ],
        ),
      ),
    );
  }
}
