import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../domain/entities/network_entity.dart';
import '../../providers/networks_provider.dart';
import '../../providers/topup_form_provider.dart';
import '../../../../login/presentation/providers/login_providers.dart';

class RechargeScreen extends ConsumerStatefulWidget {
  const RechargeScreen({super.key});

  @override
  ConsumerState<RechargeScreen> createState() => _RechargeScreenState();
}

class _RechargeScreenState extends ConsumerState<RechargeScreen> {
  late TextEditingController _phoneController;
  final List<double> _quickAmounts = [50.0, 100.0, 150.0];

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final networkAsync = ref.watch(networksProvider);
    final formState = ref.watch(topUpFormProvider);
    final displayName = ref.watch(currentUserDisplayNameProvider);

    return Scaffold(
      appBar: AppBar(
        title: displayName == null
            ? const Text('Mobile Top Up')
            : Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Mobile Top Up'),
                  Text(
                    displayName,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.grey),
                  ),
                ],
              ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            tooltip: 'Cerrar sesión',
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(loginProvider.notifier).logout();
              if (context.mounted) context.go('/login');
            },
          ),
        ],
      ),
      body: networkAsync.when(
        data: (networks) => _buildForm(context, networks, formState, ref),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error: ${error.toString()}'),
        ),
      ),
    );
  }

  Widget _buildForm(
    BuildContext context,
    List<NetworkEntity> networks,
    TopUpFormState formState,
    WidgetRef ref,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título
          const Text(
            'Recharge',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),

          // Sección: Número móvil
          const Text(
            'Add Mobile Number',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            onChanged: (value) {
              ref.read(topUpFormProvider.notifier).setPhoneNumber(value);
            },
            decoration: InputDecoration(
              hintText: 'Enter mobile number',
              hintStyle: TextStyle(color: Colors.grey.shade400),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.blue),
              ),
              prefixIcon: const Icon(Icons.phone),
            ),
          ),
          const SizedBox(height: 32),

          // Sección: Seleccionar red
          const Text(
            'Select Network',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 12),
          _buildNetworkGrid(networks, formState, ref),
          const SizedBox(height: 32),

          // Sección: Monto
          const Text(
            'Enter Amount',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Text(
                  '\$',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    formState.selectedAmount?.toStringAsFixed(2) ?? '0.00',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Quick select buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _quickAmounts
                .map(
                  (amount) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: OutlinedButton(
                        onPressed: () {
                          ref
                              .read(topUpFormProvider.notifier)
                              .setSelectedAmount(amount);
                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor:
                              formState.selectedAmount == amount
                                  ? Colors.blue
                                  : Colors.transparent,
                          side: BorderSide(
                            color: formState.selectedAmount == amount
                                ? Colors.blue
                                : Colors.grey.shade300,
                          ),
                        ),
                        child: Text(
                          '\$${amount.toInt()}',
                          style: TextStyle(
                            color: formState.selectedAmount == amount
                                ? Colors.white
                                : Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 32),

          // Error message
          if (formState.error != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  formState.error!,
                  style: TextStyle(color: Colors.red.shade900),
                ),
              ),
            ),

          // Botón Continue
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: formState.isFormValid
                  ? () => _handleContinue(context, ref)
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                disabledBackgroundColor: Colors.grey.shade300,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Continue',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNetworkGrid(
    List<NetworkEntity> networks,
    TopUpFormState formState,
    WidgetRef ref,
  ) {
    return GridView.count(
      crossAxisCount: 4,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: networks
          .map(
            (network) => GestureDetector(
              onTap: () {
                ref
                    .read(topUpFormProvider.notifier)
                    .setSelectedNetwork(network.id);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: formState.selectedNetworkId == network.id
                      ? Colors.blue
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: formState.selectedNetworkId == network.id
                        ? Colors.blue
                        : Colors.grey.shade300,
                    width: 2,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      network.icon,
                      width: 50,
                      height: 50,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      network.name,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: formState.selectedNetworkId == network.id
                            ? Colors.white
                            : Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  void _handleContinue(BuildContext context, WidgetRef ref) {
    ref.read(topUpFormProvider.notifier).submitTopUp();
    // Navegar a la pantalla de confirmación
    context.push('/confirmation');
  }
}
