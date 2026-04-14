import '../entities/transfer_entity.dart';
import '../repositories/transfer_repository.dart';

class CreateTransferUseCase {
  final TransferRepository repository;

  CreateTransferUseCase({required this.repository});

  Future<TransferEntity> call({
    required String accountFromId,
    required String accountToId,
    required double amount,
  }) {
    return repository.createTransfer(
      accountFromId: accountFromId,
      accountToId: accountToId,
      amount: amount,
    );
  }
}
