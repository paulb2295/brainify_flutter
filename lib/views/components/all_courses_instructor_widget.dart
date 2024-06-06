import 'package:brainify_flutter/view_models/course_instructor_viewmodel.dart';
import 'package:brainify_flutter/views/components/course_instructor_add_widget.dart';
import 'package:brainify_flutter/views/components/course_instructor_widget.dart';
import 'package:brainify_flutter/views/components/exception_widget.dart';
import 'package:brainify_flutter/views/components/loading_widget.dart';
import 'package:brainify_flutter/views/components/module_instructor_add_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/course.dart';

class AllCoursesInstructorWidget extends StatefulWidget {
  const AllCoursesInstructorWidget({super.key, required this.onView});

  final Function(Course) onView;
  @override
  State<AllCoursesInstructorWidget> createState() =>
      _AllCoursesInstructorWidgetState();
}

class _AllCoursesInstructorWidgetState
    extends State<AllCoursesInstructorWidget> {
  List<Course> courses = [];
  Widget coursesList = const LoadingWidget(message: 'Loading Courses');

  void _openAddChapterOverlay(Course course) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (ctx) => ModuleInstructorAddWidget(course: course));
  }

  void _openAddCourseOverlay() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (ctx) => const CourseInstructorAddWidget());
  }

  @override
  void initState() {
    context.read<CourseInstructorViewModel>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    courses = context.watch<CourseInstructorViewModel>().courses;
    coursesList = context.watch<CourseInstructorViewModel>().coursesState ==
            CoursesState.error
        ? ExceptionWidget(errorMessage: context.read<CourseInstructorViewModel>().errorMessage)
        : Scaffold(
            backgroundColor: Color.fromARGB(190, 40, 42, 53),
            body: ListView.builder(
              itemCount: courses.length,
              itemBuilder: (context, index) {
                return CourseInstructorWidget(
                    course: courses[index],
                    onEdit: () {
                      _openAddChapterOverlay(courses[index]);
                    },
                    onDelete: () {
                      context
                          .read<CourseInstructorViewModel>()
                          .deleteCourse(courses[index]);
                    },
                    onView: (){
                      widget.onView(courses[index]);
                    }
                    );
              },
            ),
          );
    return Column(
      children: [
         Row(
          children: [
            const Text(
              'Cursurile Mele',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.w600
              ),
            ),
            const Spacer(),
            TextButton(
                onPressed: (){
                  _openAddCourseOverlay();
                },
                child: const Text( 'Adaugă Curs'),
            ),
          ],
        ),
        coursesList,
      ],
    );
  }
}
