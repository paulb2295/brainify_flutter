import 'package:brainify_flutter/view_models/course_student_viewmodel.dart';
import 'package:brainify_flutter/views/components/course_student_widget.dart';
import 'package:brainify_flutter/views/components/exception_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/course.dart';
import 'loading_widget.dart';

class AllCoursesStudentWidget extends StatefulWidget {
  const AllCoursesStudentWidget({super.key, required this.onView});

  final Function(Course) onView;
  @override
  State<AllCoursesStudentWidget> createState() =>
      _AllCoursesStudentWidgetState();
}

class _AllCoursesStudentWidgetState extends State<AllCoursesStudentWidget> {
  List<Course> myCourses = [];
  List<Course> allCourses = [];
  Widget coursesList = const LoadingWidget(message: 'Loading Courses');
  Widget allCoursesList = const LoadingWidget(message: 'Loading Courses');
  bool allCoursesTapped = false;

  @override
  void initState() {
    context.read<CourseStudentViewModel>();
    super.initState();
  }

  bool isEnrolled(Course course, List<Course> myCoursesList) {
    return myCoursesList.any((myCourse) => myCourse.id == course.id);
  }

  @override
  Widget build(BuildContext context) {
    myCourses = context.watch<CourseStudentViewModel>().myCourses;
    coursesList = context.watch<CourseStudentViewModel>().coursesState ==
            CoursesState.error
        ? ExceptionWidget(
            errorMessage: context.read<CourseStudentViewModel>().errorMessage)
        : Scaffold(
            backgroundColor: const Color.fromARGB(255, 231, 233, 235),
            body: ListView.builder(
              itemCount: myCourses.length,
              itemBuilder: (context, index) {
                return CourseStudentWidget(
                  access: true,
                    enrolled: true,
                    course: myCourses[index],
                    onView: () {
                      widget.onView(myCourses[index]);
                    });
              },
            ),
          );
    allCourses = context.watch<CourseStudentViewModel>().allCourses;
    allCoursesList = context.watch<CourseStudentViewModel>().coursesState ==
            CoursesState.error
        ? ExceptionWidget(
            errorMessage: context.read<CourseStudentViewModel>().errorMessage)
        : (context.watch<CourseStudentViewModel>().coursesState ==
                CoursesState.success
            ? Scaffold(
                backgroundColor: const Color.fromARGB(255, 231, 233, 235),
                body: ListView.builder(
                  itemCount: allCourses.length,
                  itemBuilder: (context, index) {
                    return CourseStudentWidget(
                      access: isEnrolled(allCourses[index], myCourses),
                        enrolled: isEnrolled(allCourses[index], myCourses),
                        course: allCourses[index],
                        onView: () {
                          widget.onView(allCourses[index]);
                        });
                  },
                ),
              )
            : const LoadingWidget(message: 'Loading Courses'));

    return Column(
      children: [
        Container(
          color: const Color.fromARGB(255, 231, 233, 235),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () async {
                    setState(() {
                      allCoursesTapped = false;
                    });
                    await context.read<CourseStudentViewModel>().getCourses('MY');
                  },
                  child: const Text('Cursurile Mele'),
                ),
                const SizedBox(
                  width: 10.0,
                ),
                TextButton(
                  onPressed: () async {
                    setState(() {
                      allCoursesTapped = true;
                    });
                    await context.read<CourseStudentViewModel>().getCourses('ALL');
                  },
                  child: const Text('Toate Cursurile'),
                ),
              ],
            ),
          ),
        ),
        Expanded(child: allCoursesTapped ? allCoursesList : coursesList),
      ],
    );
  }
}
