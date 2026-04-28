import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'login_state.dart';

/// Notifier para manejar la lógica de autenticación
class LoginNotifier extends StateNotifier<LoginState> {
  LoginNotifier() : super(const LoginState.initial());

  /// Simular login con credenciales
  /// Usuario: admin@mail.com
  /// Contraseña: 123456
  Future<void> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      state = const LoginState.error(
        message: 'Email y contraseña son requeridos',
      );
      return;
    }

    state = const LoginState.loading();

    // Simular delay de API
    await Future.delayed(const Duration(seconds: 2));

    // Validar credenciales (simulado)
    if (email == 'admin@mail.com' && password == '123456') {
      state = LoginState.success(
        user: email.split('@')[0],
        email: email,
      );
    } else {
      state = const LoginState.error(
        message: 'Email o contraseña incorrectos',
      );
    }
  }

  /// Cerrar sesión
  void logout() {
    state = const LoginState.logout();
    state = const LoginState.initial();
  }

  /// Limpiar error
  void clearError() {
    state.maybeMap(
      error: (_) => state = const LoginState.initial(),
      orElse: () {},
    );
  }
}
