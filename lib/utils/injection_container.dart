import 'package:brainify_flutter/repositories/auth_repository.dart';
import 'package:brainify_flutter/repositories/course_instructor_repository.dart';
import 'package:brainify_flutter/repositories/courses_student_repository.dart';
import 'package:brainify_flutter/repositories/gpt_func_repository.dart';
import 'package:brainify_flutter/repositories/modules_instructor_repository.dart';
import 'package:brainify_flutter/repositories/modules_student_repository.dart';
import 'package:brainify_flutter/repositories/users_admin_repository.dart';
import 'package:brainify_flutter/view_models/users_admin_viewmodel.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

Future<void> initializeDependencies() async{
  locator.registerSingleton<AuthRepository>(AuthRepository());
  locator.registerSingleton<CourseInstructorRepository>(CourseInstructorRepository());
  locator.registerSingleton<CoursesStudentRepository>(CoursesStudentRepository());
  locator.registerSingleton<GptFuncRepository>(GptFuncRepository());
  locator.registerSingleton<ModulesInstructorRepository>(ModulesInstructorRepository());
  locator.registerSingleton<ModuleStudentRepository>(ModuleStudentRepository());
  locator.registerSingleton<UsersAdminRepository>(UsersAdminRepository());
}