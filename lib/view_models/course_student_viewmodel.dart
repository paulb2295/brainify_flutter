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
  List<Course> _myCourses = [];
  List<Course> _allCourses = [];


  //getters
  bool get loading => _loading;
  String get errorMessage => _errorMessage;
  CoursesState get coursesState => _coursesState;
  List<Course> get myCourses => _myCourses;
  List<Course> get allCourses => _allCourses;

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
        setAllCourses(response.data);
      } else if (response is DataFailure) {
        _coursesState = CoursesState.error;
        _errorMessage = response.exception.toString();
      }
      setLoading(false);
    }
  }

  setCourses(List<Course> courses) {
    _myCourses = courses;
    notifyListeners();
  }

  setAllCourses(List<Course> courses) {
    _allCourses = courses;
    notifyListeners();
  }

  enrolToCourse(Course course) async{
    var response = await _courseStudentRepository.enrollToCourse(course);
    if (response is DataSuccess) {
      _coursesState = CoursesState.success;
    } else if (response is DataFailure) {
      _coursesState = CoursesState.error;
      _errorMessage = response.exception.toString();
    }
  }
}