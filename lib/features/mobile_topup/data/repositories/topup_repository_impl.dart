import '../../domain/entities/network_entity.dart';
import '../../domain/entities/topup_entity.dart';
import '../../domain/repositories/topup_repository.dart';
import '../datasources/topup_local_data_source.dart';

class TopUpRepositoryImpl implements TopUpRepository {
  final TopUpLocalDataSource localDataSource;

  TopUpRepositoryImpl({required this.localDataSource});

  @override
  Future<List<NetworkEntity>> getNetworks() {
    return localDataSource.getNetworks();
  }

  @override
  Future<TopUpEntity> createTopUp({
    required String phoneNumber,
    required String networkId,
    required double amount,
  }) {
    return localDataSource.createTopUp(
      phoneNumber: phoneNumber,
      networkId: networkId,
      amount: amount,
    );
  }

  @override
  Future<List<TopUpEntity>> getTopUpHistory() {
    return localDataSource.getTopUpHistory();
  }
}
