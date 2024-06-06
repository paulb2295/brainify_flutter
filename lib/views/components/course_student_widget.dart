import 'package:flutter/material.dart';

import '../../models/course.dart';

class CourseStudentWidget extends StatelessWidget {
  final Course course;
  final VoidCallback onView;

  const CourseStudentWidget({
    Key? key,
    required this.course,
    required this.onView,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(Icons.my_library_books_rounded, size: 40.0, color: Colors.blue),
            const SizedBox(width: 16.0),
            Expanded(
              child: Text(
                course.courseName,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 16.0),
            IconButton(
              icon: const Icon(Icons.visibility, color: Colors.green),
              onPressed: onView,
            ),
          ],
        ),
      ),
    );
  }
}