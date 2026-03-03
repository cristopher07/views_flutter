import '../entities/transfer_entity.dart';

abstract class TransferRepository {
  Future<TransferEntity> createTransfer();
}
