import 'package:brainify_flutter/views/components/all_courses_student_widget.dart';
import 'package:brainify_flutter/views/components/all_modules_student_widget.dart';
import 'package:brainify_flutter/views/components/app_bar_student_widget.dart';
import 'package:brainify_flutter/views/components/gpt_chat_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/chapter.dart';
import '../../models/course.dart';
import '../../view_models/gpt_viewmodel.dart';
import '../components/chapter_student_vector_search_widget.dart';

class StudentMainPage extends StatefulWidget {
  const StudentMainPage({super.key});

  @override
  State<StudentMainPage> createState() => _StudentMainPageState();
}

class _StudentMainPageState extends State<StudentMainPage> {
  Course? selectedCourse;




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const StudentAppBarWidget(),
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: AllCoursesStudentWidget(
              onView: (course) {
                setState(() {
                  selectedCourse = course;
                });
              },
            ),
          ),
          Expanded(
            flex: 2,
            child: selectedCourse == null
                ? const Text('')
                : AllModulesStudentWidget(
              key: ValueKey(selectedCourse!.id),
                    course: selectedCourse!,
                  ),
          ),
          Expanded(
            flex: 1,
            child: ChatPage(),
          ),
        ],
      ),
    );
  }
}
