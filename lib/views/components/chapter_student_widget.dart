import 'package:brainify_flutter/view_models/module_student_viewmodel.dart';
import 'package:brainify_flutter/views/components/loading_widget.dart';
import 'package:brainify_flutter/views/components/rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../models/module.dart';

class ChapterStudentView extends StatefulWidget {
  const ChapterStudentView({super.key, required this.module});

  final Module module;

  @override
  State<ChapterStudentView> createState() => _ChapterStudentViewState();
}

class _ChapterStudentViewState extends State<ChapterStudentView> {
  Widget displayChapter =
      const LoadingWidget(message: 'Chapter content loading');

  @override
  void initState() {
    super.initState();
    context.read<ModuleStudentViewModel>().getChapterForModule(widget.module);
  }

  @override
  Widget build(BuildContext context) {
    displayChapter = context.read<ModuleStudentViewModel>().modulesState ==
            ModulesState.error
        ? ErrorWidget(context.read<ModuleStudentViewModel>().errorMessage)
        : SingleChildScrollView(
          child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                      context.read<ModuleStudentViewModel>().chapter.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                Row(
                  children: [
                    const Expanded(
                      flex: 1,
                        child: SizedBox(),
                    ),
                    Expanded(
                      flex: 2,
                        child: Text(
                            context.read<ModuleStudentViewModel>().chapter.content,
                          textAlign: TextAlign.justify,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w400
                          ),
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
                  title: 'Test Yourself',
                  onPressed: () {

                  },
                ),
              ],
            ),
          ],
        ),
    );
  }
}
