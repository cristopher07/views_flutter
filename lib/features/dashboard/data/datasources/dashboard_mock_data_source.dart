import '../../domain/entities/account_summary_entity.dart';

abstract class DashboardMockDataSource {
  Future<List<AccountSummaryEntity>> getAccounts();
}

class DashboardMockDataSourceImpl implements DashboardMockDataSource {
  List<AccountSummaryEntity>? _cachedAccounts;

  @override
  Future<List<AccountSummaryEntity>> getAccounts() async {
    if (_cachedAccounts != null) {
      return _cachedAccounts!;
    }

    await Future.delayed(const Duration(milliseconds: 600));

    _cachedAccounts = const [
      AccountSummaryEntity(
        id: 'monetaria-001',
        type: 'Cuenta Monetaria',
        number: '0101 2233 4455 6677',
        owner: 'Cristopher Sarceno',
        balance: 18425893.50,
      ),
      AccountSummaryEntity(
        id: 'ahorro-001',
        type: 'Cuenta de Ahorro',
        number: '0101 9988 7766 5544',
        owner: 'Cristopher Sarceno',
        balance: 15230890.00,
      ),
    ];

    return _cachedAccounts!;
  }
}
