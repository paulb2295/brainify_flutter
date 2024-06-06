import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:brainify_flutter/models/course.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';
import '../utils/data_state.dart';

class CourseInstructorRepository {

  //create a course
  Future<DataState> createCourse(Course course) async {
    final url = Uri.http(kBaseUrl, kCreateCourse);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    try {
      http.Response response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
          body: json.encode(course.toJson()));
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

  //get all courses for instructor
  Future<DataState> getInstructorsCourses() async {
    final url = Uri.http(kBaseUrl, kGetAllInstructorsCourses);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    List<Course> courses = [];
    try {
      http.Response response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      });

      final dynamic dynamicResponse = jsonDecode(response.body);
      if (response.statusCode == HttpStatus.ok) {
        final List<dynamic> dynamicResponse = jsonDecode(utf8.decode(response.bodyBytes));//jsonDecode(response.body);
        List<Map<String, dynamic>> listData = dynamicResponse
            .map((item) {
          return item as Map<String, dynamic>;//Map<String, dynamic>.from(item);
        }).toList();

        for (final Map<String, dynamic> map in listData) {
          Course course = Course.fromJson(map);
          courses.add(course);
        }
        return DataSuccess<List<Course>>(code: HttpStatus.ok, data: courses);
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
      print(exception);
      return const DataFailure<String>(
          code: 5, exception: 'Unexpected Error. Restart App');
    }
  }

  //delete a course
  Future<DataState> deleteCourse(int courseId) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final url = Uri.http(kBaseUrl, '$kDeleteSpecificCourse$courseId');
    final String? token = prefs.getString('token');
    http.Response response;
    try {
      response = await http.delete(url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          });
      final dynamic dynamicResponse = jsonDecode(response.body);
      final Map<String, dynamic> mapResponse =
      Map<String, dynamic>.from(dynamicResponse);
      if (response.statusCode == HttpStatus.ok ||
          response.statusCode == HttpStatus.created) {
        return const DataSuccess<void>(code: HttpStatus.ok);
      } else if (response.statusCode == HttpStatus.notFound) {
        return DataFailure<String>(
            exception: mapResponse['message'], code: HttpStatus.notFound);
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        return const DataFailure<String>(
            exception: 'Session expired. Login!',
            code: HttpStatus.unauthorized);
      }else if (response.statusCode == HttpStatus.badRequest) {
        return DataFailure<String>(
            exception: mapResponse['message'], code: HttpStatus.badRequest);
      }
      return DataFailure<String>(
          exception: 'Connection with server failed. Try again!',
          code: response.statusCode);
    }on http.ClientException {
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
