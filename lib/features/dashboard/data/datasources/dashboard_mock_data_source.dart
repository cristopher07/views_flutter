import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/account_summary_entity.dart';

abstract class DashboardMockDataSource {
  Future<List<AccountSummaryEntity>> getAccounts();
}

class DashboardMockDataSourceImpl implements DashboardMockDataSource {
  DashboardMockDataSourceImpl({SharedPreferencesAsync? preferences})
    : _preferences = preferences ?? SharedPreferencesAsync();

  static const String _accountsCacheKey = 'dashboard.accounts_cache';

  final SharedPreferencesAsync _preferences;
  List<AccountSummaryEntity>? _cachedAccounts;

  @override
  Future<List<AccountSummaryEntity>> getAccounts() async {
    if (_cachedAccounts != null) {
      return _cachedAccounts!;
    }

    final cachedAccounts = await _readCachedAccounts();
    if (cachedAccounts != null) {
      _cachedAccounts = cachedAccounts;
      return cachedAccounts;
    }

    await Future.delayed(const Duration(milliseconds: 600));

    final mockAccounts = const [
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

    await _saveAccounts(mockAccounts);
    _cachedAccounts = mockAccounts;
    return _cachedAccounts!;
  }

  Future<List<AccountSummaryEntity>?> _readCachedAccounts() async {
    final rawAccounts = await _preferences.getString(_accountsCacheKey);
    if (rawAccounts == null || rawAccounts.isEmpty) return null;

    try {
      final decoded = jsonDecode(rawAccounts);
      if (decoded is! List) return null;

      return decoded
          .whereType<Map<String, dynamic>>()
          .map(_accountFromJson)
          .toList(growable: false);
    } catch (_) {
      await _preferences.remove(_accountsCacheKey);
      return null;
    }
  }

  Future<void> _saveAccounts(List<AccountSummaryEntity> accounts) {
    final encodedAccounts = jsonEncode(accounts.map(_accountToJson).toList());
    return _preferences.setString(_accountsCacheKey, encodedAccounts);
  }

  AccountSummaryEntity _accountFromJson(Map<String, dynamic> json) {
    return AccountSummaryEntity(
      id: json['id'] as String,
      type: json['type'] as String,
      number: json['number'] as String,
      owner: json['owner'] as String,
      balance: (json['balance'] as num).toDouble(),
    );
  }

  Map<String, dynamic> _accountToJson(AccountSummaryEntity account) {
    return {
      'id': account.id,
      'type': account.type,
      'number': account.number,
      'owner': account.owner,
      'balance': account.balance,
    };
  }
}
