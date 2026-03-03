import '../entities/history_entity.dart';
import '../repositories/history_repository.dart';

class GetHistoryUseCase {
  final HistoryRepository repository;

  const GetHistoryUseCase(this.repository);

  Future<List<HistoryEntity>> call() {
    return repository.getHistory();
  }
}
