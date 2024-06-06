import 'package:brainify_flutter/models/chapter.dart';
import 'package:brainify_flutter/view_models/question_instructor_viewmodel.dart';
import 'package:brainify_flutter/views/components/question_instructor_edit_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/module.dart';
import '../../models/question.dart';
import '../components/loading_widget.dart';
import '../components/rounded_button.dart';

class QuestionsPageInstructorEdit extends StatefulWidget {
  const QuestionsPageInstructorEdit(
      {super.key, required this.chapter, required this.courseId, required this.module, required this.questionNumber});
  final Chapter chapter;
  final Module module;
  final int courseId;
  final int questionNumber;

  @override
  State<QuestionsPageInstructorEdit> createState() => _QuestionsPageInstructorEditState();
}

class _QuestionsPageInstructorEditState extends State<QuestionsPageInstructorEdit> {
  final _questionNumber = TextEditingController();
  List<Question> editedQuestions = [];
  List<Question> questions = [];
  Widget questionsList = const LoadingWidget(message: 'Loading Questions');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QuestionInstructorViewModel>().initialize(widget.module);
      context.read<QuestionInstructorViewModel>().generateQuestions(widget.chapter, widget.courseId, widget.questionNumber);

    });
  }

  @override
  void dispose() {
    _questionNumber.dispose();
    context.read<QuestionInstructorViewModel>().resetQuestionInstructorVM();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    questions = context.watch<QuestionInstructorViewModel>().questions;
    questionsList = context.read<QuestionInstructorViewModel>().questionState ==
            QuestionsState.error
        ? ErrorWidget(
            context.read<QuestionInstructorViewModel>().errorMessage,
          )
        : ListView.builder(
            itemCount: questions.length,
            itemBuilder: (context, index) {
              return QuestionInstructorEditWidget(
                question: questions[index],
                onSave: (question) {
                  editedQuestions.add(question);
                },
              );
            },
          );
    return Scaffold(
      body: Column(children: [
        Row(children: [
          Expanded(
            child: TextField(
              controller: _questionNumber,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                label: Text('Number of question to generate'),
              ),
            ),
          ),
          const SizedBox(
            width: 16,
          ),
          RoundedButton(
            color: Theme.of(context).primaryColor,
            title: 'Generate Questions',
            onPressed: () {
              int number = int.tryParse(_questionNumber.text) != null? int.parse(_questionNumber.text) : 5;
              context.read<QuestionInstructorViewModel>().generateQuestions(widget.chapter, widget.courseId, number);
            },
          ),
        ],
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
              title: 'Save Questions',
              onPressed: () {
                context.read<QuestionInstructorViewModel>().saveGenerateQuestions(editedQuestions);
              },
            ),
          ],
        ),
      ]),
    );
  }
}
