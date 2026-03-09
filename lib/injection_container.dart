import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:clean_architecture/core/network/api_client.dart';
import 'package:clean_architecture/features/user/data/datasources/user_remote_data_source.dart';
import 'package:clean_architecture/features/user/data/repositories/user_repository_impl.dart';
import 'package:clean_architecture/features/user/domain/repositories/user_repository.dart';
import 'package:clean_architecture/features/user/domain/usecases/user_usecases.dart';
import 'package:clean_architecture/features/user/presentation/bloc/user_bloc.dart';

/// ============================================================
/// DEPENDENCY INJECTION — GetIt Service Locator
/// ============================================================
///
/// 📌 WHAT IS GetIt?
/// GetIt is like a "dictionary" where we register all our objects.
/// Instead of creating objects manually, we ask GetIt to give them.
///
/// 📌 WITHOUT GetIt (messy):
/// final bloc = UserBloc(
///   getUsers: GetUsers(UserRepositoryImpl(
///     remoteDataSource: UserRemoteDataSource(dio: Dio(...))
///   )),
///   getUser: GetUser(...),
///   ... // too many nested objects!
/// );
///
/// 📌 WITH GetIt (clean):
/// final bloc = sl<UserBloc>();  // GetIt handles everything!
///
/// 📌 TWO TYPES OF REGISTRATION:
/// registerFactory      → Creates NEW object every time (for BLoC)
/// registerLazySingleton → Creates ONE object, reuses it (for everything else)

/// "sl" = Service Locator (common naming convention)
final sl = GetIt.instance;

/// Call this ONCE in main() before runApp()
Future<void> initDependencies() async {

  // ── 1. BLoC (Factory = new instance each time) ──────
  sl.registerFactory(
    () => UserBloc(
      getUsers: sl(),    // GetIt finds GetUsers automatically
      getUser: sl(),     // GetIt finds GetUser automatically
      createUser: sl(),  // GetIt finds CreateUser automatically
      updateUser: sl(),  // GetIt finds UpdateUser automatically
      deleteUser: sl(),  // GetIt finds DeleteUser automatically
    ),
  );

  // ── 2. Use Cases (Singleton = one instance, reused) ──
  sl.registerLazySingleton(() => GetUsers(sl()));
  sl.registerLazySingleton(() => GetUser(sl()));
  sl.registerLazySingleton(() => CreateUser(sl()));
  sl.registerLazySingleton(() => UpdateUser(sl()));
  sl.registerLazySingleton(() => DeleteUser(sl()));

  // ── 3. Repository ────────────────────────────────────
  // Register abstract type → provide concrete implementation
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(remoteDataSource: sl()),
  );

  // ── 4. Data Source ───────────────────────────────────
  sl.registerLazySingleton(
    () => UserRemoteDataSource(dio: sl()),
  );

  // ── 5. External (Dio) ───────────────────────────────
  sl.registerLazySingleton<Dio>(() => ApiClient.createDio());
}
