import 'package:clean_architecture/features/user/domain/entities/user_entity.dart';

/// ============================================================
/// USER REPOSITORY — Abstract contract (Domain Layer)
/// ============================================================
///
/// 📌 WHAT IS THIS?
/// This is like a "menu" — it tells you WHAT operations are available,
/// but NOT how they are done.
///
/// 📌 WHY ABSTRACT?
/// The Domain layer defines the RULES (abstract).
/// The Data layer provides the IMPLEMENTATION (concrete).
/// This way, Domain layer never depends on Data layer.
///
/// 📌 EXAMPLE:
/// Think of a restaurant:
///   Menu (abstract repo)  → "We serve Pasta, Pizza, Salad"
///   Kitchen (concrete repo) → Actually cooks the food
///
/// If errors happen, they are thrown as exceptions.
/// The BLoC will catch them using try-catch.

abstract class UserRepository {
  /// Get all users
  Future<List<UserEntity>> getUsers();

  /// Get a single user by ID
  Future<UserEntity> getUser(int id);

  /// Create a new user, returns the created user
  Future<UserEntity> createUser(UserEntity user);

  /// Update a user, returns the updated user
  Future<UserEntity> updateUser(UserEntity user);

  /// Delete a user by ID
  Future<void> deleteUser(int id);
}
