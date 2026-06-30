import '../../domain/entities/account_summary_entity.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/dashboard_mock_data_source.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardMockDataSource mockDataSource;

  const DashboardRepositoryImpl({required this.mockDataSource});

  @override
  Future<List<AccountSummaryEntity>> getAccounts() {
    return mockDataSource.getAccounts();
  }
}
