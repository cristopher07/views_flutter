import '../entities/account_summary_entity.dart';
import '../repositories/dashboard_repository.dart';

class GetDashboardAccountsUseCase {
  final DashboardRepository repository;

  const GetDashboardAccountsUseCase(this.repository);

  Future<List<AccountSummaryEntity>> call() {
    return repository.getAccounts();
  }
}
