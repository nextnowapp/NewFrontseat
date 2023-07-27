// Package imports:
import 'package:dio/dio.dart';

class DioExceptions implements Exception {
  DioExceptions.fromDioException(DioException DioException) {
    switch (DioException.type) {
      case DioExceptionType.cancel:
        message = 'Request to API server was cancelled';
        break;
      case DioExceptionType.connectionTimeout:
        message = 'Connection timeout with API server';
        break;
      // case DioExceptionType.DEFAULT:
      //   message = "Connection to API server failed due to internet connection";
      //   break;
      case DioExceptionType.receiveTimeout:
        message = 'Receive timeout in connection with API server';
        break;
      case DioExceptionType.badResponse:
        message = _handleError(
            DioException.response!.statusCode, DioException.response!.data);
        break;
      case DioExceptionType.sendTimeout:
        message = 'Send timeout in connection with API server';
        break;
      default:
        message = 'Something went wrong';
        break;
    }
  }

  String? message;

  String? _handleError(int? statusCode, dynamic error) {
    switch (statusCode) {
      case 400:
        return 'Bad request';
      case 404:
        return error['message'];
      case 500:
        return 'Internal server error';
      default:
        return '$statusCode';
    }
  }

  @override
  String toString() => message!;
}
