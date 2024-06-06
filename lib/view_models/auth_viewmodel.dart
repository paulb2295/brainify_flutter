import 'package:brainify_flutter/repositories/auth_repository.dart';
import 'package:flutter/cupertino.dart';
import '../models/auth_request.dart';
import '../models/register_request.dart';
import '../utils/data_state.dart';

enum AuthState { initial, loading, authenticated, error }
class AuthViewModel with ChangeNotifier{

  final AuthRepository _authRepository;

  AuthViewModel(this._authRepository);

  bool _loading = false;
  AuthState _authState = AuthState.initial;
  String _errorMessage = '';

  bool get loading => _loading;
  AuthState get authState => _authState;
  String get errorMessage => _errorMessage;

  void setLoading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  Future<void> register(RegisterRequest user) async {
    setLoading(true);
    final response = await _authRepository.register(user);
    if (response is DataFailure) {
      _authState = AuthState.error;
      _errorMessage = response.exception.toString();
    } else if (response is DataSuccess) {
      _authState = AuthState.authenticated;
    }
    setLoading(false);
  }

  Future<void> login(AuthRequest user) async {
    setLoading(true);
    final response = await _authRepository.login(user);
    if (response is DataFailure) {
      _authState = AuthState.error;
      _errorMessage = response.exception.toString();
    } else if (response is DataSuccess) {
      _authState = AuthState.authenticated;
    }
    setLoading(false);
  }

  Future<bool> isTokenExpired() async{
    DataState response = await _authRepository.isTokenExpired();
    if(response is DataSuccess && response.code == 200){
      return false;
    }else{
      return true;
    }
  }
}