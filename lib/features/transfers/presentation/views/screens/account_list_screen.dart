import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/account_entity.dart';
import '../../providers/accounts_provider.dart';

class AccountListScreen extends ConsumerWidget {
  const AccountListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountsAsync = ref.watch(accountsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Cuentas'),
      ),
      body: accountsAsync.when(
        data: (accounts) => _buildAccountsList(context, accounts),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error: ${error.toString()}'),
        ),
      ),
    );
  }

  Widget _buildAccountsList(BuildContext context, List<AccountEntity> accounts) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: accounts.length,
      itemBuilder: (context, index) {
        final account = accounts[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            title: Text(account.accountHolder),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text('${account.accountType.toUpperCase()} - ${account.bankName}'),
                Text('Cuenta: ${account.accountNumber}'),
              ],
            ),
            trailing: Text(
              '\$${account.balance.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
    );
  }
}
