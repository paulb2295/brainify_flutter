import 'package:brainify_flutter/repositories/users_admin_repository.dart';
import 'package:flutter/cupertino.dart';

import '../models/user.dart';
import '../utils/data_state.dart';

enum UsersState { initial, loading, success, error }
class UsersAdminViewModel with ChangeNotifier{
  final UsersAdminRepository _usersAdminRepository;

  UsersAdminViewModel(this._usersAdminRepository){
    getUsers();
  }

  UsersState _usersState = UsersState.initial;
  bool _loading = false;
  String _errorMessage = '';
  List<User> _users = [];

  //getters
  bool get loading => _loading;
  String get errorMessage => _errorMessage;
  UsersState get usersState => _usersState;
  List<User> get users => _users;


  void setLoading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  getUsers() async {
    _usersState = UsersState.loading;
    setLoading(true);
    var response = await _usersAdminRepository.getAllUsers();
    if (response is DataSuccess) {
      setUsers(response.data);
      _usersState = UsersState.success;
    } else if (response is DataFailure) {
      _usersState = UsersState.error;
      _errorMessage = response.exception.toString();
    }
    setLoading(false);
  }

  setUsers(List<User> users) {
    _users = users;
    notifyListeners();
  }

void editRole(User user) async {
  _usersState = UsersState.loading;
  setLoading(true);
  DataState response = await _usersAdminRepository.updateUserRole(user);
  if (response is DataSuccess) {
    _usersState = UsersState.success;
    getUsers();
  } else if (response is DataFailure) {
    _usersState = UsersState.error;
    _errorMessage = response.exception.toString();
  }
  setLoading(false);
}
}