import 'package:brainify_flutter/view_models/module_student_viewmodel.dart';
import 'package:brainify_flutter/views/components/chapter_student_widget.dart';
import 'package:brainify_flutter/views/components/module_student_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/course.dart';
import '../../models/module.dart';
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

  void _openAddChapterOverlay(Module module) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (ctx) => ChapterStudentView(module: module));
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
        : ListView.builder(
            itemCount: modules.length,
            itemBuilder: (context, index) {
              return ModuleStudentWidget(
                  module: modules[index],
                  course: widget.course,
                  onView: () {
                    _openAddChapterOverlay(modules[index]);
                  });
            },
          );

    return modulesList;
  }
}
