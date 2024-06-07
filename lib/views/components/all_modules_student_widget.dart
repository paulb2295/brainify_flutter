import 'package:brainify_flutter/view_models/module_student_viewmodel.dart';
import 'package:brainify_flutter/views/components/chapter_student_vector_search_widget.dart';
import 'package:brainify_flutter/views/components/chapter_student_widget.dart';
import 'package:brainify_flutter/views/components/module_student_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../models/chapter.dart';
import '../../models/course.dart';
import '../../models/module.dart';
import '../../view_models/gpt_viewmodel.dart';
import 'loading_widget.dart';

class AllModulesStudentWidget extends StatefulWidget {
  const AllModulesStudentWidget({super.key, required this.course});

  final Course course;

  @override
  State<AllModulesStudentWidget> createState() =>
      _AllModulesStudentWidgetState();
}

class _AllModulesStudentWidgetState extends State<AllModulesStudentWidget> {
  List<Module> modules = [];
  Widget modulesList = const LoadingWidget(message: 'Loading Courses');
  final TextEditingController _controller = TextEditingController();

  void _openAddChapterOverlay(Module module) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (ctx) => ChapterStudentView(module: module));
  }

  void _openVectorSearchChapterOverlay(Chapter chapter) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (ctx) => ChapterStudentVectorSearchView(chapter: chapter));
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ModuleStudentViewModel>().initialize(widget.course);
    });
  }

  @override
  Widget build(BuildContext context) {
    modules = context.read<ModuleStudentViewModel>().modules;
    modulesList = context.watch<ModuleStudentViewModel>().modulesState ==
            ModulesState.error
        ? ErrorWidget(context.watch<ModuleStudentViewModel>().errorMessage)
        : Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                      ),
                      controller: _controller,
                      decoration:  const InputDecoration(
                        hintText: 'Chapter Search',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () async{
                      await context.read<GptViewModel>().vectorSearch(_controller.text);
                      if(context.mounted){
                        Chapter chapter = context.read<GptViewModel>().chapter;
                        _openVectorSearchChapterOverlay(chapter);
                      }
                    },
                    icon: context.watch<GptViewModel>().loading
                        ? CupertinoActivityIndicator(
                      color: Theme.of(context).colorScheme.primary,
                    )
                        : Icon(
                      Icons.send,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: modules.length,
                  itemBuilder: (context, index) {
                    return ModuleStudentWidget(
                        module: modules[index],
                        course: widget.course,
                        onView: () {
                          _openAddChapterOverlay(modules[index]);
                        });
                  },
                ),
            ),
          ],
        );

    return modulesList;
  }
}
