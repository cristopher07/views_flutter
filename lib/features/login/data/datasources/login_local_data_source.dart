import '../models/user_model.dart';

abstract class LoginLocalDataSource {
  Future<void> saveUser(UserModel user);

  Future<UserModel?> getCachedUser();

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  });

  Future<Map<String, String>?> getTokens();

  Future<void> clearAll();
}

class LoginLocalDataSourceImpl implements LoginLocalDataSource {
  // En un futuro se reemplazará por SharedPreferences o Hive
  UserModel? _cachedUser;
  String? _accessToken;
  String? _refreshToken;

  @override
  Future<void> saveUser(UserModel user) async {
    _cachedUser = user;

  }

  @override
  Future<UserModel?> getCachedUser() async {
    return _cachedUser;
  }

  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
  
  }

  @override
  Future<Map<String, String>?> getTokens() async {
    if (_accessToken != null && _refreshToken != null) {
      return {
        'accessToken': _accessToken!,
        'refreshToken': _refreshToken!,
      };
    }
    return null;
  }

  @override
  Future<void> clearAll() async {
    _cachedUser = null;
    _accessToken = null;
    _refreshToken = null;

  }
}
