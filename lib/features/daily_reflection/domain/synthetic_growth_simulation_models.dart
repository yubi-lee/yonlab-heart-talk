import 'companion_models.dart';
import 'local_memory_models.dart';

class LifeScenePreset {
  const LifeScenePreset({
    required this.id,
    required this.displayNameKo,
    required this.descriptionKo,
    required this.preferredRole,
    required this.recurringKeywords,
    required this.moodPattern,
    required this.todoThemes,
    required this.personThemes,
    required this.reflectionTemplates,
    required this.profileNameKo,
    required this.profileInterestsKo,
    required this.profileContextKo,
  });

  final String id;
  final String displayNameKo;
  final String descriptionKo;
  final CompanionRole preferredRole;
  final List<String> recurringKeywords;
  final List<String> moodPattern;
  final List<String> todoThemes;
  final List<String> personThemes;
  final List<String> reflectionTemplates;
  final String profileNameKo;
  final List<String> profileInterestsKo;
  final String profileContextKo;

  Map<String, Object?> toJson() => {
    'id': id,
    'displayNameKo': displayNameKo,
    'descriptionKo': descriptionKo,
    'preferredRole': preferredRole.name,
    'recurringKeywords': recurringKeywords,
    'moodPattern': moodPattern,
    'todoThemes': todoThemes,
    'personThemes': personThemes,
    'reflectionTemplates': reflectionTemplates,
    'profileNameKo': profileNameKo,
    'profileInterestsKo': profileInterestsKo,
    'profileContextKo': profileContextKo,
  };

  factory LifeScenePreset.fromJson(Map<String, Object?> json) {
    return LifeScenePreset(
      id: json['id'] as String? ?? '',
      displayNameKo: json['displayNameKo'] as String? ?? '',
      descriptionKo: json['descriptionKo'] as String? ?? '',
      preferredRole: _enumByName(
        CompanionRole.values,
        json['preferredRole'] as String?,
        CompanionRole.friend,
      ),
      recurringKeywords: _stringList(json['recurringKeywords']),
      moodPattern: _stringList(json['moodPattern']),
      todoThemes: _stringList(json['todoThemes']),
      personThemes: _stringList(json['personThemes']),
      reflectionTemplates: _stringList(json['reflectionTemplates']),
      profileNameKo: json['profileNameKo'] as String? ?? '',
      profileInterestsKo: _stringList(json['profileInterestsKo']),
      profileContextKo: json['profileContextKo'] as String? ?? '',
    );
  }
}

class SyntheticGrowthSimulationSession {
  const SyntheticGrowthSimulationSession({
    required this.presetId,
    required this.generatedAt,
    required this.dayCount,
    required this.snapshot,
  });

  final String presetId;
  final DateTime generatedAt;
  final int dayCount;
  final LocalMemorySnapshot snapshot;

  Map<String, Object?> toJson() => {
    'presetId': presetId,
    'generatedAt': generatedAt.toIso8601String(),
    'dayCount': dayCount,
    'snapshot': snapshot.toJson(),
  };

  factory SyntheticGrowthSimulationSession.fromJson(Map<String, Object?> json) {
    return SyntheticGrowthSimulationSession(
      presetId: json['presetId'] as String? ?? '',
      generatedAt: _dateTime(json['generatedAt']),
      dayCount: json['dayCount'] as int? ?? 100,
      snapshot: LocalMemorySnapshot.fromJson(_map(json['snapshot'])),
    );
  }
}

T _enumByName<T extends Enum>(List<T> values, String? name, T fallback) {
  for (final value in values) {
    if (value.name == name) {
      return value;
    }
  }
  return fallback;
}

DateTime _dateTime(Object? value) {
  if (value is String) {
    return DateTime.tryParse(value) ??
        DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);
  }
  return DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);
}

Map<String, Object?> _map(Object? value) {
  if (value is Map) {
    return value.map((key, value) => MapEntry(key.toString(), value));
  }
  return const {};
}

List<String> _stringList(Object? value) {
  if (value is List) {
    return value.whereType<String>().toList(growable: false);
  }
  return const [];
}
