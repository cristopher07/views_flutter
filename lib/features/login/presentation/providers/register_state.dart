
import 'package:freezed_annotation/freezed_annotation.dart';

part 'register_state.freezed.dart';

/// Estado base para el registro
@freezed
abstract class RegisterState with _$RegisterState {
  const factory RegisterState.initial() = _Initial;
  const factory RegisterState.loading() = _Loading;
  const factory RegisterState.success({
    required String firstName,
    required String lastName,
    required String phone,
    required String email,
    required String password,
  }) = _Success;
  const factory RegisterState.error({required String message}) = _Error;
}
