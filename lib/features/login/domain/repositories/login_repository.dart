import '../entities/user_entity.dart';

abstract class LoginRepository {
  Stream<UserEntity?> authStateChanges();

  UserEntity? get currentUser;

  Future<UserEntity> login({required String email, required String password});

  Future<UserEntity> getCurrentUser({required String token});

  Future<void> logout();
}
