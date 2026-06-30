import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/get_dashboard_accounts_usecase.dart';
import 'dashboard_state.dart';

class DashboardNotifier extends StateNotifier<DashboardState> {
  final GetDashboardAccountsUseCase _getDashboardAccountsUseCase;

  DashboardNotifier(this._getDashboardAccountsUseCase)
    : super(const DashboardState.initial()) {
    loadAccounts();
  }

  Future<void> loadAccounts() async {
    state = const DashboardState.loading();

    try {
      final accounts = await _getDashboardAccountsUseCase();
      state = DashboardState.success(accounts: accounts);
    } catch (e) {
      state = DashboardState.error(
        message: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }
}
