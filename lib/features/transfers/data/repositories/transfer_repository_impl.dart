import '../../domain/entities/account_entity.dart';
import '../../domain/entities/transfer_entity.dart';
import '../../domain/repositories/transfer_repository.dart';
import '../datasources/transfer_local_data_source.dart';

class TransferRepositoryImpl implements TransferRepository {
  final TransferLocalDataSource localDataSource;

  TransferRepositoryImpl({required this.localDataSource});

  @override
  Future<List<AccountEntity>> getAccounts() {
    return localDataSource.getAccounts();
  }

  @override
  Future<TransferEntity> createTransfer({
    required String accountFromId,
    required String accountToId,
    required double amount,
  }) {
    return localDataSource.createTransfer(
      accountFromId: accountFromId,
      accountToId: accountToId,
      amount: amount,
    );
  }

  @override
  Future<List<TransferEntity>> getTransferHistory() {
    return localDataSource.getTransferHistory();
  }
}

