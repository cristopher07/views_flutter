import '../../domain/entities/transfer_entity.dart';
import '../../domain/repositories/transfer_repository.dart';

class TransferRepositoryImpl implements TransferRepository {
  @override
  Future<TransferEntity> createTransfer() async {
    return const TransferEntity(
      reference: 'TRX-0001',
      amount: 0,
    );
  }
}
