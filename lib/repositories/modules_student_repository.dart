import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import '../models/chapter.dart';
import '../models/course.dart';
import '../models/module.dart';
import '../models/question.dart';
import '../utils/constants.dart';
import '../utils/data_state.dart';

class ModuleStudentRepository{
  //get all modules for specific course
  Future<DataState> getModulesForCourse(Course course) async {
    final url = Uri.http(kBaseUrl, '$kGetModulesForCourse${course.id}');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    List<Module> modules = [];
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
          Module module = Module.fromJson(map);
          modules.add(module);
        }
        return DataSuccess<List<Module>>(code: HttpStatus.ok, data: modules);
      } else if (response.statusCode == HttpStatus.badRequest) {
        final Map<String, dynamic> mapResponse =
        Map<String, dynamic>.from(dynamicResponse);
        return DataFailure<String>(
            exception: mapResponse['message'], code: HttpStatus.badRequest);
      } else if (response.statusCode == HttpStatus.notFound) {
        final Map<String, dynamic> mapResponse =
        Map<String, dynamic>.from(dynamicResponse);
        return DataFailure<String>(
            exception: mapResponse['message'], code: HttpStatus.notFound);
      } else if (response.statusCode == 401 || response.statusCode == 403) {
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

  //get specific chapter for module ~ content
  Future<DataState> getChapterForModule(Module module) async {
    final url =
    Uri.http(kBaseUrl, '$kGetSpecificChapterForSpecificModule${module.id}');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    try {
      http.Response response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      });
      final dynamic dynamicResponse = jsonDecode(utf8.decode(response.bodyBytes));
      final Map<String, dynamic> mapResponse =
      Map<String, dynamic>.from(dynamicResponse);
      if (response.statusCode == HttpStatus.ok) {
        Chapter chapter = Chapter.fromJson(mapResponse);
        return DataSuccess<Chapter>(code: HttpStatus.ok, data: chapter);
      } else if (response.statusCode == HttpStatus.badRequest) {
        return DataFailure<String>(
            exception: mapResponse['message'], code: HttpStatus.badRequest);
      } else if (response.statusCode == HttpStatus.notFound) {
        return DataFailure<String>(
            exception: mapResponse['message'], code: HttpStatus.notFound);
      } else if (response.statusCode == 401 || response.statusCode == 403) {
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

  //get questions for specific module
  Future<DataState> getQuestionsForModule(Module module) async {
    final url =
    Uri.http(kBaseUrl, '$kGetQuestionsForSpecificModule${module.id}/0');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    List<Question> questions = [];
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
          Question question = Question.fromJson(map);
          questions.add(question);
        }
        return DataSuccess<List<Question>>(
            code: HttpStatus.ok, data: questions);
      } else if (response.statusCode == HttpStatus.badRequest) {
        final Map<String, dynamic> mapResponse =
        Map<String, dynamic>.from(dynamicResponse);
        return DataFailure<String>(
            exception: mapResponse['message'], code: HttpStatus.badRequest);
      } else if (response.statusCode == HttpStatus.notFound) {
        final Map<String, dynamic> mapResponse =
        Map<String, dynamic>.from(dynamicResponse);
        return DataFailure<String>(
            exception: mapResponse['message'], code: HttpStatus.notFound);
      } else if (response.statusCode == 401 || response.statusCode == 403) {
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
}