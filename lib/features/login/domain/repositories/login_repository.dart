import '../entities/login_entity.dart';

abstract class LoginRepository {
  Future<LoginEntity> getLoginState();
}
