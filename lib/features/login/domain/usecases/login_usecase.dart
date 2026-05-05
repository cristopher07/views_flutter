import '../entities/user_entity.dart';
import '../repositories/login_repository.dart';

class LoginUseCase {
  final LoginRepository repository;

  const LoginUseCase(this.repository);

  Future<UserEntity> call({
    required String email,
    required String password,
  }) {
    return repository.login(email: email, password: password);
  }
}

class GetCurrentUserUseCase {
  final LoginRepository repository;

  const GetCurrentUserUseCase(this.repository);

  Future<UserEntity> call({required String token}) {
    return repository.getCurrentUser(token: token);
  }
}

class LogoutUseCase {
  final LoginRepository repository;

  const LogoutUseCase(this.repository);

  Future<void> call() {
    return repository.logout();
  }
}
