import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/course.dart';
import '../../models/module.dart';

class ModuleStudentWidget extends StatelessWidget {
  final Course course;
  final Module module;
  final VoidCallback onView;

  const ModuleStudentWidget({
    Key? key,
    required this.course,
    required this.onView, required this.module,
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
            const Icon(Icons.content_paste_go, size: 40.0, color: Colors.blue),
            const SizedBox(width: 16.0),
            Expanded(
              child: Text(
                module.moduleName,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 16.0),
            Tooltip(
              message: 'View Chapter Content',
              child: IconButton(
                icon: const Icon(Icons.visibility, color: Colors.green),
                onPressed: onView,
              ),
            ),
          ],
        ),
      ),
    );
  }
}