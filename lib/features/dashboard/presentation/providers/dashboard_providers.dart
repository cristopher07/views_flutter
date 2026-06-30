import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/dashboard_mock_data_source.dart';
import '../../data/repositories/dashboard_repository_impl.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../../domain/usecases/get_dashboard_accounts_usecase.dart';
import 'dashboard_notifier.dart';
import 'dashboard_state.dart';

final dashboardMockDataSourceProvider = Provider<DashboardMockDataSource>((
  ref,
) {
  return DashboardMockDataSourceImpl();
});

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  final mockDataSource = ref.watch(dashboardMockDataSourceProvider);
  return DashboardRepositoryImpl(mockDataSource: mockDataSource);
});

final getDashboardAccountsUseCaseProvider =
    Provider<GetDashboardAccountsUseCase>((ref) {
      final repository = ref.watch(dashboardRepositoryProvider);
      return GetDashboardAccountsUseCase(repository);
    });

final dashboardProvider =
    StateNotifierProvider<DashboardNotifier, DashboardState>((ref) {
      final useCase = ref.watch(getDashboardAccountsUseCaseProvider);
      return DashboardNotifier(useCase);
    });
