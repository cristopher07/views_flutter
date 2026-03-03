import '../../domain/entities/login_entity.dart';
import '../../domain/repositories/login_repository.dart';

class LoginRepositoryImpl implements LoginRepository {
  @override
  Future<LoginEntity> getLoginState() async {
    return const LoginEntity(
      username: 'guest',
      isAuthenticated: false,
    );
  }
}
