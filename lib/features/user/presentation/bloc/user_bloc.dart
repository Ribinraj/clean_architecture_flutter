import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clean_architecture/features/user/domain/usecases/user_usecases.dart';
import 'package:clean_architecture/features/user/presentation/bloc/user_event.dart';
import 'package:clean_architecture/features/user/presentation/bloc/user_state.dart';

/// ============================================================
/// USER BLOC — The brain between UI and Use Cases
/// ============================================================
///
/// 📌 WHAT DOES BLOC DO?
/// BLoC receives Events (user actions) and emits States (UI updates).
///
/// 📌 HOW IT WORKS (step by step):
///
/// 1. User taps "Load Users" button
/// 2. UI dispatches: context.read<UserBloc>().add(GetUsersEvent())
/// 3. BLoC's _onGetUsers handler runs:
///    a. Emits UserLoading → UI shows spinner
///    b. Calls getUsers use case → API call happens
///    c. Success? Emits UsersLoaded(users) → UI shows list
///    d. Error? Emits UserError(message) → UI shows error
///
/// 📌 SIMPLE TRY-CATCH PATTERN:
/// try {
///   emit(UserLoading());          // Show spinner
///   final result = await useCase(); // Do the work
///   emit(SuccessState(result));   // Show result
/// } catch (e) {
///   emit(UserError(e.toString())); // Show error
/// }

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUsers getUsers;
  final GetUser getUser;
  final CreateUser createUser;
  final UpdateUser updateUser;
  final DeleteUser deleteUser;

  UserBloc({
    required this.getUsers,
    required this.getUser,
    required this.createUser,
    required this.updateUser,
    required this.deleteUser,
  }) : super(UserInitial()) {
    // Register which method handles which event
    on<GetUsersEvent>(_onGetUsers);
    on<GetUserEvent>(_onGetUser);
    on<CreateUserEvent>(_onCreateUser);
    on<UpdateUserEvent>(_onUpdateUser);
    on<DeleteUserEvent>(_onDeleteUser);
  }

  // ─── GET ALL USERS ──────────────────────────────────
  Future<void> _onGetUsers(
    GetUsersEvent event,
    Emitter<UserState> emit,
  ) async {
    try {
      emit(UserLoading());
      final users = await getUsers();
      emit(UsersLoaded(users));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  // ─── GET SINGLE USER ────────────────────────────────
  Future<void> _onGetUser(
    GetUserEvent event,
    Emitter<UserState> emit,
  ) async {
    try {
      emit(UserLoading());
      final user = await getUser(event.id);
      emit(UserLoaded(user));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  // ─── CREATE USER ────────────────────────────────────
  Future<void> _onCreateUser(
    CreateUserEvent event,
    Emitter<UserState> emit,
  ) async {
    try {
      emit(UserLoading());
      await createUser(event.user);
      emit(UserSuccess('User created successfully!'));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  // ─── UPDATE USER ────────────────────────────────────
  Future<void> _onUpdateUser(
    UpdateUserEvent event,
    Emitter<UserState> emit,
  ) async {
    try {
      emit(UserLoading());
      await updateUser(event.user);
      emit(UserSuccess('User updated successfully!'));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  // ─── DELETE USER ────────────────────────────────────
  Future<void> _onDeleteUser(
    DeleteUserEvent event,
    Emitter<UserState> emit,
  ) async {
    try {
      emit(UserLoading());
      await deleteUser(event.id);
      emit(UserSuccess('User deleted successfully!'));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }
}
