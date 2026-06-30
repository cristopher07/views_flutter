// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

part of 'dashboard_state.dart';

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed.',
);

mixin _$DashboardState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<AccountSummaryEntity> accounts) success,
    required TResult Function(String message) error,
  }) => throw _privateConstructorUsedError;
}

class _$InitialImpl implements _Initial {
  const _$InitialImpl();

  @override
  String toString() => 'DashboardState.initial()';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other.runtimeType == runtimeType && other is _$InitialImpl);

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<AccountSummaryEntity> accounts) success,
    required TResult Function(String message) error,
  }) {
    return initial();
  }
}

abstract class _Initial implements DashboardState {
  const factory _Initial() = _$InitialImpl;
}

class _$LoadingImpl implements _Loading {
  const _$LoadingImpl();

  @override
  String toString() => 'DashboardState.loading()';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other.runtimeType == runtimeType && other is _$LoadingImpl);

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<AccountSummaryEntity> accounts) success,
    required TResult Function(String message) error,
  }) {
    return loading();
  }
}

abstract class _Loading implements DashboardState {
  const factory _Loading() = _$LoadingImpl;
}

class _$SuccessImpl implements _Success {
  const _$SuccessImpl({required this.accounts});

  @override
  final List<AccountSummaryEntity> accounts;

  @override
  String toString() => 'DashboardState.success(accounts: $accounts)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other.runtimeType == runtimeType &&
          other is _$SuccessImpl &&
          other.accounts == accounts);

  @override
  int get hashCode => Object.hash(runtimeType, accounts);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<AccountSummaryEntity> accounts) success,
    required TResult Function(String message) error,
  }) {
    return success(accounts);
  }
}

abstract class _Success implements DashboardState {
  const factory _Success({required final List<AccountSummaryEntity> accounts}) =
      _$SuccessImpl;

  List<AccountSummaryEntity> get accounts;
}

class _$ErrorImpl implements _Error {
  const _$ErrorImpl({required this.message});

  @override
  final String message;

  @override
  String toString() => 'DashboardState.error(message: $message)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other.runtimeType == runtimeType &&
          other is _$ErrorImpl &&
          other.message == message);

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<AccountSummaryEntity> accounts) success,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }
}

abstract class _Error implements DashboardState {
  const factory _Error({required final String message}) = _$ErrorImpl;

  String get message;
}
