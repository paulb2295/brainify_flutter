import 'package:flutter/cupertino.dart';

import '../models/chapter.dart';
import '../models/course.dart';
import '../models/module.dart';
import '../repositories/modules_student_repository.dart';
import '../utils/data_state.dart';


enum ModulesState { initial, loading, success, error }
class ModuleStudentViewModel with ChangeNotifier{

  final ModuleStudentRepository _moduleStudentRepository;

  ModuleStudentViewModel(this._moduleStudentRepository) {
    //getModules(_course);
  }

  ModulesState _modulesState = ModulesState.initial;
  bool _loading = false;
  String _errorMessage = '';
  List<Module> _modules = [];
  Chapter _chapter = Chapter(title: '', content: '');
  late Course? _course;

  //getters
  bool get loading => _loading;
  String get errorMessage => _errorMessage;
  ModulesState get modulesState => _modulesState;
  List<Module> get modules => _modules;
  Chapter get chapter => _chapter;

  void setLoading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  // mandatory to tet before use of any function !!!
  Future<void> initialize(Course course) async {
    setCourse(course);
    await getModules();
  }

  void setCourse(Course course) {
    _course = course;
  }


  getModules() async {
    setLoading(true);
    var response =
    await _moduleStudentRepository.getModulesForCourse(_course!);
    if (response is DataSuccess) {
      _modulesState = ModulesState.success;
      setModules(response.data);
    } else if (response is DataFailure) {
      _modulesState = ModulesState.error;
      _errorMessage = response.exception.toString();
    }
    setLoading(false);
  }

  setModules(List<Module> courses) {
    _modules = courses;
    notifyListeners();
  }

  //*************
  getChapterForModule(Module module) async {
    setLoading(true);
    var response =
    await _moduleStudentRepository.getChapterForModule(module);
    if (response is DataSuccess) {
      _modulesState = ModulesState.success;
      setChapter(response.data);
    } else if (response is DataFailure) {
      _modulesState = ModulesState.error;
      _errorMessage = response.exception.toString();
    }
    setLoading(false);
  }

  setChapter(Chapter chapter){
    _chapter = chapter;
    notifyListeners();
  }
  //**************


  void resetModuleInstructorVM() {
    _modulesState = ModulesState.initial;
    _loading = false;
    _errorMessage = '';
    _modules = [];
    _course = null;
    _chapter = Chapter(title: '', content: '');
  }
}
