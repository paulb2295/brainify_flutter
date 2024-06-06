import 'package:brainify_flutter/models/gpt_input.dart';
import 'package:brainify_flutter/repositories/gpt_func_repository.dart';
import 'package:brainify_flutter/utils/enums/gpt_actions_enum.dart';
import 'package:flutter/cupertino.dart';

import '../models/chapter.dart';
import '../utils/data_state.dart';

enum GPTState { initial, loading, success, error }

class GptViewModel with ChangeNotifier {
  final GptFuncRepository _gptFuncRepository;

  GptViewModel(this._gptFuncRepository);

  bool _loading = false;
  GPTState _gptState = GPTState.initial;
  String _errorMessage = '';
  late Chapter _chapter;
  String _gptMessage = '';

  bool get loading => _loading;
  GPTState get gptState => _gptState;
  String get errorMessage => _errorMessage;
  Chapter get chapter => _chapter;
  String get gptMessage => _gptMessage;

  void setLoading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  void vectorSearch(GPTInput gptInput) async {
    setLoading(true);
    final response = await _gptFuncRepository.vectorSearch(gptInput);
    if (response is DataFailure) {
      _gptState = GPTState.error;
      _errorMessage = response.exception.toString();
    } else if (response is DataSuccess) {
      _gptState = GPTState.success;
      _chapter = response.data;
    }
    setLoading(false);
  }

  void chatBot(String text) async {
    GPTInput gptInput = GPTInput(input: text, action: GptActions.CHAT);
    setLoading(true);
    final response = await _gptFuncRepository.chatBot(gptInput);
    if (response is DataFailure) {
      _gptState = GPTState.error;
      _errorMessage = response.exception.toString();
    } else if (response is DataSuccess) {
      _gptState = GPTState.success;
      _gptMessage = response.data;
    }
    setLoading(false);
  }

  void summarizeChapter(Chapter chapterToSummarize) async {
    setLoading(true);
    GPTInput gptInput = GPTInput(
        input: chapterToSummarize.content, action: GptActions.SUMMARIZE);
    final response = await _gptFuncRepository.summarizeText(gptInput);
    if (response is DataFailure) {
      _gptState = GPTState.error;
      _errorMessage = response.exception.toString();
    } else if (response is DataSuccess) {
      _gptState = GPTState.success;
      _gptMessage = response.data;
    }
    setLoading(false);
  }
}
