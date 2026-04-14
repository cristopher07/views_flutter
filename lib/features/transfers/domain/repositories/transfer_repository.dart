import '../entities/account_entity.dart';
import '../entities/transfer_entity.dart';

abstract class TransferRepository {
  Future<List<AccountEntity>> getAccounts();
  Future<TransferEntity> createTransfer({
    required String accountFromId,
    required String accountToId,
    required double amount,
  });
  Future<List<TransferEntity>> getTransferHistory();
}
