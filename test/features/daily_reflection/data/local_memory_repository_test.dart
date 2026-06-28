import 'package:flutter_test/flutter_test.dart';
import 'package:heart_talk/features/daily_reflection/data/local_memory_repository.dart';
import 'package:heart_talk/features/daily_reflection/data/shared_preferences_memory_repository.dart';
import 'package:heart_talk/features/daily_reflection/domain/companion_models.dart';
import 'package:heart_talk/features/daily_reflection/domain/local_memory_models.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('InMemoryLocalMemoryRepository', () {
    test('does not persist profile when consent is disabled', () async {
      final repository = InMemoryLocalMemoryRepository();

      await repository.saveSnapshot(
        LocalMemorySnapshot.empty().copyWith(
          consentSettings: ConsentSettings.disabled(),
          profile: const LocalUserProfile(displayName: '저장되면 안 됨'),
        ),
      );

      final loaded = await repository.loadSnapshot();
      expect(loaded.profile.displayName, isEmpty);
      expect(loaded.consentSettings.localMemoryEnabled, isFalse);
    });

    test('persists and clears an enabled local memory snapshot', () async {
      final repository = InMemoryLocalMemoryRepository();
      final snapshot = LocalMemorySnapshot.empty().copyWith(
        consentSettings: ConsentSettings.allEnabled(),
        companionPreference: const CompanionPreference(
          defaultRole: CompanionRole.listener,
        ),
        profile: const LocalUserProfile(displayName: '나'),
        todos: [
          TodoMemory(
            id: 'todo-1',
            title: '물 한 잔 마시기',
            createdAt: DateTime.utc(2026, 6, 28),
          ),
        ],
      );

      await repository.saveSnapshot(snapshot);
      expect(await repository.loadSnapshot(), snapshot);

      await repository.clearAll();
      expect(await repository.loadSnapshot(), LocalMemorySnapshot.empty());
    });
  });

  group('SharedPreferencesLocalMemoryRepository', () {
    test('round trips enabled snapshot through SharedPreferences', () async {
      SharedPreferences.setMockInitialValues({});
      final preferences = await SharedPreferences.getInstance();
      final repository = SharedPreferencesLocalMemoryRepository(preferences);
      final snapshot = LocalMemorySnapshot.empty().copyWith(
        consentSettings: ConsentSettings.allEnabled(),
        companionPreference: const CompanionPreference(
          defaultRole: CompanionRole.family,
          affectionLevel: 5,
        ),
        profile: const LocalUserProfile(displayName: '나', interests: ['기록']),
      );

      await repository.saveSnapshot(snapshot);

      final loaded = await repository.loadSnapshot();
      expect(loaded, snapshot);
    });

    test('removes stored snapshot on clearAll', () async {
      SharedPreferences.setMockInitialValues({});
      final preferences = await SharedPreferences.getInstance();
      final repository = SharedPreferencesLocalMemoryRepository(preferences);

      await repository.saveSnapshot(
        LocalMemorySnapshot.empty().copyWith(
          consentSettings: ConsentSettings.allEnabled(),
          profile: const LocalUserProfile(displayName: '나'),
        ),
      );
      await repository.clearAll();

      expect(await repository.loadSnapshot(), LocalMemorySnapshot.empty());
    });
  });
}
