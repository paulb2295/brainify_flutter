import 'package:brainify_flutter/repositories/courses_student_repository.dart';
import 'package:flutter/cupertino.dart';

import '../models/course.dart';
import '../utils/data_state.dart';


enum CoursesState { initial, loading, success, error }
class CourseStudentViewModel with ChangeNotifier {

  final CoursesStudentRepository _courseStudentRepository;

  CourseStudentViewModel(this._courseStudentRepository) {
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

  getCourses([String? option]) async {
    setLoading(true);
    if(option == null || option.toUpperCase() == 'MY'){
    var response = await _courseStudentRepository.getStudentsCourses();
    if (response is DataSuccess) {
      _coursesState = CoursesState.success;
      setCourses(response.data);
    } else if (response is DataFailure) {
      _coursesState = CoursesState.error;
      _errorMessage = response.exception.toString();
    }
    setLoading(false);
    } else if (option.toUpperCase() == 'ALL'){
      var response = await _courseStudentRepository.getAllAvailableCourses();
      if (response is DataSuccess) {
        _coursesState = CoursesState.success;
        setCourses(response.data);
      } else if (response is DataFailure) {
        _coursesState = CoursesState.error;
        _errorMessage = response.exception.toString();
      }
      setLoading(false);
    }
  }

  setCourses(List<Course> courses) {
    _courses = courses;
    notifyListeners();
  }
}