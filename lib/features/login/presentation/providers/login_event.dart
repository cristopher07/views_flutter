import 'package:equatable/equatable.dart';

/// Evento base para el login
abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

/// Evento para hacer login
class LoginSubmitted extends LoginEvent {
  final String email;
  final String password;

  const LoginSubmitted({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

/// Evento para hacer logout
class LogoutRequested extends LoginEvent {
  const LogoutRequested();
}

/// Evento para limpiar error
class ClearErrorRequested extends LoginEvent {
  const ClearErrorRequested();
}
