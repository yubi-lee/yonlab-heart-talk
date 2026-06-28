import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/local_memory_models.dart';
import 'local_memory_repository.dart';

class SharedPreferencesLocalMemoryRepository implements LocalMemoryRepository {
  SharedPreferencesLocalMemoryRepository(this._preferences);

  static const _snapshotKey = 'heart_talk.local_memory_snapshot.v1';

  final SharedPreferences _preferences;

  @override
  Future<LocalMemorySnapshot> loadSnapshot() async {
    final encoded = _preferences.getString(_snapshotKey);
    if (encoded == null || encoded.isEmpty) {
      return LocalMemorySnapshot.empty();
    }

    final decoded = jsonDecode(encoded);
    if (decoded is Map) {
      return LocalMemorySnapshot.fromJson(
        decoded.map((key, value) => MapEntry(key.toString(), value)),
      );
    }
    return LocalMemorySnapshot.empty();
  }

  @override
  Future<void> saveSnapshot(LocalMemorySnapshot snapshot) async {
    final sanitized = sanitizeSnapshotForConsent(snapshot);
    if (!sanitized.consentSettings.localMemoryEnabled) {
      await _preferences.remove(_snapshotKey);
      return;
    }
    await _preferences.setString(_snapshotKey, jsonEncode(sanitized.toJson()));
  }

  @override
  Future<void> clearAll() async {
    await _preferences.remove(_snapshotKey);
  }
}
