import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_event.dart';
import 'login_state.dart';

/// BLoC para el login (patrón completo con eventos)
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(const LoginInitial()) {
    // Registrar manejadores de eventos
    on<LoginSubmitted>(_onLoginSubmitted);
    on<LogoutRequested>(_onLogoutRequested);
    on<ClearErrorRequested>(_onClearErrorRequested);
  }

  /// Manejar evento de login
  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    if (event.email.isEmpty || event.password.isEmpty) {
      emit(const LoginError(message: 'Email y contraseña son requeridos'));
      return;
    }

    emit(const LoginLoading());

    // Simular delay de API
    await Future.delayed(const Duration(seconds: 2));

    // Validar credenciales (simulado)
    if (event.email == 'admin@mail.com' && event.password == '123456') {
      emit(LoginSuccess(
        user: event.email.split('@')[0],
        email: event.email,
      ));
    } else {
      emit(const LoginError(message: 'Email o contraseña incorrectos'));
    }
  }

  /// Manejar evento de logout
  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<LoginState> emit,
  ) async {
    emit(const LoginLogout());
    emit(const LoginInitial());
  }

  /// Manejar evento de limpiar error
  Future<void> _onClearErrorRequested(
    ClearErrorRequested event,
    Emitter<LoginState> emit,
  ) async {
    emit(const LoginInitial());
  }
}
