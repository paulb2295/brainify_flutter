import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../models/auth_request.dart';
import '../models/auth_response.dart';
import '../models/register_request.dart';
import '../utils/constants.dart';
import '../utils/data_state.dart';
import 'dart:io';

class AuthRepository {
  Future<DataState> register(RegisterRequest user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final url = Uri.http(kBaseUrl, kRegister);
    try {
      http.Response response = await http.post(url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode(user.toJson()));
      final dynamic dynamicResponse = jsonDecode(response.body);
      final Map<String, dynamic> mapResponse =
          Map<String, dynamic>.from(dynamicResponse);
      if (response.statusCode == HttpStatus.ok ||
          response.statusCode == HttpStatus.created) {
        AuthResponse authResponse = AuthResponse.fromJson(mapResponse);
        await prefs.remove('token');
        await prefs.setString('token', authResponse.accessToken);
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

  Future<DataState> login(AuthRequest user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final url = Uri.http(kBaseUrl, kLogin);
    try {
      http.Response response = await http.post(url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode(user.toJson()));
      final dynamic dynamicResponse = jsonDecode(response.body);
      final Map<String, dynamic> mapResponse =
          Map<String, dynamic>.from(dynamicResponse);
      if (response.statusCode == HttpStatus.ok ||
          response.statusCode == HttpStatus.created) {
        AuthResponse authResponse = AuthResponse.fromJson(mapResponse);
        await prefs.remove('token');
        await prefs.setString('token', authResponse.accessToken);
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

  Future<DataState> isTokenExpired() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    final url = Uri.http(kBaseUrl, kTokenVerification);
    try {
      http.Response response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );
      final dynamic dynamicResponse = jsonDecode(response.body);
      if (response.statusCode == HttpStatus.ok ||
          response.statusCode == HttpStatus.created) {
        final bool val = bool.parse(dynamicResponse.toString());
        return DataSuccess<bool>(data: val, code: HttpStatus.ok);
      } else {
        await prefs.remove('token');
        return const DataFailure<String>(
            exception: 'Expired or Invalid token!', code: HttpStatus.notFound);
      }
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
