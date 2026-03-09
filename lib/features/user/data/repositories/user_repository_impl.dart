import 'package:clean_architecture/features/user/data/datasources/user_remote_data_source.dart';
import 'package:clean_architecture/features/user/data/models/user_model.dart';
import 'package:clean_architecture/features/user/domain/entities/user_entity.dart';
import 'package:clean_architecture/features/user/domain/repositories/user_repository.dart';

/// ============================================================
/// USER REPOSITORY IMPL — Concrete implementation (Data Layer)
/// ============================================================
///
/// 📌 WHAT DOES THIS DO?
/// This class IMPLEMENTS the abstract UserRepository from Domain layer.
/// It's the BRIDGE between Domain and Data.
///
/// 📌 HOW IT WORKS:
/// 1. Use Case calls this repository (through the abstract contract)
/// 2. This class calls the DataSource to get/send data
/// 3. DataSource returns UserModel (which IS a UserEntity)
/// 4. This class returns it back to the Use Case
///
/// 📌 WHY THIS EXISTS:
/// The Domain layer has an abstract UserRepository.
/// The Domain layer doesn't know about Dio, JSON, or APIs.
/// This class connects the Domain to the actual Data layer.
///
/// 📌 ABOUT ERRORS:
/// If the API call fails, Dio throws a DioException.
/// We let it propagate up — the BLoC will catch it.

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<UserEntity>> getUsers() async {
    // Calls DataSource → returns List<UserModel> which IS List<UserEntity>
    return await remoteDataSource.getUsers();
  }

  @override
  Future<UserEntity> getUser(int id) async {
    return await remoteDataSource.getUser(id);
  }

  @override
  Future<UserEntity> createUser(UserEntity user) async {
    // Convert Entity → Model (because DataSource needs toJson())
    final userModel = UserModel.fromEntity(user);
    return await remoteDataSource.createUser(userModel);
  }

  @override
  Future<UserEntity> updateUser(UserEntity user) async {
    final userModel = UserModel.fromEntity(user);
    return await remoteDataSource.updateUser(userModel);
  }

  @override
  Future<void> deleteUser(int id) async {
    await remoteDataSource.deleteUser(id);
  }
}
