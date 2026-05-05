import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecases/login_usecase.dart';
import 'login_state.dart';

/// Notifier para manejar la lógica de autenticación
class LoginNotifier extends StateNotifier<LoginState> {
  final LoginUseCase loginUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final LogoutUseCase logoutUseCase;

  LoginNotifier({
    required this.loginUseCase,
    required this.getCurrentUserUseCase,
    required this.logoutUseCase,
  }) : super(const LoginState.initial());

  /// Realizar login con credenciales
  Future<void> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      state = const LoginState.error(
        message: 'Email y contraseña son requeridos',
      );
      return;
    }

    state = const LoginState.loading();

    try {
      final user = await loginUseCase(email: email, password: password);
      state = LoginState.success(user: user);
    } catch (e) {
      state = LoginState.error(
        message: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  /// Obtener usuario actual
  Future<void> getCurrentUser(String token) async {
    try {
      final user = await getCurrentUserUseCase(token: token);
      state = LoginState.success(user: user);
    } catch (e) {
      state = LoginState.error(
        message: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  /// Cerrar sesión
  Future<void> logout() async {
    try {
      await logoutUseCase();
      state = const LoginState.initial();
    } catch (e) {
      state = LoginState.error(
        message: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  /// Limpiar error
  void clearError() {
    state = const LoginState.initial();
  }
}
