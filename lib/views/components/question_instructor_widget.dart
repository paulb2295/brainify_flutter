import 'package:flutter/material.dart';
import '../../models/question.dart';

class QuestionInstructorWidget extends StatelessWidget {
  final Question question;

  const QuestionInstructorWidget({Key? key, required this.question}) : super(key: key);

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
              question.questionBody,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            AnswerTile(answer: question.answerA, isCorrect: question.correctAnswers.contains('a')),
            AnswerTile(answer: question.answerB, isCorrect: question.correctAnswers.contains('b')),
            AnswerTile(answer: question.answerC, isCorrect: question.correctAnswers.contains('c')),
            AnswerTile(answer: question.answerD, isCorrect: question.correctAnswers.contains('d')),
            AnswerTile(answer: question.answerE, isCorrect: question.correctAnswers.contains('e')),
          ],
        ),
      ),
    );
  }
}

// Widget to display an answer option
class AnswerTile extends StatelessWidget {
  final String answer;
  final bool isCorrect;

  const AnswerTile({Key? key, required this.answer, required this.isCorrect}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
          answer,
        style: TextStyle(
          backgroundColor: isCorrect ? Colors.green.shade200 : Colors.red.shade200,
        ),
      ),
      leading: Icon(
        isCorrect ? Icons.check_circle : Icons.dangerous,
        color: isCorrect ? Colors.green : Colors.red,
      ),
    );
  }
}