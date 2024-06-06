import 'package:flutter/material.dart';
import '../../models/question.dart';

class QuestionInstructorEditWidget extends StatefulWidget {
  final Question question;
  final void Function(Question) onSave;

  const QuestionInstructorEditWidget({Key? key, required this.question, required this.onSave}) : super(key: key);

  @override
  State<QuestionInstructorEditWidget> createState() => _QuestionInstructorEditWidgetState();
}

class _QuestionInstructorEditWidgetState extends State<QuestionInstructorEditWidget> {
  late TextEditingController _questionBodyController;
  late TextEditingController _answerAController;
  late TextEditingController _answerBController;
  late TextEditingController _answerCController;
  late TextEditingController _answerDController;
  late TextEditingController _answerEController;
  late Map<String, bool> _correctAnswers;

  @override
  void initState() {
    super.initState();
    _questionBodyController = TextEditingController(text: widget.question.questionBody);
    _answerAController = TextEditingController(text: widget.question.answerA);
    _answerBController = TextEditingController(text: widget.question.answerB);
    _answerCController = TextEditingController(text: widget.question.answerC);
    _answerDController = TextEditingController(text: widget.question.answerD);
    _answerEController = TextEditingController(text: widget.question.answerE);
    _correctAnswers = {
      'a': widget.question.correctAnswers.contains('a'),
      'b': widget.question.correctAnswers.contains('b'),
      'c': widget.question.correctAnswers.contains('c'),
      'd': widget.question.correctAnswers.contains('d'),
      'e': widget.question.correctAnswers.contains('e'),
    };
  }

  @override
  void dispose() {
    _questionBodyController.dispose();
    _answerAController.dispose();
    _answerBController.dispose();
    _answerCController.dispose();
    _answerDController.dispose();
    _answerEController.dispose();
    super.dispose();
  }

  void _saveQuestion() {
    final updatedQuestion = Question(
      id: widget.question.id,
      chapterId: widget.question.chapterId,
      questionBody: _questionBodyController.text,
      answerA: _answerAController.text,
      answerB: _answerBController.text,
      answerC: _answerCController.text,
      answerD: _answerDController.text,
      answerE: _answerEController.text,
      correctAnswers: _correctAnswers.entries.where((entry) => entry.value).map((entry) => entry.key).toList(),
    );
    widget.onSave(updatedQuestion);
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
            TextField(
              controller: _questionBodyController,
              decoration: const InputDecoration(labelText: 'Question'),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            AnswerTile(
              answerController: _answerAController,
              isCorrect: _correctAnswers['a']!,
              onChanged: (bool? value) {
                setState(() {
                  _correctAnswers['a'] = value!;
                });
              },
            ),
            AnswerTile(
              answerController: _answerBController,
              isCorrect: _correctAnswers['b']!,
              onChanged: (bool? value) {
                setState(() {
                  _correctAnswers['b'] = value!;
                });
              },
            ),
            AnswerTile(
              answerController: _answerCController,
              isCorrect: _correctAnswers['c']!,
              onChanged: (bool? value) {
                setState(() {
                  _correctAnswers['c'] = value!;
                });
              },
            ),
            AnswerTile(
              answerController: _answerDController,
              isCorrect: _correctAnswers['d']!,
              onChanged: (bool? value) {
                setState(() {
                  _correctAnswers['d'] = value!;
                });
              },
            ),
            AnswerTile(
              answerController: _answerEController,
              isCorrect: _correctAnswers['e']!,
              onChanged: (bool? value) {
                setState(() {
                  _correctAnswers['e'] = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveQuestion,
              child: const Text('Mark Question As OK'),
            ),
          ],
        ),
      ),
    );
  }
}

class AnswerTile extends StatelessWidget {
  final TextEditingController answerController;
  final bool isCorrect;
  final ValueChanged<bool?> onChanged;

  const AnswerTile({
    Key? key,
    required this.answerController,
    required this.isCorrect,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: TextField(
        controller: answerController,
        decoration: const InputDecoration(labelText: 'Answer'),
      ),
      leading: Checkbox(
        value: isCorrect,
        onChanged: onChanged,
      ),
    );
  }
}