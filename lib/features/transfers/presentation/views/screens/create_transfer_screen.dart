import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/account_entity.dart';
import '../../providers/accounts_provider.dart';
import '../../providers/transfer_notifier.dart';

class CreateTransferScreen extends ConsumerStatefulWidget {
  const CreateTransferScreen({super.key});

  @override
  ConsumerState<CreateTransferScreen> createState() => _CreateTransferScreenState();
}

class _CreateTransferScreenState extends ConsumerState<CreateTransferScreen> {
  AccountEntity? _selectedFromAccount;
  AccountEntity? _selectedToAccount;
  final _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accountsAsync = ref.watch(accountsProvider);
    final transferState = ref.watch(transferNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva Transferencia'),
      ),
      body: accountsAsync.when(
        data: (accounts) => _buildForm(context, accounts, transferState, ref),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error: ${error.toString()}'),
        ),
      ),
    );
  }

  Widget _buildForm(
    BuildContext context,
    List<AccountEntity> accounts,
    TransferState transferState,
    WidgetRef ref,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cuenta Origen
          const Text(
            'Cuenta Origen',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          DropdownButton<AccountEntity>(
            isExpanded: true,
            value: _selectedFromAccount,
            hint: const Text('Selecciona cuenta origen'),
            items: accounts
                .map(
                  (account) => DropdownMenuItem(
                    value: account,
                    child: Text('${account.accountHolder} - \$${account.balance}'),
                  ),
                )
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedFromAccount = value;
              });
            },
          ),
          const SizedBox(height: 24),

          // Cuenta Destino
          const Text(
            'Cuenta Destino',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          DropdownButton<AccountEntity>(
            isExpanded: true,
            value: _selectedToAccount,
            hint: const Text('Selecciona cuenta destino'),
            items: accounts
                .where((acc) => acc.id != _selectedFromAccount?.id)
                .map(
                  (account) => DropdownMenuItem(
                    value: account,
                    child: Text('${account.accountHolder} - ${account.bankName}'),
                  ),
                )
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedToAccount = value;
              });
            },
          ),
          const SizedBox(height: 24),

          // Monto
          const Text(
            'Monto',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              hintText: 'Ingresa el monto',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              prefix: const Text('\$ '),
            ),
          ),
          const SizedBox(height: 32),

          // Error message
          if (transferState.error != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  transferState.error!,
                  style: TextStyle(color: Colors.red.shade900),
                ),
              ),
            ),

          // Botón submit
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: transferState.isLoading
                  ? null
                  : () => _handleCreateTransfer(ref),
              child: transferState.isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Realizar Transferencia'),
            ),
          ),

          // Success message
          if (transferState.transfer != null)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '✓ Transferencia completada',
                      style: TextStyle(
                        color: Colors.green.shade900,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('Referencia: ${transferState.transfer!.reference}'),
                    Text('Monto: \$${transferState.transfer!.amount.toStringAsFixed(2)}'),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _handleCreateTransfer(WidgetRef ref) {
    if (_selectedFromAccount == null || _selectedToAccount == null || _amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor completa todos los campos')),
      );
      return;
    }

    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa un monto válido')),
      );
      return;
    }

    ref.read(transferNotifierProvider.notifier).createTransfer(
          _selectedFromAccount!.id,
          _selectedToAccount!.id,
          amount,
        );
  }
}
