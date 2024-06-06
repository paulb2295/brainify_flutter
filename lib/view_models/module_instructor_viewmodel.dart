import 'package:brainify_flutter/models/module.dart';
import 'package:flutter/cupertino.dart';

import '../models/chapter.dart';
import '../models/course.dart';
import '../repositories/modules_instructor_repository.dart';
import '../utils/data_state.dart';

enum ModulesState { initial, loading, success, error }

class ModuleInstructorViewModel with ChangeNotifier {
  final ModulesInstructorRepository _modulesInstructorRepository;

  ModuleInstructorViewModel(this._modulesInstructorRepository) {
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
  Chapter get chapter => _chapter!;

  // mandatory to call before use of any function !!!
  Future<void> initialize(Course course) async {
    setCourse(course);
    await getModules();
  }

  void setLoading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  void setCourse(Course course) {
    _course = course;
  }

  void addModuleToCourse(Chapter chapter, Course course) async {
    _modulesState = ModulesState.loading;
    setLoading(true);
    DataState response = await _modulesInstructorRepository.addModuleToCourse(
        chapter, course.id!);
    if (response is DataSuccess) {
      _modulesState = ModulesState.success;
      getModules();
    } else if (response is DataFailure) {
      _modulesState = ModulesState.error;
      _errorMessage = response.exception.toString();
    }
    setLoading(false);
  }

  getModules() async {
    setLoading(true);
    var response =
        await _modulesInstructorRepository.getModulesForCourse(_course!);
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
        await _modulesInstructorRepository.getChapterForModule(module);
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

  deleteModule(Module module) async {
    setLoading(true);
    deleteModuleFomModules(module);
    var response = await _modulesInstructorRepository.deleteModuleFromCourse(_course!.id!,module.id!);

    if (response is DataSuccess) {
      _modulesState = ModulesState.success;
    } else if (response is DataFailure) {
      _modulesState = ModulesState.error;
      _errorMessage = response.exception.toString();
    }
    setLoading(false);
  }

  deleteModuleFomModules(Module module) {
    _modules.remove(module);
    notifyListeners();
  }

void editModuleChapter(Chapter chapter, Module module, Course course) async {
  _modulesState = ModulesState.loading;
  setLoading(true);
  DataState response = await _modulesInstructorRepository.editModuleChapterContent(chapter, course.id!, module.id!);
  if (response is DataSuccess) {
    _modulesState = ModulesState.success;
    getModules();
  } else if (response is DataFailure) {
    _modulesState = ModulesState.error;
    _errorMessage = response.exception.toString();
  }
  setLoading(false);
}

  void resetModuleInstructorVM() {
    _modulesState = ModulesState.initial;
     _loading = false;
     _errorMessage = '';
     _modules = [];
     _course = null;
     _chapter = Chapter(title: '', content: '');
  }
}
