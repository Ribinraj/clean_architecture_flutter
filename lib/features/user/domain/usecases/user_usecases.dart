import 'package:clean_architecture/features/user/domain/entities/user_entity.dart';
import 'package:clean_architecture/features/user/domain/repositories/user_repository.dart';

/// ============================================================
/// USER USE CASES — All business actions in one file
/// ============================================================
///
/// 📌 WHAT IS A USE CASE?
/// A Use Case = ONE action your app can do.
/// Example: "Get all users", "Create a user", "Delete a user"
///
/// 📌 WHY USE CASES?
/// Instead of BLoC calling the Repository directly, it calls
/// a Use Case. This might seem like an extra step, but it:
///   1. Makes each action easy to find and test
///   2. Keeps BLoC clean (BLoC doesn't know about repositories)
///   3. If you need to add business rules, add them here
///
/// 📌 DATA FLOW:
/// UI → BLoC → UseCase → Repository → DataSource → API
///
/// Each use case has:
///   - A constructor that takes the repository
///   - A call() method that does the work

// ─── GET ALL USERS ────────────────────────────────────
class GetUsers {
  final UserRepository repository;

  GetUsers(this.repository);

  /// Fetches all users from the API
  Future<List<UserEntity>> call() {
    return repository.getUsers();
  }
}

// ─── GET SINGLE USER ──────────────────────────────────
class GetUser {
  final UserRepository repository;

  GetUser(this.repository);

  /// Fetches one user by their ID
  Future<UserEntity> call(int id) {
    return repository.getUser(id);
  }
}

// ─── CREATE USER ──────────────────────────────────────
class CreateUser {
  final UserRepository repository;

  CreateUser(this.repository);

  /// Creates a new user and returns the created user
  Future<UserEntity> call(UserEntity user) {
    return repository.createUser(user);
  }
}

// ─── UPDATE USER ──────────────────────────────────────
class UpdateUser {
  final UserRepository repository;

  UpdateUser(this.repository);

  /// Updates an existing user and returns the updated user
  Future<UserEntity> call(UserEntity user) {
    return repository.updateUser(user);
  }
}

// ─── DELETE USER ──────────────────────────────────────
class DeleteUser {
  final UserRepository repository;

  DeleteUser(this.repository);

  /// Deletes a user by their ID
  Future<void> call(int id) {
    return repository.deleteUser(id);
  }
}
