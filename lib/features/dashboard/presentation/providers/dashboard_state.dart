import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/account_summary_entity.dart';

part 'dashboard_state.freezed.dart';

@freezed
abstract class DashboardState with _$DashboardState {
  const factory DashboardState.initial() = _Initial;
  const factory DashboardState.loading() = _Loading;
  const factory DashboardState.success({
    required List<AccountSummaryEntity> accounts,
  }) = _Success;
  const factory DashboardState.error({required String message}) = _Error;
}
