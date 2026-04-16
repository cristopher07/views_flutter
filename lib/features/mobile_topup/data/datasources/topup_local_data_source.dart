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
  final List<NetworkEntity> _networks = [
    const NetworkEntity(
      id: 'tigo',
      name: 'Tigo',
      icon: 'assets/networks/icono_tigo.png',
      fee: 0.00,
      minAmount: 10.0,
      maxAmount: 500.0,
    ),
    const NetworkEntity(
      id: 'claro',
      name: 'Claro',
      icon: 'assets/networks/icono_claro.png',
      fee: 0.00,
      minAmount: 10.0,
      maxAmount: 500.0,
    ),
    const NetworkEntity(
      id: 'movistar',
      name: 'Movistar',
      icon: 'assets/networks/icono_movistar.png',
      fee: 0.00,
      minAmount: 10.0,
      maxAmount: 500.0,
    ),
  ];

  final List<TopUpEntity> _topUpHistory = [];

  @override
  Future<List<NetworkEntity>> getNetworks() async {

    await Future.delayed(const Duration(seconds: 1));
    return _networks;
  }

  @override
  Future<TopUpEntity> createTopUp({
    required String phoneNumber,
    required String networkId,
    required double amount,
  }) async {

    await Future.delayed(const Duration(seconds: 2));

   
    final network = _networks.firstWhere(
      (net) => net.id == networkId,
      orElse: () => throw Exception('Red no encontrada'),
    );


    if (amount < network.minAmount || amount > network.maxAmount) {
      throw Exception(
        'El monto debe estar entre \$${network.minAmount} y \$${network.maxAmount}',
      );
    }


    if (!RegExp(r'^\d{8}$').hasMatch(phoneNumber.replaceAll(RegExp(r'[^\d]'), ''))) {
      throw Exception('Número de teléfono inválido');
    }


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
