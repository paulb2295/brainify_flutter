import 'package:brainify_flutter/models/question.dart';
import 'package:brainify_flutter/view_models/question_student_viewmodel.dart';
import 'package:brainify_flutter/views/components/loading_widget.dart';
import 'package:brainify_flutter/views/components/question_student_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../models/module.dart';
import '../components/rounded_button.dart';

class QuestionsPageStudent extends StatefulWidget {
  const QuestionsPageStudent({super.key, required this.module});
  final Module module;

  @override
  State<QuestionsPageStudent> createState() => _QuestionsPageStudentState();
}

class _QuestionsPageStudentState extends State<QuestionsPageStudent> {

  List<Question> questions = [];
  Map<int, int> questionScores = {};
  int totalScore = 0;
  bool calculatePressed = false;
  Widget questionsList = const LoadingWidget(message: 'Loading Questions');

  @override
  void initState() {
    super.initState();
    context.read<QuestionStudentViewModel>().initialize(widget.module);
    questions = context.read<QuestionStudentViewModel>().questions;
  }

  void _updateScore(int index, int score) {
    setState(() {
      questionScores[index] = score;
    });
  }

  int _calculateTotalScore() {
    return questionScores.values.fold(0, (sum, score) => sum + score);
  }

  @override
  Widget build(BuildContext context) {
    //List<Question> questions = context.read<QuestionStudentViewModel>().questions;
    questionsList = context.read<QuestionStudentViewModel>().questionState == QuestionsState.error?
        ErrorWidget(
            context.read<QuestionStudentViewModel>().errorMessage,
        ) :
        ListView.builder(
          itemCount: questions.length,
            itemBuilder: (context, index){
            return QuestionStudentWidget(
                question: questions[index],
              onScoreCalculated: (score) => _updateScore(index, score),
            );
            },
        );
    return Scaffold(
      body: Column(
          children :
          [
            Text(
              calculatePressed? 'Total Score: $totalScore/${questions.length*5}' : '',
              style: const TextStyle(
                fontSize: 16.0
              ),
            ),
            Expanded(child: questionsList),
            Row(
              children: [
                RoundedButton(
                  color: Theme.of(context).primaryColor,
                  title: 'Back',
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                RoundedButton(
                  color: Theme.of(context).primaryColor,
                  title: 'Get Score',
                  onPressed: () {
                    totalScore = _calculateTotalScore();
                    calculatePressed = true;
                  },
                ),
              ],
            ),
          ]
      ),
    );
  }
}
