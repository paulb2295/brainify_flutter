import 'package:brainify_flutter/views/components/rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/chapter.dart';
import '../../models/course.dart';
import '../../models/module.dart';
import '../../view_models/module_instructor_viewmodel.dart';
import 'exception_widget.dart';
import 'loading_widget.dart';

class ModuleInstructorEditWidget extends StatefulWidget {
  const ModuleInstructorEditWidget(
      {super.key, required this.module, required this.course});

  final Module module;
  final Course course;

  @override
  State<ModuleInstructorEditWidget> createState() => _ChapterInstructorViewState();
}

class _ChapterInstructorViewState extends State<ModuleInstructorEditWidget> {
  Widget displayChapter =
      const LoadingWidget(message: 'Chapter content loading');

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

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
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void patchModule(Chapter editedChapter) {
    context
        .read<ModuleInstructorViewModel>()
        .editModuleChapter(editedChapter, widget.module, widget.course);
  }

  void _submitEditedChapterData() {
    if (_titleController.text.trim().isEmpty) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid Chapter Title'),
          content: const Text('Enter at least one alpha-numeric character!'),
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
    if (_contentController.text.trim().isEmpty) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid Chapter Content'),
          content: const Text('Enter at least one alpha-numeric character!'),
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
    patchModule(
      Chapter(title: _titleController.text, content: _contentController.text),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    Chapter chapter = context.watch<ModuleInstructorViewModel>().chapter;
    _titleController.text = chapter.title;
    _contentController.text = chapter.content;
    displayChapter = context.read<ModuleInstructorViewModel>().modulesState ==
            ModulesState.error
        ? ExceptionWidget(
            errorMessage:
                context.read<ModuleInstructorViewModel>().errorMessage)
        : SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: _titleController,
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                    maxLength: 200,
                    decoration: const InputDecoration(
                      label: Text('Chapter Title'),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(
                    height: 400,
                    child: TextField(
                      controller: _contentController,
                      maxLines: null,
                      expands: true,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                      decoration: const InputDecoration(
                        label: Text(
                          'Chapter Content',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
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
              const SizedBox(
                width: 8.0,
              ),
              RoundedButton(
                color: Theme.of(context).primaryColor,
                title: 'Save Edited Chapter',
                onPressed: () {
                  _submitEditedChapterData();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
