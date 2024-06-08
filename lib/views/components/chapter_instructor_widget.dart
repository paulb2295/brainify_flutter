import 'package:brainify_flutter/view_models/module_instructor_viewmodel.dart';
import 'package:brainify_flutter/views/components/exception_widget.dart';
import 'package:brainify_flutter/views/components/rounded_button.dart';
import 'package:brainify_flutter/views/pages/questions_instructor_edit_page.dart';
import 'package:brainify_flutter/views/pages/questions_instructor_view_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/chapter.dart';
import '../../models/course.dart';
import '../../models/module.dart';
import 'loading_widget.dart';

class ChapterInstructorView extends StatefulWidget {
  const ChapterInstructorView(
      {super.key, required this.module, required this.course});

  final Module module;
  final Course course;

  @override
  State<ChapterInstructorView> createState() => _ChapterInstructorViewState();
}

class _ChapterInstructorViewState extends State<ChapterInstructorView> {
  Widget displayChapter =
      const LoadingWidget(message: 'Chapter content loading');

  final _questionsNumberController = TextEditingController();
  void _generateQuestions(Chapter chapter) {
    if (double.tryParse(_questionsNumberController.text) == null ||
        double.tryParse(_questionsNumberController.text)! < 1) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid amount'),
          content: const Text('Only enter numbers greater than 0!'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('I understand')),
          ],
        ),
      );
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => QuestionsPageInstructorEdit(
          module: widget.module,
          chapter: chapter,
          courseId: widget.course.id!,
          questionNumber: int.parse(_questionsNumberController.text),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<ModuleInstructorViewModel>()
          .getChapterForModule(widget.module);
    });
  }

  @override
  void dispose() {
    _questionsNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Chapter chapter = context.watch<ModuleInstructorViewModel>().chapter;
    displayChapter = context.read<ModuleInstructorViewModel>().modulesState ==
            ModulesState.error
        ? ExceptionWidget(
            errorMessage:
                context.read<ModuleInstructorViewModel>().errorMessage)
        : (context.read<ModuleInstructorViewModel>().modulesState ==
                ModulesState.loading
            ? const LoadingWidget(message: 'Loading chapter content')
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        chapter.title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Row(
                      children: [
                        const Expanded(
                          flex: 1,
                          child: SizedBox(),
                        ),
                        Expanded(
                          flex: 4,
                          child: Text(
                            chapter.content,
                            textAlign: TextAlign.justify,
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        const Expanded(
                          flex: 1,
                          child: SizedBox(),
                        )
                      ],
                    )
                  ],
                ),
              ));
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
      child: Column(
        children: [
          Expanded(child: displayChapter),
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
              const SizedBox(
                width: 8.0,
              ),
              RoundedButton(
                color: Theme.of(context).primaryColor,
                title: 'See Questions',
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => QuestionsPageInstructorView(
                        module: widget.module,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: TextField(
                  controller: _questionsNumberController,
                  keyboardType: TextInputType.number,
                  maxLength: 3,
                  decoration: const InputDecoration(
                    label: Text('Number of questions to generate'),
                    prefixText: 'Q: ',
                  ),
                ),
              ),
              const SizedBox(
                width: 14,
              ),
              RoundedButton(
                color: Theme.of(context).primaryColor,
                title: 'Generate questions',
                onPressed: () {
                  _generateQuestions(chapter);
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
