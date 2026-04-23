import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/transfer_local_data_source.dart';
import '../../data/repositories/transfer_repository_impl.dart';
import '../../domain/repositories/transfer_repository.dart';
import '../../domain/usecases/create_transfer_use_case.dart';
import '../../domain/usecases/get_accounts_usecase.dart';
import '../../domain/usecases/get_transfer_history_usecase.dart';
import 'transfer_bloc.dart';

// Datasource Provider
final transferLocalDataSourceProvider = Provider<TransferLocalDataSource>((ref) {
  return TransferLocalDataSourceImpl();
});

// Repository Provider
final transferRepositoryProvider = Provider<TransferRepository>((ref) {
  final dataSource = ref.watch(transferLocalDataSourceProvider);
  return TransferRepositoryImpl(localDataSource: dataSource);
});

// Use Case Providers
final getAccountsUseCaseProvider = Provider<GetAccountsUseCase>((ref) {
  final repository = ref.watch(transferRepositoryProvider);
  return GetAccountsUseCase(repository: repository);
});

final createTransferUseCaseProvider = Provider<CreateTransferUseCase>((ref) {
  final repository = ref.watch(transferRepositoryProvider);
  return CreateTransferUseCase(repository: repository);
});

final getTransferHistoryUseCaseProvider = Provider<GetTransferHistoryUseCase>((ref) {
  final repository = ref.watch(transferRepositoryProvider);
  return GetTransferHistoryUseCase(repository: repository);
});

// BLoC Provider
final transferBlocProvider = Provider<TransferBloc>((ref) {
  final useCase = ref.watch(createTransferUseCaseProvider);
  return TransferBloc(createTransferUseCase: useCase);
});
