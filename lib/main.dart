import 'package:brainify_flutter/repositories/auth_repository.dart';
import 'package:brainify_flutter/repositories/course_instructor_repository.dart';
import 'package:brainify_flutter/repositories/courses_student_repository.dart';
import 'package:brainify_flutter/repositories/gpt_func_repository.dart';
import 'package:brainify_flutter/repositories/modules_instructor_repository.dart';
import 'package:brainify_flutter/repositories/modules_student_repository.dart';
import 'package:brainify_flutter/utils/constants.dart';
import 'package:brainify_flutter/utils/injection_container.dart';
import 'package:brainify_flutter/view_models/auth_viewmodel.dart';
import 'package:brainify_flutter/view_models/course_instructor_viewmodel.dart';
import 'package:brainify_flutter/view_models/course_student_viewmodel.dart';
import 'package:brainify_flutter/view_models/gpt_viewmodel.dart';
import 'package:brainify_flutter/view_models/module_instructor_viewmodel.dart';
import 'package:brainify_flutter/view_models/module_student_viewmodel.dart';
import 'package:brainify_flutter/view_models/question_instructor_viewmodel.dart';
import 'package:brainify_flutter/view_models/question_student_viewmodel.dart';
import 'package:brainify_flutter/views/pages/main_page_instructor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:brainify_flutter/views/pages/login_page.dart';

void main() async{
  await initializeDependencies();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<AuthViewModel>(
          create: (_) => AuthViewModel(locator.get<AuthRepository>())),
      ChangeNotifierProvider<CourseInstructorViewModel>(
          create: (_) => CourseInstructorViewModel(locator.get<CourseInstructorRepository>())),
      ChangeNotifierProvider<CourseStudentViewModel>(
          create: (_) => CourseStudentViewModel(locator.get<CoursesStudentRepository>())),
      ChangeNotifierProvider<GptViewModel>(
          create: (_) => GptViewModel(locator.get<GptFuncRepository>())),
      ChangeNotifierProvider<ModuleInstructorViewModel>(
          create: (_) => ModuleInstructorViewModel(locator.get<ModulesInstructorRepository>())),
      ChangeNotifierProvider<ModuleStudentViewModel>(
          create: (_) => ModuleStudentViewModel(locator.get<ModuleStudentRepository>())),
      ChangeNotifierProvider<QuestionInstructorViewModel>(
          create: (_) => QuestionInstructorViewModel(locator.get<ModulesInstructorRepository>())),
      ChangeNotifierProvider<QuestionStudentViewModel>(
          create: (_) => QuestionStudentViewModel(locator.get<ModuleStudentRepository>())),
    ],
      child: const MyApp()),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<String> _tokenFuture;

  @override
  void initState() {
    super.initState();
    _tokenFuture = getToken();
  }

  Future<String> getToken() async {
    bool tokenExpired = true;
    tokenExpired = await context.read<AuthViewModel>().isTokenExpired();
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getString('token') != null && !tokenExpired) {
      return prefs.getString('token')!;
    } else {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: _tokenFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CupertinoActivityIndicator(
              radius: 30,
            );
          }
          final token = snapshot.data;
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Brainify',
            theme: ThemeData().copyWith(
              colorScheme: kColorScheme,
              appBarTheme: const AppBarTheme().copyWith(
                  backgroundColor: kColorScheme.onPrimaryContainer,
                  foregroundColor: kColorScheme.primaryContainer),
              cardTheme: const CardTheme()
                  .copyWith(color: kColorScheme.secondaryContainer),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                    backgroundColor: kColorScheme.primaryContainer),
              ),
              textTheme: ThemeData().textTheme.copyWith(
                titleLarge: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: kColorScheme.onSecondaryContainer,
                  fontSize: 16,
                ),
              ),
            ),
            home: token != null && token.isNotEmpty ? const InstructorMainPage() : const LoginScreen(),
          );
        });
  }
}




