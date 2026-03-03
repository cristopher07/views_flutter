import '../../domain/entities/dashboard_entity.dart';
import '../../domain/repositories/dashboard_repository.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  @override
  Future<DashboardEntity> getDashboardData() async {
    return const DashboardEntity(
      title: 'Dashboard',
      notifications: 0,
    );
  }
}
