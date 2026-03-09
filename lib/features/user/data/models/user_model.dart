import 'package:clean_architecture/features/user/domain/entities/user_entity.dart';

/// ============================================================
/// USER MODEL — JSON conversion layer (Data Layer)
/// ============================================================
///
/// 📌 WHAT DOES THIS DO?
/// Converts data between two formats:
///   JSON (from API) ←→ Dart object (our app)
///
/// 📌 WHY EXTEND ENTITY?
/// UserModel IS a UserEntity (with extra powers).
/// The extra powers are: fromJson() and toJson().
///
/// 📌 DATA FLOW:
/// API sends JSON → fromJson() → UserModel → used as UserEntity
/// UserEntity → fromEntity() → UserModel → toJson() → sent to API

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.phone,
  });

  /// JSON → UserModel
  /// Example JSON from API:
  /// { "id": 1, "name": "John", "email": "john@mail.com", "phone": "123" }
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
    );
  }

  /// UserModel → JSON (for sending to API)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
    };
  }

  /// Convert a UserEntity into a UserModel
  /// Used when BLoC gives us an Entity but we need a Model for the API
  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      phone: entity.phone,
    );
  }
}
