import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../models/course.dart';

class CourseInstructorWidget extends StatelessWidget {
  final Course course;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onView;

  const CourseInstructorWidget({
    Key? key,
    required this.course,
    required this.onEdit,
    required this.onDelete,
    required this.onView,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: const EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.my_library_books_rounded,
                      size: 40.0, color: Colors.blue),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: Text(
                      course.courseName,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Tooltip(
                    message: 'Add Chapters',
                    child: IconButton(
                      icon: const Icon(Icons.add, color: Colors.blueAccent),
                      onPressed: onEdit,
                    ),
                  ),
                  Tooltip(
                    message: 'Delete Course',
                    child: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: onDelete,
                    ),
                  ),
                  Tooltip(
                    message: 'View Course Chapters',
                    child: IconButton(
                      icon: const Icon(Icons.visibility, color: Colors.green),
                      onPressed: onView,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
