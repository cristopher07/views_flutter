import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'login_state.dart' as bloc_state;

/// Estado para el login (usando clase simple, no BLoC)
class LoginState {
  final bool isLoading;
  final bool isAuthenticated;
  final String? user;
  final String? error;

  const LoginState({
    this.isLoading = false,
    this.isAuthenticated = false,
    this.user,
    this.error,
  });

  LoginState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    String? user,
    String? error,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: user ?? this.user,
      error: error ?? this.error,
    );
  }
}

/// Notifier para manejar la lógica de autenticación
class LoginNotifier extends StateNotifier<LoginState> {
  LoginNotifier() : super(const LoginState());

  /// Simular login con credenciales
  /// Usuario: admin@mail.com
  /// Contraseña: 123456
  Future<void> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      state = state.copyWith(
        error: 'Email y contraseña son requeridos',
      );
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    // Simular delay de API
    await Future.delayed(const Duration(seconds: 2));

    // Validar credenciales (simulado)
    if (email == 'admin@mail.com' && password == '123456') {
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        user: email,
        error: null,
      );
    } else {
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: false,
        error: 'Email o contraseña incorrectos',
      );
    }
  }

  /// Cerrar sesión
  void logout() {
    state = const LoginState();
  }

  /// Limpiar error
  void clearError() {
    state = state.copyWith(error: null);
  }
}
