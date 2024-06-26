import 'package:brainify_flutter/models/chapter.dart';
import 'package:brainify_flutter/view_models/question_instructor_viewmodel.dart';
import 'package:brainify_flutter/views/components/exception_widget.dart';
import 'package:brainify_flutter/views/components/question_instructor_edit_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/module.dart';
import '../../models/question.dart';
import '../components/loading_widget.dart';
import '../components/rounded_button.dart';

class QuestionsPageInstructorEdit extends StatefulWidget {
  const QuestionsPageInstructorEdit(
      {super.key,
      required this.chapter,
      required this.courseId,
      required this.module,
      required this.questionNumber});
  final Chapter chapter;
  final Module module;
  final int courseId;
  final int questionNumber;

  @override
  State<QuestionsPageInstructorEdit> createState() =>
      _QuestionsPageInstructorEditState();
}

class _QuestionsPageInstructorEditState
    extends State<QuestionsPageInstructorEdit> {
  List<Question> editedQuestions = [];
  List<Question> questions = [];
  Widget questionsList = const LoadingWidget(message: 'Întrebările se încarcă');
  bool saveTapped = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QuestionInstructorViewModel>().initialize(widget.module);
      context.read<QuestionInstructorViewModel>().generateQuestions(
          widget.chapter, widget.courseId, widget.questionNumber);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    questions = context.watch<QuestionInstructorViewModel>().generatedQuestions;
    questionsList =
        context.watch<QuestionInstructorViewModel>().questionGenerationState ==
                QuestionsGenerationState.error
            ? ExceptionWidget(
                errorMessage:
                    context.read<QuestionInstructorViewModel>().errorMessage,
              )
            : (questionsList = context
                        .read<QuestionInstructorViewModel>()
                        .questionGenerationState ==
                    QuestionsGenerationState.loading
                ? const LoadingWidget(message: 'Se generează întrebările')
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
                  ));
    return Scaffold(
      body: Column(children: [
        Expanded(child: questionsList),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RoundedButton(
              color: Theme.of(context).primaryColor,
              title: 'Înapoi',
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            !saveTapped ? RoundedButton(
              color: Theme.of(context).primaryColor,
              title: 'Salvează Întrebările',
              onPressed: () {
                context
                    .read<QuestionInstructorViewModel>()
                    .saveGenerateQuestions(editedQuestions);
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Întrebările au fost salvate cu succes!'),
                    actions: [
                      TextButton(
                          onPressed: (){
                            Navigator.of(ctx, rootNavigator: true).pop();
                          },
                          child: const Text('OK')
                      ),
                    ],
                  ),
                );
                setState(() {
                  saveTapped = true;
                });
              },
            ) : const Text(''),
          ],
        ),
      ]),
    );
  }
}
