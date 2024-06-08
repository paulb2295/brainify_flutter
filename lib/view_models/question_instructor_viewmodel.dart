import 'package:brainify_flutter/models/question.dart';
import 'package:flutter/cupertino.dart';
import '../models/chapter.dart';
import '../models/module.dart';
import '../repositories/modules_instructor_repository.dart';
import '../utils/data_state.dart';

enum QuestionsState { initial, loading, success, error }
enum QuestionsGenerationState { initial, loading, success, error }
class QuestionInstructorViewModel with ChangeNotifier{

  final ModulesInstructorRepository _modulesInstructorRepository;

  QuestionInstructorViewModel(this._modulesInstructorRepository);

  QuestionsState _questionsState = QuestionsState.initial;
  QuestionsGenerationState _questionsGenerationState = QuestionsGenerationState.initial;
  bool _loading = false;
  String _errorMessage = '';
  List<Question> _questions = [];
  List<Question> _generatedQuestions = [];
  late Module? _module;

  //getters
  bool get loading => _loading;
  String get errorMessage => _errorMessage;
  QuestionsState get questionState => _questionsState;
  QuestionsGenerationState get questionGenerationState => _questionsGenerationState;
  List<Question> get questions => _questions;
  List<Question> get generatedQuestions => _generatedQuestions;

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
    _questionsGenerationState = QuestionsGenerationState.loading;
    setGeneratedQuestions([]);
    setLoading(true);
    DataState response = await _modulesInstructorRepository.generateQuestions(
         _module!, courseId, questionNumber );
    if (response is DataSuccess) {
      _questionsGenerationState = QuestionsGenerationState.success;
      setGeneratedQuestions(response.data);
    } else if (response is DataFailure) {
      _questionsGenerationState = QuestionsGenerationState.error;
      _errorMessage = response.exception.toString();
    }
    setLoading(false);
  }

  setGeneratedQuestions(List<Question> questions) {
    _generatedQuestions = questions;
    notifyListeners();
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
    setQuestions([]);
    _questionsState = QuestionsState.loading;
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