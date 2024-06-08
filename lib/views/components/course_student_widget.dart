import 'package:brainify_flutter/view_models/course_student_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import '../../models/course.dart';

class CourseStudentWidget extends StatefulWidget {
  final Course course;
  final VoidCallback onView;
  final bool enrolled;
  final bool access;
  final VoidCallback onEnroll;

  const CourseStudentWidget({
    Key? key,
    required this.course,
    required this.onView,
    required this.enrolled,
    required this.access, required this.onEnroll,
  }) : super(key: key);

  @override
  State<CourseStudentWidget> createState() => _CourseStudentWidgetState();
}

class _CourseStudentWidgetState extends State<CourseStudentWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(Icons.my_library_books_rounded,
                size: 40.0, color: Colors.blue),
            const SizedBox(width: 16.0),
            Expanded(
              child: Text(
                widget.course.courseName,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 16.0),
            widget.access
                ? Tooltip(
                    message: 'View Course Chapters',
                    child: IconButton(
                      icon: const Icon(Icons.visibility, color: Colors.green),
                      onPressed: widget.onView,
                    ),
                  )
                : const Text(''),
            widget.enrolled
                ? const Text('')
                : Tooltip(
                    message: 'Enroll',
                    child: IconButton(
                      icon: const Icon(Icons.add_box_sharp,
                          color: Colors.blueAccent),
                      onPressed: () {
                        context
                            .read<CourseStudentViewModel>()
                            .enrolToCourse(widget.course);
                        widget.onEnroll();
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Success'),
                            content: Text('You enrolled successfully to ${widget.course.courseName}'),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(ctx, rootNavigator: true).pop();
                                  },
                                  child: const Text('OK')),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
