import 'package:dio/dio.dart';

/// ============================================================
/// API CLIENT — Dio HTTP client setup
/// ============================================================
///
/// This is the ONLY place where we configure our HTTP client.
/// All API calls in the app go through this Dio instance.
///
/// 🌐 We use JSONPlaceholder (https://jsonplaceholder.typicode.com)
///    as our dummy/fake API for learning.

class ApiClient {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  /// Creates and returns a configured Dio instance
  static Dio createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Logs every request & response in the console (helpful for debugging)
    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
      ),
    );

    return dio;
  }
}
