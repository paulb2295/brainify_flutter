import 'package:brainify_flutter/view_models/course_student_viewmodel.dart';
import 'package:brainify_flutter/views/components/course_student_widget.dart';
import 'package:brainify_flutter/views/components/exception_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/course.dart';
import 'loading_widget.dart';

class AllCoursesStudentWidget extends StatefulWidget {
  const AllCoursesStudentWidget(
      {super.key,
        required this.onView});

  final Function(Course) onView;
  @override
  State<AllCoursesStudentWidget> createState() =>
      _AllCoursesStudentWidgetState();
}

class _AllCoursesStudentWidgetState
    extends State<AllCoursesStudentWidget> {
  List<Course> courses = [];
  Widget coursesList = const LoadingWidget(message: 'Loading Courses');

  @override
  void initState() {
    context.read<CourseStudentViewModel>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    courses = context.watch<CourseStudentViewModel>().courses;
    coursesList = context.watch<CourseStudentViewModel>().coursesState ==
        CoursesState.error
        ? ExceptionWidget(errorMessage:  context.read<CourseStudentViewModel>().errorMessage)
        : Scaffold(
      backgroundColor: const Color.fromARGB(190, 40, 42, 53),
      body: ListView.builder(
        itemCount: courses.length,
        itemBuilder: (context, index) {
          return CourseStudentWidget(
              course: courses[index],
              onView: (){
                widget.onView(courses[index]);
              }
             );
        },
      ),
    );
    return coursesList;
  }
}