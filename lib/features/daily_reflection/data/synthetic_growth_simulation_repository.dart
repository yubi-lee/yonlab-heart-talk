import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/synthetic_growth_simulation_models.dart';

abstract class SyntheticGrowthSimulationRepository {
  Future<SyntheticGrowthSimulationSession?> loadSession();
  Future<void> saveSession(SyntheticGrowthSimulationSession session);
  Future<void> clearSession();
}

class SharedPreferencesSyntheticGrowthSimulationRepository
    implements SyntheticGrowthSimulationRepository {
  SharedPreferencesSyntheticGrowthSimulationRepository(this._preferences);

  static const _sessionKey =
      'heart_talk.synthetic_growth_simulation_session.v1';

  final SharedPreferences _preferences;

  @override
  Future<SyntheticGrowthSimulationSession?> loadSession() async {
    final encoded = _preferences.getString(_sessionKey);
    if (encoded == null || encoded.isEmpty) {
      return null;
    }

    final decoded = jsonDecode(encoded);
    if (decoded is Map) {
      return SyntheticGrowthSimulationSession.fromJson(
        decoded.map((key, value) => MapEntry(key.toString(), value)),
      );
    }
    return null;
  }

  @override
  Future<void> saveSession(SyntheticGrowthSimulationSession session) async {
    await _preferences.setString(_sessionKey, jsonEncode(session.toJson()));
  }

  @override
  Future<void> clearSession() async {
    await _preferences.remove(_sessionKey);
  }
}

class InMemorySyntheticGrowthSimulationRepository
    implements SyntheticGrowthSimulationRepository {
  SyntheticGrowthSimulationSession? _session;

  @override
  Future<SyntheticGrowthSimulationSession?> loadSession() async {
    return _session;
  }

  @override
  Future<void> saveSession(SyntheticGrowthSimulationSession session) async {
    _session = session;
  }

  @override
  Future<void> clearSession() async {
    _session = null;
  }
}
