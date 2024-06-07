import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:brainify_flutter/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';
import '../utils/data_state.dart';

class UsersAdminRepository{

  Future<DataState> getAllUsers() async {
    final url = Uri.http(kBaseUrl, kGetAllUsers);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    List<User> users = [];
    try {
      http.Response response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      });
      final dynamic dynamicResponse = jsonDecode(response.body);
      if (response.statusCode == HttpStatus.ok) {
        final List<dynamic> dynamicResponse = jsonDecode(utf8.decode(response.bodyBytes));
        List<Map<String, dynamic>> listData = dynamicResponse.map((item) {
          return Map<String, dynamic>.from(item);
        }).toList();
        for (final Map<String, dynamic> map in listData) {
          User user = User.fromJson(map);
          users.add(user);
        }
        return DataSuccess<List<User>>(code: HttpStatus.ok, data: users);
      } else if (response.statusCode == HttpStatus.badRequest) {
        final Map<String, dynamic> mapResponse =
        Map<String, dynamic>.from(dynamicResponse);
        return DataFailure<String>(
            exception: mapResponse['message'], code: HttpStatus.badRequest);
      }else if (response.statusCode == HttpStatus.notFound) {
        final Map<String, dynamic> mapResponse =
        Map<String, dynamic>.from(dynamicResponse);
        return DataFailure<String>(
            exception: mapResponse['message'], code: HttpStatus.notFound);
      }else if (response.statusCode == 401 || response.statusCode == 403) {
        return const DataFailure<String>(
            exception: 'Session expired. Login!',
            code: HttpStatus.unauthorized);
      }
      return DataFailure<String>(
          exception: 'Connection with server failed. Try again!',
          code: response.statusCode);
    } on http.ClientException {
      return const DataFailure<String>(
          exception: 'Connection with server failed. Try again later.',
          code: 0);
    } on HttpException {
      return const DataFailure<String>(
          code: 1, exception: 'No Internet Connection');
    } on SocketException {
      return const DataFailure<String>(
          code: 2, exception: 'No Internet Connection');
    } on FormatException {
      return const DataFailure<String>(code: 3, exception: 'Invalid Format');
    } on TimeoutException {
      return const DataFailure<String>(
          code: 4, exception: 'Connection timeout, try again!');
    } catch (exception) {
      return const DataFailure<String>(
          code: 5, exception: 'Unexpected Error. Restart App');
    }
  }

  Future<DataState> updateUserRole(User user) async {
    final url = Uri.http(kBaseUrl, kChangeRole);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    try {
      http.Response response = await http.patch(url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
          body: json.encode(user.toJson()));
      final dynamic dynamicResponse = jsonDecode(response.body);
      final Map<String, dynamic> mapResponse =
      Map<String, dynamic>.from(dynamicResponse);
      if (response.statusCode == HttpStatus.ok ||
          response.statusCode == HttpStatus.created) {
        return const DataSuccess<void>(code: HttpStatus.ok);
      } else if (response.statusCode == HttpStatus.badRequest) {
        return DataFailure<String>(
            exception: mapResponse['message'], code: HttpStatus.badRequest);
      }
      return DataFailure<String>(
          exception: 'Connection with server failed. Try again!',
          code: response.statusCode);
    } on http.ClientException {
      return const DataFailure<String>(
          exception: 'Connection with server failed. Try again later.',
          code: 0);
    } on HttpException {
      return const DataFailure<String>(
          code: 1, exception: 'No Internet Connection');
    } on SocketException {
      return const DataFailure<String>(
          code: 2, exception: 'No Internet Connection');
    } on FormatException {
      return const DataFailure<String>(code: 3, exception: 'Invalid Format');
    } on TimeoutException {
      return const DataFailure<String>(
          code: 4, exception: 'Connection timeout, try again!');
    } catch (exception) {
      return const DataFailure<String>(
          code: 5, exception: 'Unexpected Error. Restart App');
    }
  }
}