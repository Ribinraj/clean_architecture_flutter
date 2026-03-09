/// ============================================================
/// USER ENTITY — Pure business object (Domain Layer)
/// ============================================================
///
/// 📌 WHAT IS AN ENTITY?
/// An Entity is just a simple Dart class that holds your data.
/// It doesn't know about JSON, APIs, databases, or UI.
/// It's the PUREST form of your data.
///
/// 📌 WHY SEPARATE FROM MODEL?
/// Entity = What your app THINKS about (business logic)
/// Model  = How your app TALKS to the API (JSON conversion)
///
/// 📌 USED BY:
/// - Use Cases (domain layer)
/// - BLoC (presentation layer)
/// - UI Pages (presentation layer)

class UserEntity {
  final int id;
  final String name;
  final String email;
  final String phone;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
  });
}
