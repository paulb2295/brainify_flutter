import 'package:brainify_flutter/views/components/app_bar_admin.dart';
import 'package:flutter/material.dart';

import '../../models/course.dart';
import '../components/all_courses_instructor_widget.dart';
import '../components/all_modules_instructor_widget.dart';
import '../components/gpt_chat_widget.dart';

class AdminMainPage extends StatefulWidget {
  const AdminMainPage({super.key});

  @override
  State<AdminMainPage> createState() => _AdminMainPageState();
}

class _AdminMainPageState extends State<AdminMainPage> {
  Course? selectedCourse;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AdminAppBarWidget(),
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: AllCoursesInstructorWidget(
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
                : AllModulesInstructorWidget(
                key: ValueKey(selectedCourse!.id),
                course: selectedCourse!
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
