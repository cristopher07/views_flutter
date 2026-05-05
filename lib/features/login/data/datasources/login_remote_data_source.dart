import '../../../../core/http/http_client.dart';
import '../models/user_model.dart';

abstract class LoginRemoteDataSource {
  Future<UserModel> login({
    required String email,
    required String password,
  });

  Future<UserModel> getCurrentUser({required String token});
}

class LoginRemoteDataSourceImpl implements LoginRemoteDataSource {
  final HttpClient httpClient;

  LoginRemoteDataSourceImpl({required this.httpClient});

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      return await httpClient.post<UserModel>(
        endpoint: '/auth/login',
        body: {
          'username': email,
          'password': password,
        },
        fromJson: (json) => UserModel.fromJson(json),
      );
    } catch (e) {
      throw Exception('Error al conectar con el servidor: $e');
    }
  }

  @override
  Future<UserModel> getCurrentUser({required String token}) async {
    try {
      return await httpClient.get<UserModel>(
        endpoint: '/auth/me',
        headers: {
          'Authorization': 'Bearer $token',
        },
        fromJson: (json) => UserModel.fromJson(json),
      );
    } catch (e) {
      throw Exception('Error al obtener usuario actual: $e');
    }
  }
}

