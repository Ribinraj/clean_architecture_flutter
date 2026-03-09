import 'package:dio/dio.dart';
import 'package:clean_architecture/features/user/data/models/user_model.dart';

/// ============================================================
/// USER REMOTE DATA SOURCE — Talks to the API (Data Layer)
/// ============================================================
///
/// 📌 WHAT DOES THIS DO?
/// This is the ONLY file that makes HTTP calls.
/// It uses Dio to talk to the JSONPlaceholder API.
///
/// 📌 WHAT DOES IT KNOW ABOUT?
/// ✅ Dio (HTTP client)
/// ✅ JSON format
/// ✅ API URLs/endpoints
/// ❌ BLoC, UI, or business logic (doesn't know about these!)
///
/// 📌 API ENDPOINTS USED:
/// GET    /users        → Get all users
/// GET    /users/1      → Get user with ID 1
/// POST   /users        → Create a new user
/// PUT    /users/1      → Update user with ID 1
/// DELETE /users/1      → Delete user with ID 1
///
/// ⚠️ JSONPlaceholder is a FAKE API — POST/PUT/DELETE will return
///    success but won't actually save anything on the server.

class UserRemoteDataSource {
  final Dio dio;

  UserRemoteDataSource({required this.dio});

  /// GET all users
  Future<List<UserModel>> getUsers() async {
    final response = await dio.get('/users');
    return (response.data as List)
        .map((json) => UserModel.fromJson(json))
        .toList();
  }

  /// GET single user by ID
  Future<UserModel> getUser(int id) async {
    final response = await dio.get('/users/$id');
    return UserModel.fromJson(response.data);
  }

  /// POST create a new user
  Future<UserModel> createUser(UserModel user) async {
    final response = await dio.post('/users', data: user.toJson());
    return UserModel.fromJson(response.data);
  }

  /// PUT update an existing user
  Future<UserModel> updateUser(UserModel user) async {
    final response = await dio.put('/users/${user.id}', data: user.toJson());
    return UserModel.fromJson(response.data);
  }

  /// DELETE a user by ID
  Future<void> deleteUser(int id) async {
    await dio.delete('/users/$id');
  }
}
