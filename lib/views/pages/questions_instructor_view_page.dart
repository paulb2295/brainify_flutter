import 'package:brainify_flutter/view_models/question_instructor_viewmodel.dart';
import 'package:brainify_flutter/views/components/exception_widget.dart';
import 'package:brainify_flutter/views/components/question_instructor_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/module.dart';
import '../../models/question.dart';
import '../components/loading_widget.dart';
import '../components/rounded_button.dart';

class QuestionsPageInstructorView extends StatefulWidget {
  const QuestionsPageInstructorView({super.key, required this.module});
  final Module module;

  @override
  State<QuestionsPageInstructorView> createState() =>
      _QuestionsPageInstructorViewState();
}

class _QuestionsPageInstructorViewState
    extends State<QuestionsPageInstructorView> {
  List<Question> questions = [];
  Widget questionsList = const LoadingWidget(message: 'Loading Questions');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QuestionInstructorViewModel>().initialize(widget.module);
    });
  }

  @override
  Widget build(BuildContext context) {
    questions = context.watch<QuestionInstructorViewModel>().questions;
    questionsList = context.read<QuestionInstructorViewModel>().questionState ==
            QuestionsState.error
        ? ExceptionWidget(
            errorMessage:
                context.read<QuestionInstructorViewModel>().errorMessage,
          )
        : (context.read<QuestionInstructorViewModel>().questionState ==
                QuestionsState.loading
            ? const LoadingWidget(message: 'Loading Questions')
            : ListView.builder(
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  return QuestionInstructorWidget(
                    question: questions[index],
                  );
                },
              ));
    return Scaffold(
      body: Column(children: [
        Expanded(child: questionsList),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RoundedButton(
              color: Theme.of(context).primaryColor,
              title: 'Back',
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ]),
    );
  }
}
