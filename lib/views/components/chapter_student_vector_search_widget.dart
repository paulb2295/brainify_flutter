import 'package:brainify_flutter/view_models/gpt_viewmodel.dart';
import 'package:brainify_flutter/views/components/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/chapter.dart';
import 'exception_widget.dart';
import 'loading_widget.dart';

class ChapterStudentVectorSearchView extends StatefulWidget {
  const ChapterStudentVectorSearchView({super.key, required this.chapter});

  final Chapter chapter;

  @override
  State<ChapterStudentVectorSearchView> createState() => _ChapterStudentVectorSearchViewState();
}

class _ChapterStudentVectorSearchViewState extends State<ChapterStudentVectorSearchView> {
  Widget displayChapter =
      const LoadingWidget(message: 'Chapter content loading');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // context.read<ModuleStudentViewModel>().getChapterForModule(widget.module);
    });
  }

  @override
  Widget build(BuildContext context) {
    displayChapter = context.read<GptViewModel>().gptState == GPTState.error
        ? ExceptionWidget(
            errorMessage: context.read<GptViewModel>().errorMessage)
        : SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    widget.chapter.title,
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
                        widget.chapter.content,
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
          );

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
            ],
          ),
        ],
      ),
    );
  }
}
