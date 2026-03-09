import 'package:clean_architecture/features/user/domain/entities/user_entity.dart';

/// ============================================================
/// USER EVENTS — What the user does (inputs to BLoC)
/// ============================================================
///
/// 📌 WHAT ARE EVENTS?
/// Events are "messages" from the UI to the BLoC.
/// When the user taps a button, the UI sends an Event.
///
/// 📌 EXAMPLES:
/// User opens the app    → UI sends GetUsersEvent()
/// User taps a user card → UI sends GetUserEvent(id: 5)
/// User fills form       → UI sends CreateUserEvent(user)
/// User taps delete      → UI sends DeleteUserEvent(id: 3)

/// Base class — all events extend this
abstract class UserEvent {}

/// Fetch all users
class GetUsersEvent extends UserEvent {}

/// Fetch a single user by ID
class GetUserEvent extends UserEvent {
  final int id;
  GetUserEvent(this.id);
}

/// Create a new user
class CreateUserEvent extends UserEvent {
  final UserEntity user;
  CreateUserEvent(this.user);
}

/// Update an existing user
class UpdateUserEvent extends UserEvent {
  final UserEntity user;
  UpdateUserEvent(this.user);
}

/// Delete a user by ID
class DeleteUserEvent extends UserEvent {
  final int id;
  DeleteUserEvent(this.id);
}
