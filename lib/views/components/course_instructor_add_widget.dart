import 'package:brainify_flutter/view_models/course_instructor_viewmodel.dart';
import 'package:brainify_flutter/views/components/rounded_button.dart';
import 'package:flutter/material.dart';
import '../../models/course.dart';
import 'package:provider/provider.dart';
import 'loading_widget.dart';

class CourseInstructorAddWidget extends StatefulWidget {
  const CourseInstructorAddWidget({super.key});

  @override
  State<CourseInstructorAddWidget> createState() =>
      _ChapterInstructorViewState();
}

class _ChapterInstructorViewState extends State<CourseInstructorAddWidget> {
  Widget displayCourse =
      const LoadingWidget(message: 'Conținutul capitolului se încarcă');

  final TextEditingController _titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void addCourse(Course course) {
    context.read<CourseInstructorViewModel>().createCourse(course);
  }

  void _submitNewCourseData() {
    if (_titleController.text.trim().isEmpty) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Titlu invalid'),
          content: const Text('Introduceți caractere alfa-numerice!'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(ctx, rootNavigator: true ).pop();
                },
                child: const Text('Am înțeles')),
          ],
        ),
      );
      return;
    }
    addCourse(
      Course(courseName: _titleController.text),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    _titleController.text = '';

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
      child: Column(
        children: [
          Center(
            child: TextField(
              controller: _titleController,
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
              maxLength: 200,
              decoration: const InputDecoration(
                label: Text('Titlul Cursului'),
                hintText: 'Titlul Cursului'
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RoundedButton(
                color: Theme.of(context).primaryColor,
                title: 'Înapoi',
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              const SizedBox(
                width: 8.0,
              ),
              RoundedButton(
                color: Theme.of(context).primaryColor,
                title: 'Salvează cursul nou',
                onPressed: () {
                  _submitNewCourseData();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
