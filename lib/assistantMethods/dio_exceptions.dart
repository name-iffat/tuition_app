import 'package:dio/dio.dart';

class DioExceptions implements Exception {
  DioExceptions.fromDioError(DioException dioError) {
    if (dioError.type == DioExceptionType.cancel) {
      message = "Request to API server was cancelled";
    } else if (dioError.type == DioExceptionType.connectionTimeout) {
      message = "Connection timeout with API server";
    } else if (dioError.type == DioExceptionType.unknown) {
      message = "Connection to API server failed due to internet connection";
    } else if (dioError.type == DioExceptionType.receiveTimeout) {
      message = "Receive timeout in connection with API server";
    } else if (dioError.type == DioExceptionType.badResponse) {
      message = _handleError(
        dioError.response!.statusCode!,
        dioError.response!.data,
      );
    } else if (dioError.type == DioExceptionType.sendTimeout) {
      message = "Send timeout in connection with API server";
    } else {
      message = "Something went wrong";
    }  }

  late String message;

  String _handleError(int statusCode, dynamic error) {
    switch (statusCode) {
      case 400:
        return 'Bad request';
      case 404:
        return error["message"];
      case 500:
        return 'Internal server error';
      default:
        return 'Oops something went wrong';
    }
  }

  @override
  String toString() => message;
}