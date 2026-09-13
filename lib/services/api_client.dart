import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Base URL of the Express/Mongo backend (see backend/server.js).
///
/// The DEFAULT here is your deployed Render backend — this is what ships
/// in a real build (flutter build apk/ipa), so a phone that installs the
/// app talks to your live server automatically. No dart-define needed for
/// production builds.
///
/// For LOCAL development only, override it at run time instead of editing
/// this file:
///
///   flutter run --dart-define=API_BASE_URL=http://localhost:5000/api
///
/// Local-dev address cheat sheet:
/// - Chrome / Edge / Windows desktop -> http://localhost:5000/api
/// - Android emulator                -> http://10.0.2.2:5000/api  (10.0.2.2 is
///   the emulator's special alias for your host machine's localhost)
/// - iOS simulator                   -> http://localhost:5000/api
/// - Real phone, same Wi-Fi as your computer -> http://<your-computer's-LAN-IP>:5000/api
///   (a real phone can't reach "localhost" — that means the phone itself)
const String kApiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'https://yum-treat.onrender.com/api',
);

/// Equivalent of frontend/lib/api.js — attaches a fresh Firebase ID token
/// to every request (tokens expire hourly; the SDK refreshes them silently,
/// so we always pull the current one rather than caching it ourselves) and
/// normalizes error messages the same way the Express error handler's
/// `{ message }` shape is unwrapped on the website.
class ApiClient {
  ApiClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: kApiBaseUrl,
        headers: {'Content-Type': 'application/json'},
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final user = FirebaseAuth.instance.currentUser;
          if (user != null) {
            final token = await user.getIdToken();
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) {
          final message = _extractMessage(error);
          handler.next(
            DioException(
              requestOptions: error.requestOptions,
              response: error.response,
              type: error.type,
              error: message,
              message: message,
            ),
          );
        },
      ),
    );
  }

  static final ApiClient instance = ApiClient._internal();
  late final Dio _dio;

  Dio get dio => _dio;

  static String _extractMessage(DioException err) {
    final data = err.response?.data;
    if (data is Map && data['message'] is String) {
      return data['message'] as String;
    }
    return err.message ?? 'Something went wrong. Please try again.';
  }
}

/// Thrown for any failed API call, carrying the backend's `{ message }`
/// (or a sensible fallback) the same way api.js's response interceptor does.
class ApiException implements Exception {
  final String message;
  ApiException(this.message);
  @override
  String toString() => message;
}

/// Runs [block], converting any DioException into an [ApiException] with a
/// clean message so screens can just do `catch (e) { show(e.toString()) }`.
Future<T> guardApi<T>(Future<T> Function() block) async {
  try {
    return await block();
  } on DioException catch (e) {
    final msg = e.error is String ? e.error as String : (e.message ?? 'Something went wrong. Please try again.');
    throw ApiException(msg);
  }
}
