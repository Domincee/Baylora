import 'dart:io';
import 'package:baylora_prjct/core/constant/app_strings.dart';

class NetworkUtils {
  static bool isNetworkError(Object? error) {
    if (error == null) return false;
    final String errorStr = error.toString();
    return error is SocketException ||
        errorStr.contains('SocketException') ||
        errorStr.contains('Network is unreachable') ||
        errorStr.contains('Connection refused');
  }

  static String getErrorMessage(Object error, {String prefix = ''}) {
    if (isNetworkError(error)) {
      return AppStrings.noInternetConnection;
    }
    return '$prefix$error';
  }
}
