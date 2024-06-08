import 'package:brainify_flutter/view_models/gpt_viewmodel.dart';
import 'package:brainify_flutter/view_models/module_student_viewmodel.dart';
import 'package:brainify_flutter/views/components/loading_widget.dart';
import 'package:brainify_flutter/views/components/rounded_button.dart';
import 'package:brainify_flutter/views/pages/questions_page_student.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../models/chapter.dart';
import '../../models/module.dart';
import 'exception_widget.dart';

class ChapterStudentView extends StatefulWidget {
  const ChapterStudentView({super.key, required this.module});

  final Module module;

  @override
  State<ChapterStudentView> createState() => _ChapterStudentViewState();
}

class _ChapterStudentViewState extends State<ChapterStudentView> {
  Widget displayChapter =
      const LoadingWidget(message: 'Chapter content loading');

  bool summarizeTapped = false;
  Chapter summarizedChapter = Chapter(title: '', content: '');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ModuleStudentViewModel>().getChapterForModule(widget.module);
    });
  }

  @override
  Widget build(BuildContext context) {
    Chapter chapter = context.watch<ModuleStudentViewModel>().chapter;

    displayChapter = context.read<ModuleStudentViewModel>().modulesState ==
            ModulesState.error
        ? ExceptionWidget(
            errorMessage: context.read<ModuleStudentViewModel>().errorMessage)
        : (context.read<GptViewModel>().summarizeState == SummarizeState.loading ||
                context.read<ModuleStudentViewModel>().modulesState ==
                    ModulesState.loading
            ? const LoadingWidget(message: 'Loading chapter')
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

    Widget displaySummarizedChapter = context.read<GptViewModel>().gptState ==
            GPTState.error
        ? ExceptionWidget(
            errorMessage: context.read<ModuleStudentViewModel>().errorMessage)
        : (context.read<GptViewModel>().gptState == GPTState.loading
            ? const LoadingWidget(message: 'Generating summarized version')
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        summarizedChapter.title,
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
                            summarizedChapter.content,
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
          summarizeTapped
              ? Expanded(child: displaySummarizedChapter)
              : Expanded(child: displayChapter),
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
              const SizedBox(width: 4,),
              context.watch<GptViewModel>().summarizeState == SummarizeState.loading
                  ? IconButton(
                      onPressed: () {},
                      icon: const CupertinoActivityIndicator(),
                    )
                  : ( context.watch<GptViewModel>().summarizeState == SummarizeState.success?
                  RoundedButton(
                      color: Theme.of(context).primaryColor,
                      title: 'Original Version',
                      onPressed: (){
                        setState(() {
                          summarizeTapped =false;
                          context.read<GptViewModel>().setSummarizeState(SummarizeState.initial);
                        });
                      }
                  ):
                  RoundedButton(
                      color: Theme.of(context).primaryColor,
                      title: 'Summarize',
                      onPressed: () async {
                        await context
                            .read<GptViewModel>()
                            .summarizeChapter(chapter);
                        if (context.mounted) {
                          setState(() {
                            summarizeTapped = true;
                            summarizedChapter =
                                context.read<GptViewModel>().chapter;
                          });
                        }
                      },
                    )),
              const SizedBox(width: 4,),
              RoundedButton(
                color: Theme.of(context).primaryColor,
                title: 'Test Yourself',
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => QuestionsPageStudent(
                        module: widget.module,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
