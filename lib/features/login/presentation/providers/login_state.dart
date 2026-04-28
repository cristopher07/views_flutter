
import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_state.freezed.dart';

/// Estado base para el login
@freezed
abstract class LoginState with _$LoginState {
  const factory LoginState.initial() = _Initial;
  const factory LoginState.loading() = _Loading;
  const factory LoginState.success({
    required String user,
    required String email,
  }) = _Success;
  const factory LoginState.error({required String message}) = _Error;
  const factory LoginState.logout() = _Logout;
}
