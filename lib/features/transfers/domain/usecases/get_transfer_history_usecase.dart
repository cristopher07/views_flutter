import '../entities/transfer_entity.dart';
import '../repositories/transfer_repository.dart';

class GetTransferHistoryUseCase {
  final TransferRepository repository;

  GetTransferHistoryUseCase({required this.repository});

  Future<List<TransferEntity>> call() {
    return repository.getTransferHistory();
  }
}
