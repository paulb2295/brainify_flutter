import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../models/course.dart';
import '../../models/module.dart';

class ModuleInstructorWidget extends StatelessWidget {
  final Module module;
  final Course course;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onView;

  const ModuleInstructorWidget({
    Key? key,
    required this.course,
    required this.onEdit,
    required this.onDelete,
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
              message: 'Add Chapter content',
              child: IconButton(
                icon: const Icon(Icons.edit, color: Colors.blueAccent),
                onPressed: onEdit,
              ),
            ),
            Tooltip(
              message: 'Delete Chapter',
              child: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: onDelete,
              ),
            ),
            Tooltip(
              message: 'View Chapter content',
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