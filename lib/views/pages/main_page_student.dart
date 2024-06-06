import 'package:brainify_flutter/views/components/all_courses_student_widget.dart';
import 'package:brainify_flutter/views/components/all_modules_student_widget.dart';
import 'package:brainify_flutter/views/components/gpt_chat_widget.dart';
import 'package:flutter/material.dart';

import '../../models/course.dart';

class StudentMainPage extends StatefulWidget {
  const StudentMainPage({super.key});

  @override
  State<StudentMainPage> createState() => _StudentMainPageState();
}

class _StudentMainPageState extends State<StudentMainPage> {
  late Course? selectedCourse;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
