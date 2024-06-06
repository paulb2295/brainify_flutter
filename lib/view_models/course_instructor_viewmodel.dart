import 'package:brainify_flutter/models/course.dart';
import 'package:brainify_flutter/repositories/course_instructor_repository.dart';
import 'package:flutter/cupertino.dart';

import '../utils/data_state.dart';

enum CoursesState { initial, loading, success, error }
class CourseInstructorViewModel with ChangeNotifier{

  final CourseInstructorRepository _courseInstructorRepository;

  CourseInstructorViewModel(this._courseInstructorRepository) {
    getCourses();
  }

  CoursesState _coursesState = CoursesState.initial;
  bool _loading = false;
  String _errorMessage = '';
  List<Course> _courses = [];


  //getters
  bool get loading => _loading;
  String get errorMessage => _errorMessage;
  CoursesState get coursesState => _coursesState;
  List<Course> get courses => _courses;


  void setLoading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  void createCourse(Course course) async {
    _coursesState = CoursesState.loading;
    setLoading(true);
    DataState response = await _courseInstructorRepository.createCourse(course);
    if (response is DataSuccess) {
      _coursesState = CoursesState.success;
      getCourses();
    } else if (response is DataFailure) {
      _coursesState = CoursesState.error;
      _errorMessage = response.exception.toString();
    }
    setLoading(false);
  }

  getCourses() async {
      setLoading(true);
      var response = await _courseInstructorRepository.getInstructorsCourses();
      if (response is DataSuccess) {
        _coursesState = CoursesState.success;
        setCourses(response.data);
      } else if (response is DataFailure) {
        _coursesState = CoursesState.error;
        _errorMessage = response.exception.toString();
      }
      setLoading(false);
  }

  setCourses(List<Course> courses) {
    _courses = courses;
    notifyListeners();
  }

  deleteCourse(Course course) async {
    setLoading(true);
    deleteCourseFomCourses(course);
    var response = await _courseInstructorRepository.deleteCourse(course.id!);

    if (response is DataSuccess) {
      _coursesState = CoursesState.success;
    } else if (response is DataFailure) {
      _coursesState = CoursesState.error;
      _errorMessage = response.exception.toString();
    }
    setLoading(false);
  }

  deleteCourseFomCourses(Course course) {
    _courses.remove(course);
    notifyListeners();
  }

  // void editCourse(Course course) async {
  //   _coursesState = CoursesState.loading;
  //   setLoading(true);
  //   DataState response = await _courseInstructorRepository.editCourse(course);
  //   if (response is DataSuccess) {
  //     _coursesState = CoursesState.success;
  //     getCourses();
  //   } else if (response is DataFailure) {
  //     _coursesState = CoursesState.error;
  //     _errorMessage = response.exception.toString();
  //   }
  //   setLoading(false);
  // }
}