
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/user_entity.dart';

part 'login_state.freezed.dart';

/// Estado para el flujo de login/autenticación
@freezed
abstract class LoginState with _$LoginState {
  const factory LoginState.initial() = _Initial;
  const factory LoginState.loading() = _Loading;
  const factory LoginState.success({required UserEntity user}) = _Success;
  const factory LoginState.error({required String message}) = _Error;
}
