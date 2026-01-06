import 'dart:io';

class NetworkUtils {
  static bool isNetworkError(Object? error) {
    if (error == null) return false;
    final String errorStr = error.toString();
    return error is SocketException ||
        errorStr.contains('SocketException') ||
        errorStr.contains('Network is unreachable') ||
        errorStr.contains('Connection refused');
  }
}
