import '../entities/network_entity.dart';
import '../entities/topup_entity.dart';

abstract class TopUpRepository {
  Future<List<NetworkEntity>> getNetworks();
  Future<TopUpEntity> createTopUp({
    required String phoneNumber,
    required String networkId,
    required double amount,
  });
  Future<List<TopUpEntity>> getTopUpHistory();
}
