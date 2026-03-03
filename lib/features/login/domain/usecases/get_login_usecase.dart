import '../entities/login_entity.dart';
import '../repositories/login_repository.dart';

class GetLoginUseCase {
  final LoginRepository repository;

  const GetLoginUseCase(this.repository);

  Future<LoginEntity> call() {
    return repository.getLoginState();
  }
}
