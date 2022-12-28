import 'dart:developer' as developer;

extension StringLog on String {
  void log(String message) {
    developer.log(message);
  }

  void apiLog(String message) {
    developer.log('API Called : ' + message);
  }

  void responseLog(String message) {
    developer.log(
      'Response : ' + message,
    );
  }

  void errorLog(String message) {
    developer.log('Error : ' + message, error: true);
  }
}
