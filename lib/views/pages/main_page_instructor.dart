import 'package:brainify_flutter/views/components/all_courses_instructor_widget.dart';
import 'package:brainify_flutter/views/components/all_modules_instructor_widget.dart';
import 'package:flutter/material.dart';
import '../../models/course.dart';
import '../components/gpt_chat_widget.dart';

class InstructorMainPage extends StatefulWidget {
  const InstructorMainPage({super.key});

  @override
  State<InstructorMainPage> createState() => _InstructorMainPageState();
}

class _InstructorMainPageState extends State<InstructorMainPage> {
   Course? selectedCourse;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
