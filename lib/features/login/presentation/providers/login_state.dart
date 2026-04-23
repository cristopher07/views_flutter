import 'package:equatable/equatable.dart';

/// Estado base para el login
abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

/// Estado inicial - sin cambios
class LoginInitial extends LoginState {
  const LoginInitial();
}

/// Estado de carga
class LoginLoading extends LoginState {
  const LoginLoading();
}

/// Estado de éxito
class LoginSuccess extends LoginState {
  final String user;
  final String email;

  const LoginSuccess({
    required this.user,
    required this.email,
  });

  @override
  List<Object?> get props => [user, email];
}

/// Estado de error
class LoginError extends LoginState {
  final String message;

  const LoginError({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Estado de logout
class LoginLogout extends LoginState {
  const LoginLogout();
}
