import 'package:brainify_flutter/models/module.dart';
import 'package:brainify_flutter/view_models/module_instructor_viewmodel.dart';
import 'package:brainify_flutter/views/components/chapter_instructor_widget.dart';
import 'package:brainify_flutter/views/components/exception_widget.dart';
import 'package:brainify_flutter/views/components/module_instructor_edit_widget.dart';
import 'package:brainify_flutter/views/components/module_instructor_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/course.dart';
import 'loading_widget.dart';

class AllModulesInstructorWidget extends StatefulWidget {
  const AllModulesInstructorWidget(
      {super.key,
      required this.course,
      });

  final Course course;


  @override
  State<AllModulesInstructorWidget> createState() =>
      _AllModulesInstructorWidgetState();
}

class _AllModulesInstructorWidgetState
    extends State<AllModulesInstructorWidget> {
  List<Module> modules = [];
  Widget modulesList = const LoadingWidget(message: 'Capitolele se încarcă');

  void _openChapterOverlay(Module module) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (ctx) => ChapterInstructorView(module: module, course: widget.course));
  }

  void _openEditChapterOverlay(Module module) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (ctx) => ModuleInstructorEditWidget(module: module, course: widget.course));
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ModuleInstructorViewModel>().initialize(widget.course);
    });
  }

  @override
  Widget build(BuildContext context) {
    modules = context.read<ModuleInstructorViewModel>().modules;

    modulesList = context.watch<ModuleInstructorViewModel>().modulesState ==
            ModulesState.error
        ? ExceptionWidget(errorMessage: context.watch<ModuleInstructorViewModel>().errorMessage)
        : ListView.builder(
            itemCount: modules.length,
            itemBuilder: (context, index) {
              return ModuleInstructorWidget(
                  course: widget.course,
                  module: modules[index],
                  onEdit: (){
                    _openEditChapterOverlay(modules[index]);
                  },
                  onDelete: (){
                    context.read<ModuleInstructorViewModel>().deleteModule(modules[index]);
                  },
                  onView: () {
                    _openChapterOverlay(modules[index]);
                  });
            },
          );

    return modulesList;
  }
}
