import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/network_entity.dart';
import 'topup_providers.dart';

final networksProvider = FutureProvider<List<NetworkEntity>>((ref) {
  final useCase = ref.watch(getNetworksUseCaseProvider);
  return useCase.call();
});
