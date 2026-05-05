import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/login_repository.dart';
import '../datasources/login_local_data_source.dart';
import '../datasources/login_remote_data_source.dart';

class LoginRepositoryImpl implements LoginRepository {
  final LoginRemoteDataSource remoteDataSource;
  final LoginLocalDataSource localDataSource;

  LoginRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<UserEntity> login({
    required String email,
    required String password,
  }) async {
    try {
      // Llamar al API remoto
      final userModel = await remoteDataSource.login(
        email: email,
        password: password,
      );

      // Guardar usuario y tokens localmente
      await localDataSource.saveUser(userModel);
      await localDataSource.saveTokens(
        accessToken: userModel.accessToken,
        refreshToken: userModel.refreshToken,
      );

      return userModel;
    } catch (e) {
      throw Exception('Error en login: $e');
    }
  }

  @override
  Future<UserEntity> getCurrentUser({required String token}) async {
    try {
      // Obtener usuario actual del API
      return await remoteDataSource.getCurrentUser(token: token);
    } catch (e) {
      // Si falla, intentar obtener del cache local
      final cachedUser = await localDataSource.getCachedUser();
      if (cachedUser != null) {
        return cachedUser;
      }
      throw Exception('Error al obtener usuario: $e');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await localDataSource.clearAll();
    } catch (e) {
      throw Exception('Error al hacer logout: $e');
    }
  }
}

