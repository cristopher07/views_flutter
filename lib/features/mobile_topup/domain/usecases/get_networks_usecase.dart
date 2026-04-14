import '../entities/network_entity.dart';
import '../repositories/topup_repository.dart';

class GetNetworksUseCase {
  final TopUpRepository repository;

  GetNetworksUseCase({required this.repository});

  Future<List<NetworkEntity>> call() {
    return repository.getNetworks();
  }
}
