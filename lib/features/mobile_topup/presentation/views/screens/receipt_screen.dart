import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/topup_form_provider.dart';

class ReceiptScreen extends ConsumerWidget {
  const ReceiptScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(topUpFormProvider);

    // Si no hay resultado de topup, redirigir a recharge
    if (formState.topUpResult == null) {
      Future.microtask(() => context.go('/'));
      return const SizedBox.shrink();
    }

    final topUpResult = formState.topUpResult!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mobile Top Up'),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Título
            const Text(
              'Confirmation',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            // Subtítulo
            const Text(
              'Successful transfer',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 32),

            // Icono de red con resumen
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  // Logo de la red (simulado con icono)
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: _getNetworkIcon(formState.selectedNetworkId!),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Nombre de la red
                  Text(
                    _getNetworkName(formState.selectedNetworkId!),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Detalles de la transacción
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  _buildDetailRow('Mobile Number', formState.phoneNumber),
                  const SizedBox(height: 16),
                  _buildDetailRow('Network', _getNetworkName(formState.selectedNetworkId!)),
                  const SizedBox(height: 16),
                  _buildDetailRow(
                    'Amount',
                    '\$${formState.selectedAmount!.toStringAsFixed(2)} USD',
                  ),
                  const SizedBox(height: 16),
                  _buildDetailRow('Transfer Fee', '\$0.00'),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Divider(),
                  ),
                  _buildDetailRow(
                    'Total Amount',
                    '\$${formState.selectedAmount!.toStringAsFixed(2)} USD',
                    isBold: true,
                  ),
                  const SizedBox(height: 24),
                  _buildDetailRow(
                    'Reference',
                    topUpResult.reference,
                    fontSize: 12,
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 16),
                  _buildDetailRow(
                    'Date & Time',
                    '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year} ${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
                    fontSize: 12,
                  ),
                  const SizedBox(height: 16),
                  _buildDetailRow(
                    'Status',
                    'Completed',
                    fontSize: 12,
                    color: Colors.green,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Botones de acción
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Receipt downloaded successfully'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                icon: const Icon(Icons.download),
                label: const Text('Download Receipt'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Receipt shared successfully'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                icon: const Icon(Icons.share),
                label: const Text('Share Receipt'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  ref.read(topUpFormProvider.notifier).reset();
                  context.go('/');
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Back Home',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value, {
    bool isBold = false,
    double fontSize = 14,
    Color? color,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: color ?? Colors.black,
          ),
          textAlign: TextAlign.end,
        ),
      ],
    );
  }

  String _getNetworkName(String networkId) {
    const networks = {
      'tigo': 'Tigo',
      'claro': 'Claro',
      'movistar': 'Movistar',
    };
    return networks[networkId] ?? 'Unknown';
  }

  Widget _getNetworkIcon(String networkId) {
    switch (networkId) {
      case 'tigo':
        return Icon(
          Icons.radio_button_checked,
          size: 40,
          color: Colors.yellow.shade700,
        );
      case 'claro':
        return Icon(
          Icons.radio_button_checked,
          size: 40,
          color: Colors.red.shade700,
        );
      case 'movistar':
        return Icon(
          Icons.radio_button_checked,
          size: 40,
          color: Colors.blue.shade700,
        );
      case 'at&t':
        return Icon(
          Icons.radio_button_checked,
          size: 40,
          color: Colors.blue.shade900,
        );
      default:
        return const Icon(Icons.radio_button_checked, size: 40);
    }
  }
}
