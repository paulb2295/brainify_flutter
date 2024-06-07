import 'package:brainify_flutter/models/gpt_input.dart';
import 'package:brainify_flutter/repositories/gpt_func_repository.dart';
import 'package:brainify_flutter/utils/enums/gpt_actions_enum.dart';
import 'package:flutter/cupertino.dart';

import '../models/chapter.dart';
import '../utils/data_state.dart';

enum GPTState { initial, loading, success, error }
enum ChatState { initial, loading, success, error }
enum SummarizeState { initial, loading, success, error }

class GptViewModel with ChangeNotifier {
  final GptFuncRepository _gptFuncRepository;

  GptViewModel(this._gptFuncRepository);

  bool _loading = false;
  GPTState _gptState = GPTState.initial;
  ChatState _chatState = ChatState.initial;
  SummarizeState _summarizeState = SummarizeState.initial;
  String _errorMessage = '';
  Chapter _chapter = Chapter(title: '', content: '');
  String _gptMessage = '';
  String _currentUserMessage = '';

  bool get loading => _loading;
  GPTState get gptState => _gptState;
  ChatState get chatState => _chatState;
  SummarizeState get summarizeState => _summarizeState;
  String get errorMessage => _errorMessage;
  Chapter get chapter => _chapter;
  String get gptMessage => _gptMessage;
  String get currentUserMessage => _currentUserMessage;

  void setCurrentUserMessage(String message) {
    _currentUserMessage = message;
    notifyListeners();
  }

  void setSummarizeState(SummarizeState state){
    _summarizeState = state;
  }

  void setLoading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  Future<void> vectorSearch(String input) async {
    GPTInput gptInput = GPTInput(input: input);
    _gptState = GPTState.loading;
    setLoading(true);
    final response = await _gptFuncRepository.vectorSearch(gptInput);
    if (response is DataFailure) {
      _gptState = GPTState.error;
      _errorMessage = response.exception.toString();
    } else if (response is DataSuccess) {
      _gptState = GPTState.success;
      _chapter = response.data;
    }
    _gptState = GPTState.success;
    setLoading(false);
  }

  Future<void> chatBot(String text) async {
    _chatState = ChatState.loading;
    GPTInput gptInput = GPTInput(input: text, action: GptActions.CHAT);
    setLoading(true);
    final response = await _gptFuncRepository.chatBot(gptInput);
    if (response is DataFailure) {
      _chatState = ChatState.error;
      _errorMessage = response.exception.toString();
    } else if (response is DataSuccess) {
      _gptMessage = response.data;
      _chatState = ChatState.success;
    }
    setLoading(false);
    _chatState = ChatState.initial;
  }

  Future<void> summarizeChapter(Chapter chapterToSummarize) async {
    _summarizeState = SummarizeState.loading;
    setLoading(true);
    GPTInput gptInput = GPTInput(
        input: chapterToSummarize.content, action: GptActions.SUMMARIZE);
    final response = await _gptFuncRepository.summarizeText(gptInput);
    if (response is DataFailure) {
      _summarizeState = SummarizeState.error;
      _errorMessage = response.exception.toString();
    } else if (response is DataSuccess) {
      Chapter resp = Chapter(title: chapterToSummarize.title, content: response.data);
      _summarizeState = SummarizeState.success;
      setChapter(resp);
    }
    setLoading(false);

  }

  void setChapter(Chapter chapter){
    _chapter = chapter;
    notifyListeners();
  }
}
