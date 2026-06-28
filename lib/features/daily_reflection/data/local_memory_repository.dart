import '../domain/companion_models.dart';
import '../domain/local_memory_models.dart';

abstract class LocalMemoryRepository {
  Future<LocalMemorySnapshot> loadSnapshot();
  Future<void> saveSnapshot(LocalMemorySnapshot snapshot);
  Future<void> clearAll();
}

class InMemoryLocalMemoryRepository implements LocalMemoryRepository {
  LocalMemorySnapshot _snapshot = LocalMemorySnapshot.empty();

  @override
  Future<LocalMemorySnapshot> loadSnapshot() async {
    return _snapshot;
  }

  @override
  Future<void> saveSnapshot(LocalMemorySnapshot snapshot) async {
    _snapshot = _sanitizeForConsent(snapshot);
  }

  @override
  Future<void> clearAll() async {
    _snapshot = LocalMemorySnapshot.empty();
  }
}

LocalMemorySnapshot sanitizeSnapshotForConsent(LocalMemorySnapshot snapshot) {
  return _sanitizeForConsent(snapshot);
}

LocalMemorySnapshot _sanitizeForConsent(LocalMemorySnapshot snapshot) {
  final consent = snapshot.consentSettings;
  if (!consent.localMemoryEnabled) {
    return LocalMemorySnapshot.empty().copyWith(consentSettings: consent);
  }

  return snapshot.copyWith(
    profile: consent.canStore(MemoryCategory.profile)
        ? snapshot.profile
        : const LocalUserProfile(),
    dailyEntries: consent.canStore(MemoryCategory.reflectionEntries)
        ? snapshot.dailyEntries
        : const [],
    memoryItems: snapshot.memoryItems
        .where((item) => consent.canStore(item.category))
        .toList(),
    people: consent.canStore(MemoryCategory.people)
        ? snapshot.people
        : const [],
    todos: consent.canStore(MemoryCategory.todos) ? snapshot.todos : const [],
    recurringKeywords: consent.canStore(MemoryCategory.recurringKeywords)
        ? snapshot.recurringKeywords
        : const {},
  );
}
