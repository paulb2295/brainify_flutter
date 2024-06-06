import 'package:flutter/material.dart';
import '../../models/question.dart';

class QuestionStudentWidget extends StatefulWidget {
  final Question question;
  final Function(int) onScoreCalculated;

  const QuestionStudentWidget({Key? key, required this.question, required this.onScoreCalculated})
      : super(key: key);

  @override
  State<QuestionStudentWidget> createState() => _QuestionStudentWidgetState();
}

class _QuestionStudentWidgetState extends State<QuestionStudentWidget> {
  Map<String, bool> _selectedAnswers = {};

  Map<String, bool> _correctlySelectedAnswers = {
    'a': false,
    'b': false,
    'c': false,
    'd': false,
    'e': false,
  };
  bool buttonTapped = false;
  int score = 0;

  void calculateScore() {
    score = 0;
    for (var entry in _selectedAnswers.entries) {
      if (widget.question.correctAnswers.contains(entry.key) &&
          entry.value == true) {
        score++;
        _correctlySelectedAnswers[entry.key] = true;
      }else if(!widget.question.correctAnswers.contains(entry.key) &&
          entry.value == false){
        _correctlySelectedAnswers[entry.key] = true;
      }
    }
    widget.onScoreCalculated(score);
  }

  @override
  void initState() {
    super.initState();
    _selectedAnswers = {
      'a': false,
      'b': false,
      'c': false,
      'd': false,
      'e': false,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.question.questionBody,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            AnswerTile(
              answer: widget.question.answerA,
              answerKey: 'a',
              isSelected: _selectedAnswers['a']!,
              onChanged: (bool? value) {
                setState(() {
                  _selectedAnswers['a'] = value!;
                });
              },
            ),
            AnswerTile(
              answer: widget.question.answerB,
              answerKey: 'b',
              isSelected: _selectedAnswers['b']!,
              onChanged: (bool? value) {
                setState(() {
                  _selectedAnswers['b'] = value!;
                });
              },
            ),
            AnswerTile(
              answer: widget.question.answerC,
              answerKey: 'c',
              isSelected: _selectedAnswers['c']!,
              onChanged: (bool? value) {
                setState(() {
                  _selectedAnswers['c'] = value!;
                });
              },
            ),
            AnswerTile(
              answer: widget.question.answerD,
              answerKey: 'd',
              isSelected: _selectedAnswers['d']!,
              onChanged: (bool? value) {
                setState(() {
                  _selectedAnswers['d'] = value!;
                });
              },
            ),
            AnswerTile(
              answer: widget.question.answerE,
              answerKey: 'e',
              isSelected: _selectedAnswers['e']!,
              onChanged: (bool? value) {
                setState(() {
                  _selectedAnswers['e'] = value!;
                });
              },
            ),
            ElevatedButton(
                onPressed: (){
                  calculateScore();
                  buttonTapped = true;
                },
                child: const Text('Submit Question'),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget to display an answer option
class AnswerTile extends StatelessWidget {
  final String answer;
  final String answerKey;
  final bool isSelected;
  final ValueChanged<bool?> onChanged;

  const AnswerTile({
    Key? key,
    required this.answer,
    required this.answerKey,
    required this.isSelected,
    required this.onChanged,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(answer),
      leading: Checkbox(
        value: isSelected,
        onChanged: onChanged,
      ),
    );
  }
}
