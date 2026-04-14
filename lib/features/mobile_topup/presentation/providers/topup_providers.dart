import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/topup_local_data_source.dart';
import '../../data/repositories/topup_repository_impl.dart';
import '../../domain/repositories/topup_repository.dart';
import '../../domain/usecases/create_topup_usecase.dart';
import '../../domain/usecases/get_networks_usecase.dart';

// Datasource Provider
final topupLocalDataSourceProvider = Provider<TopUpLocalDataSource>((ref) {
  return TopUpLocalDataSourceImpl();
});

// Repository Provider
final topupRepositoryProvider = Provider<TopUpRepository>((ref) {
  final dataSource = ref.watch(topupLocalDataSourceProvider);
  return TopUpRepositoryImpl(localDataSource: dataSource);
});

// Use Case Providers
final getNetworksUseCaseProvider = Provider<GetNetworksUseCase>((ref) {
  final repository = ref.watch(topupRepositoryProvider);
  return GetNetworksUseCase(repository: repository);
});

final createTopUpUseCaseProvider = Provider<CreateTopUpUseCase>((ref) {
  final repository = ref.watch(topupRepositoryProvider);
  return CreateTopUpUseCase(repository: repository);
});
