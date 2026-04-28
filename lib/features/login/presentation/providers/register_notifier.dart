import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'register_state.dart';

/// Notifier para manejar la lógica de registro
class RegisterNotifier extends StateNotifier<RegisterState> {
  RegisterNotifier() : super(const RegisterState.initial());

  /// Registrar nuevo usuario
  Future<void> register({
    required String firstName,
    required String lastName,
    required String phone,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    // Validar campos vacíos
    if (firstName.isEmpty ||
        lastName.isEmpty ||
        phone.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      state = const RegisterState.error(
        message: 'Todos los campos son requeridos',
      );
      return;
    }

    // Validar contraseñas coincidan
    if (password != confirmPassword) {
      state = const RegisterState.error(
        message: 'Las contraseñas no coinciden',
      );
      return;
    }

    // Validar email formato
    if (!email.contains('@')) {
      state = const RegisterState.error(
        message: 'Email inválido',
      );
      return;
    }

    // Validar teléfono
    if (phone.length < 7) {
      state = const RegisterState.error(
        message: 'Teléfono inválido',
      );
      return;
    }

    state = const RegisterState.loading();

    // Simular delay de API
    await Future.delayed(const Duration(seconds: 2));

    // Simular registro exitoso
    try {
      state = RegisterState.success(
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        email: email,
        password: password,
      );
    } catch (e) {
      state = RegisterState.error(
        message: 'Error al registrar: ${e.toString()}',
      );
    }
  }

  /// Limpiar el estado
  void reset() {
    state = const RegisterState.initial();
  }

  /// Limpiar error
  void clearError() {
    state.maybeMap(
      error: (_) => state = const RegisterState.initial(),
      orElse: () {},
    );
  }
}
