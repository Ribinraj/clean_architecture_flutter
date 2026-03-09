import 'package:clean_architecture/features/user/domain/entities/user_entity.dart';

/// ============================================================
/// USER STATES — What the UI shows (outputs from BLoC)
/// ============================================================
///
/// 📌 WHAT ARE STATES?
/// States tell the UI what to display RIGHT NOW.
/// The BLoC emits a State, and the UI rebuilds based on it.
///
/// 📌 FLOW:
/// BLoC receives Event → does work → emits State → UI rebuilds
///
/// 📌 STATE MAPPING TO UI:
/// UserInitial         → Empty screen (nothing happened yet)
/// UserLoading         → Show spinner/loading indicator
/// UsersLoaded(users)  → Show list of user cards
/// UserLoaded(user)    → Show user detail page
/// UserSuccess(msg)    → Show success snackbar
/// UserError(msg)      → Show error message

/// Base class — all states extend this
abstract class UserState {}

/// Nothing has happened yet
class UserInitial extends UserState {}

/// Loading... (API call in progress)
class UserLoading extends UserState {}

/// All users loaded successfully
class UsersLoaded extends UserState {
  final List<UserEntity> users;
  UsersLoaded(this.users);
}

/// Single user loaded successfully
class UserLoaded extends UserState {
  final UserEntity user;
  UserLoaded(this.user);
}

/// Create/Update/Delete succeeded
class UserSuccess extends UserState {
  final String message;
  UserSuccess(this.message);
}

/// Something went wrong
class UserError extends UserState {
  final String message;
  UserError(this.message);
}
