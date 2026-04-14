import '../../domain/entities/network_entity.dart';
import '../../domain/entities/topup_entity.dart';

abstract class TopUpLocalDataSource {
  Future<List<NetworkEntity>> getNetworks();
  Future<TopUpEntity> createTopUp({
    required String phoneNumber,
    required String networkId,
    required double amount,
  });
  Future<List<TopUpEntity>> getTopUpHistory();
}

class TopUpLocalDataSourceImpl implements TopUpLocalDataSource {
  // Operadores de red disponibles
  final List<NetworkEntity> _networks = [
    const NetworkEntity(
      id: 'AT_T',
      name: 'AT&T',
      icon: '📱',
      fee: 0.00,
      minAmount: 10.0,
      maxAmount: 500.0,
    ),
    const NetworkEntity(
      id: 'TMOBILE',
      name: 'T-Mobile',
      icon: '📱',
      fee: 0.00,
      minAmount: 10.0,
      maxAmount: 500.0,
    ),
    const NetworkEntity(
      id: 'VERIZON',
      name: 'Verizon',
      icon: '📱',
      fee: 0.00,
      minAmount: 10.0,
      maxAmount: 500.0,
    ),
    const NetworkEntity(
      id: 'SPRINT',
      name: 'Sprint',
      icon: '📱',
      fee: 0.00,
      minAmount: 10.0,
      maxAmount: 500.0,
    ),
  ];

  final List<TopUpEntity> _topUpHistory = [];

  @override
  Future<List<NetworkEntity>> getNetworks() async {
    // Simulamos un delay de carga de 1 segundo
    await Future.delayed(const Duration(seconds: 1));
    return _networks;
  }

  @override
  Future<TopUpEntity> createTopUp({
    required String phoneNumber,
    required String networkId,
    required double amount,
  }) async {
    // Simulamos un delay de 2 segundos para procesar la recarga
    await Future.delayed(const Duration(seconds: 2));

    // Validar que la red exista
    final network = _networks.firstWhere(
      (net) => net.id == networkId,
      orElse: () => throw Exception('Red no encontrada'),
    );

    // Validar rango de monto
    if (amount < network.minAmount || amount > network.maxAmount) {
      throw Exception(
        'El monto debe estar entre \$${network.minAmount} y \$${network.maxAmount}',
      );
    }

    // Validar teléfono (formato simple: 10 dígitos)
    if (!RegExp(r'^\d{10}$').hasMatch(phoneNumber.replaceAll(RegExp(r'[^\d]'), ''))) {
      throw Exception('Número de teléfono inválido');
    }

    // Crear recarga
    final topUp = TopUpEntity(
      reference: 'TOP-${DateTime.now().millisecondsSinceEpoch}',
      phoneNumber: phoneNumber,
      amount: amount,
      networkId: networkId,
      networkName: network.name,
      transferFee: network.fee,
      date: DateTime.now(),
      status: 'completed',
    );


    _topUpHistory.add(topUp);

    return topUp;
  }

  @override
  Future<List<TopUpEntity>> getTopUpHistory() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _topUpHistory;
  }
}
