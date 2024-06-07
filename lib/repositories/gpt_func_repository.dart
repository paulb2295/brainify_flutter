import 'dart:async';
import 'dart:convert';
import 'package:brainify_flutter/models/gpt_input.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/chapter.dart';
import '../utils/constants.dart';
import '../utils/data_state.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class GptFuncRepository {
  //DONE
  //get specific chapter ~ content via vector search
  // only need input field from GPTInput to not be null
  Future<DataState> vectorSearch(GPTInput gptInput) async {
    final url = Uri.http(kBaseUrl, kVectorSearch);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    try {
      http.Response response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
          body: json.encode(gptInput.toJson()));
      final  dynamic dynamicResponse = jsonDecode(utf8.decode(response.bodyBytes));
      final Map<String, dynamic> mapResponse =
      Map<String, dynamic>.from(dynamicResponse[0]);
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

  //DONE
  //chat with chat bot
  // only need input, action = CHAT field from GPTInput to not be null
  Future<DataState> chatBot(GPTInput gptInput) async {
    final url = Uri.http(kBaseUrl, kSummarize);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    try {
      http.Response response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
          body: json.encode(gptInput.toJson()));

      String botResponse = response.body.toString();

      if (response.statusCode == HttpStatus.ok) {
        return DataSuccess<String>(code: HttpStatus.ok, data: botResponse);
      } else if (response.statusCode == HttpStatus.badRequest) {
        final dynamic dynamicResponse = json.decode(response.body);
        final Map<String, dynamic> mapResponse =
            Map<String, dynamic>.from(dynamicResponse);
        return DataFailure<String>(
            exception: mapResponse['message'], code: HttpStatus.badRequest);
      } else if (response.statusCode == HttpStatus.notFound) {
        final dynamic dynamicResponse = json.decode(response.body);
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

  //DONE
  //summarize text
  // only need input, action = SUMMARIZE field from GPTInput to not be null
  Future<DataState> summarizeText(GPTInput gptInput) async {
    final url = Uri.http(kBaseUrl, kChat);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    try {
      http.Response response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
          body: json.encode(gptInput.toJson()));
      final String botResponse = response.body.toString();
      if (response.statusCode == HttpStatus.ok) {
        return DataSuccess<String>(code: HttpStatus.ok, data: botResponse);
      } else if (response.statusCode == HttpStatus.badRequest) {
        final dynamic dynamicResponse = jsonDecode(response.body);
        final Map<String, dynamic> mapResponse =
            Map<String, dynamic>.from(dynamicResponse);
        return DataFailure<String>(
            exception: mapResponse['message'], code: HttpStatus.badRequest);
      } else if (response.statusCode == HttpStatus.notFound) {
        final dynamic dynamicResponse = jsonDecode(response.body);
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
