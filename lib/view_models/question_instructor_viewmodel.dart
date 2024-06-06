import 'package:brainify_flutter/models/question.dart';
import 'package:flutter/cupertino.dart';
import '../models/chapter.dart';
import '../models/module.dart';
import '../repositories/modules_instructor_repository.dart';
import '../utils/data_state.dart';

enum QuestionsState { initial, loading, success, error }
class QuestionInstructorViewModel with ChangeNotifier{

  final ModulesInstructorRepository _modulesInstructorRepository;

  QuestionInstructorViewModel(this._modulesInstructorRepository);

  QuestionsState _questionsState = QuestionsState.initial;
  bool _loading = false;
  String _errorMessage = '';
  List<Question> _questions = [];
  late Module? _module;

  //getters
  bool get loading => _loading;
  String get errorMessage => _errorMessage;
  QuestionsState get questionState => _questionsState;
  List<Question> get questions => _questions;

  // mandatory to call before use of any function !!!
  Future<void> initialize(Module module) async {
    setModule(module);
    await getQuestions();
  }

  void setLoading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  void setModule(Module module) {
    _module = module;
  }

  void generateQuestions(Chapter chapter, int courseId, int questionNumber) async {
    _questionsState = QuestionsState.loading;
    setLoading(true);
    DataState response = await _modulesInstructorRepository.generateQuestions(
         _module!, courseId, questionNumber );
    if (response is DataSuccess) {
      _questionsState = QuestionsState.success;
      setQuestions(response.data);
    } else if (response is DataFailure) {
      _questionsState = QuestionsState.error;
      _errorMessage = response.exception.toString();
    }
    setLoading(false);
  }

  void saveGenerateQuestions(List<Question> questions) async {
    _questionsState = QuestionsState.loading;
    setLoading(true);
    DataState response = await _modulesInstructorRepository.saveGeneratedQuestions(questions);
    if (response is DataSuccess) {
      _questionsState = QuestionsState.success;
      getQuestions();
    } else if (response is DataFailure) {
      _questionsState = QuestionsState.error;
      _errorMessage = response.exception.toString();
    }
    setLoading(false);
  }

  getQuestions() async {
    setLoading(true);
    var response =
    await _modulesInstructorRepository.getQuestionsForModule(_module!);
    if (response is DataSuccess) {
      _questionsState = QuestionsState.success;
      setQuestions(response.data);
    } else if (response is DataFailure) {
      _questionsState = QuestionsState.error;
      _errorMessage = response.exception.toString();
    }
    setLoading(false);
  }

  setQuestions(List<Question> questions) {
    _questions = questions;
    notifyListeners();
  }

  void resetQuestionInstructorVM() {
    _questionsState = QuestionsState.initial;
    _loading = false;
    _errorMessage = '';
    _questions = [];
    _module = null;
  }
}