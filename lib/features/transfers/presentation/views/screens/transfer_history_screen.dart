import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/transfer_entity.dart';
import '../../../domain/repositories/transfer_repository.dart';
import '../../providers/transfer_providers.dart';

final transferHistoryProvider = FutureProvider<List<TransferEntity>>((ref) {
  final useCase = ref.watch(getTransferHistoryUseCaseProvider);
  return useCase.call();
});

class TransferHistoryScreen extends ConsumerWidget {
  const TransferHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(transferHistoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Transferencias'),
      ),
      body: historyAsync.when(
        data: (transfers) {
          if (transfers.isEmpty) {
            return const Center(
              child: Text('No hay transferencias registradas'),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: transfers.length,
            itemBuilder: (context, index) {
              final transfer = transfers[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  title: Text(
                    'Ref: ${transfer.reference}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text('De: ${transfer.accountFrom} → A: ${transfer.accountTo}'),
                      Text(
                        transfer.date.toString().split('.')[0],
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '\$${transfer.amount.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      Text(
                        transfer.status.toUpperCase(),
                        style: TextStyle(
                          fontSize: 12,
                          color: transfer.status == 'completed' ? Colors.green : Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error: ${error.toString()}'),
        ),
      ),
    );
  }
}
