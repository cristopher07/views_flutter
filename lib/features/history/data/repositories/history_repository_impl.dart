import '../../domain/entities/history_entity.dart';
import '../../domain/repositories/history_repository.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  @override
  Future<List<HistoryEntity>> getHistory() async {
    return const [
      HistoryEntity(
        operationId: 'OP-0001',
        description: 'Sample operation',
      ),
    ];
  }
}
