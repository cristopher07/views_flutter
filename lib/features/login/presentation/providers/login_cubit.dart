import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_state.dart';

/// Cubit para el login (versión simplificada de BLoC)
class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(const LoginInitial());

  /// Hacer login con email y contraseña
  /// Usuario: admin@mail.com
  /// Contraseña: 123456
  Future<void> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      emit(const LoginError(message: 'Email y contraseña son requeridos'));
      return;
    }

    emit(const LoginLoading());

    // Simular delay de API
    await Future.delayed(const Duration(seconds: 2));

    // Validar credenciales (simulado)
    if (email == 'admin@mail.com' && password == '123456') {
      emit(LoginSuccess(
        user: email.split('@')[0],
        email: email,
      ));
    } else {
      emit(const LoginError(message: 'Email o contraseña incorrectos'));
    }
  }

  /// Hacer logout
  void logout() {
    emit(const LoginLogout());
    emit(const LoginInitial());
  }

  /// Limpiar error
  void clearError() {
    emit(const LoginInitial());
  }
}
