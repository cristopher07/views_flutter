import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/login_repository.dart';
import '../datasources/firebase_login_data_source.dart';
import '../datasources/login_local_data_source.dart';

class LoginRepositoryImpl implements LoginRepository {
  final FirebaseLoginDataSource firebaseDataSource;
  final LoginLocalDataSource localDataSource;

  LoginRepositoryImpl({
    required this.firebaseDataSource,
    required this.localDataSource,
  });

  @override
  Stream<UserEntity?> authStateChanges() {
    return firebaseDataSource.authStateChanges();
  }

  @override
  UserEntity? get currentUser => firebaseDataSource.currentUser;

  @override
  Future<UserEntity> login({
    required String email,
    required String password,
  }) async {
    try {
      final userModel = await firebaseDataSource.login(
        email: email,
        password: password,
      );

      await localDataSource.saveUser(userModel);

      return userModel;
    } catch (e) {
      throw Exception('Error en login: $e');
    }
  }

  @override
  Future<UserEntity> getCurrentUser({required String token}) async {
    final currentUser = firebaseDataSource.currentUser;
    if (currentUser != null) {
      return currentUser;
    }

    final cachedUser = await localDataSource.getCachedUser();
    if (cachedUser != null) {
      return cachedUser;
    }

    throw Exception('No hay usuario autenticado.');
  }

  @override
  Future<void> logout() async {
    try {
      await firebaseDataSource.logout();
      await localDataSource.clearAll();
    } catch (e) {
      throw Exception('Error al hacer logout: $e');
    }
  }
}
