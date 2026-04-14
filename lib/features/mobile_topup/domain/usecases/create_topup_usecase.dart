import '../entities/topup_entity.dart';
import '../repositories/topup_repository.dart';

class CreateTopUpUseCase {
  final TopUpRepository repository;

  CreateTopUpUseCase({required this.repository});

  Future<TopUpEntity> call({
    required String phoneNumber,
    required String networkId,
    required double amount,
  }) {
    return repository.createTopUp(
      phoneNumber: phoneNumber,
      networkId: networkId,
      amount: amount,
    );
  }
}
