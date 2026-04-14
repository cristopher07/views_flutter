import '../entities/account_entity.dart';
import '../repositories/transfer_repository.dart';

class GetAccountsUseCase {
  final TransferRepository repository;

  GetAccountsUseCase({required this.repository});

  Future<List<AccountEntity>> call() {
    return repository.getAccounts();
  }
}
