import '../../domain/entities/settings_entity.dart';
import '../../domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  @override
  Future<SettingsEntity> getSettings() async {
    return const SettingsEntity(
      notificationsEnabled: true,
      languageCode: 'en',
    );
  }
}
