import 'package:brainify_flutter/models/register_request.dart';
import 'package:brainify_flutter/repositories/auth_repository.dart';
import 'package:brainify_flutter/repositories/course_instructor_repository.dart';
import 'package:brainify_flutter/repositories/courses_student_repository.dart';
import 'package:brainify_flutter/repositories/gpt_func_repository.dart';
import 'package:brainify_flutter/repositories/modules_instructor_repository.dart';
import 'package:brainify_flutter/repositories/modules_student_repository.dart';
import 'package:brainify_flutter/utils/constants.dart';
import 'package:brainify_flutter/utils/enums/roles_enum.dart';
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
import 'package:brainify_flutter/views/pages/main_page_student.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:brainify_flutter/views/pages/login_page.dart';

import 'models/user.dart';

void main() async{
  await initializeDependencies();
   runApp (const MyAppWrapper()
  //(MultiProvider(
  //   providers: [
  //     ChangeNotifierProvider<AuthViewModel>(
  //         create: (_) => AuthViewModel(locator.get<AuthRepository>())),
  //     ChangeNotifierProvider<CourseInstructorViewModel>(
  //         create: (_) => CourseInstructorViewModel(locator.get<CourseInstructorRepository>())),
  //     ChangeNotifierProvider<CourseStudentViewModel>(
  //         create: (_) => CourseStudentViewModel(locator.get<CoursesStudentRepository>())),
  //     ChangeNotifierProvider<GptViewModel>(
  //         create: (_) => GptViewModel(locator.get<GptFuncRepository>())),
  //     ChangeNotifierProvider<ModuleInstructorViewModel>(
  //         create: (_) => ModuleInstructorViewModel(locator.get<ModulesInstructorRepository>())),
  //     ChangeNotifierProvider<ModuleStudentViewModel>(
  //         create: (_) => ModuleStudentViewModel(locator.get<ModuleStudentRepository>())),
  //     ChangeNotifierProvider<QuestionInstructorViewModel>(
  //         create: (_) => QuestionInstructorViewModel(locator.get<ModulesInstructorRepository>())),
  //     ChangeNotifierProvider<QuestionStudentViewModel>(
  //         create: (_) => QuestionStudentViewModel(locator.get<ModuleStudentRepository>())),
  //   ],
  //     child: const MyApp()),
  );
}

class MyAppWrapper extends StatefulWidget {
  const MyAppWrapper({super.key});

  @override
  _MyAppWrapperState createState() => _MyAppWrapperState();
}

class _MyAppWrapperState extends State<MyAppWrapper> {
  @override
  Widget build(BuildContext context) {
    return _buildApp();
  }

  Widget _buildApp() {
    return MultiProvider(
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
      child: const MyApp(),
    );
  }

  void _resetProviders() {
    setState(() {});
  }

  void logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    _resetProviders();
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //late Future<String> _credentialsFuture;
  late Future<List<dynamic>> _credentialsFuture;

  @override
  void initState() {
    super.initState();
    _credentialsFuture = getCredentials();
  }

  // Future<String> getToken() async {
  //   //bool tokenExpired = true;
  //   //tokenExpired = await context.read<AuthViewModel>().isTokenExpired();
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //
  //   if (prefs.getString('token') != null) {
  //     return prefs.getString('token')!;
  //   } else {
  //     return '';
  //   }
  // }

  Future<List<dynamic>> getCredentials() async{
    List<dynamic> credentialsList = [];
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    if(token != null && !JwtDecoder.isExpired(token)){
      credentialsList.add(token);
      Map<String, dynamic> decodedToken =  JwtDecoder.decode(token);
      User user = User.fromJson(decodedToken);
      credentialsList.add(user);
    }
    return credentialsList;
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder<List<dynamic>>(
        future: _credentialsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CupertinoActivityIndicator(
              radius: 30,
            );
          }
          final credentials = snapshot.data;
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
            home: credentials != null && credentials.isNotEmpty && credentials.length == 2 ?
            pageRoute(credentials[1])
                : const LoginScreen(),
          );
        });
  }
}


Widget pageRoute(User user){
  if(user.role == Role.ADMIN){
    return const InstructorMainPage();
  } else if(user.role == Role.INSTRUCTOR){
    return const InstructorMainPage();
  }else{
    return const StudentMainPage();
  }
}






