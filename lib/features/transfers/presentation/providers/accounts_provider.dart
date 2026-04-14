import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/account_entity.dart';
import '../providers/transfer_providers.dart';

final accountsProvider = FutureProvider<List<AccountEntity>>((ref) {
  final useCase = ref.watch(getAccountsUseCaseProvider);
  return useCase.call();
});
