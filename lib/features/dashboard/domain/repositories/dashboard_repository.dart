import '../entities/account_summary_entity.dart';

abstract class DashboardRepository {
  Future<List<AccountSummaryEntity>> getAccounts();
}
