import 'companion_models.dart';

class LocalUserProfile {
  const LocalUserProfile({
    this.displayName = '',
    this.interests = const [],
    this.importantContext = '',
  });

  final String displayName;
  final List<String> interests;
  final String importantContext;

  Map<String, Object?> toJson() => {
    'displayName': displayName,
    'interests': interests,
    'importantContext': importantContext,
  };

  factory LocalUserProfile.fromJson(Map<String, Object?> json) {
    return LocalUserProfile(
      displayName: json['displayName'] as String? ?? '',
      interests: _stringList(json['interests']),
      importantContext: json['importantContext'] as String? ?? '',
    );
  }

  @override
  bool operator ==(Object other) =>
      other is LocalUserProfile &&
      other.displayName == displayName &&
      _listEquals(other.interests, interests) &&
      other.importantContext == importantContext;

  @override
  int get hashCode =>
      Object.hash(displayName, Object.hashAll(interests), importantContext);
}

class DailyReflectionEntry {
  const DailyReflectionEntry({
    required this.id,
    required this.summary,
    required this.tags,
    required this.createdAt,
  });

  final String id;
  final String summary;
  final List<String> tags;
  final DateTime createdAt;

  Map<String, Object?> toJson() => {
    'id': id,
    'summary': summary,
    'tags': tags,
    'createdAt': createdAt.toIso8601String(),
  };

  factory DailyReflectionEntry.fromJson(Map<String, Object?> json) {
    return DailyReflectionEntry(
      id: json['id'] as String? ?? '',
      summary: json['summary'] as String? ?? '',
      tags: _stringList(json['tags']),
      createdAt: _dateTime(json['createdAt']),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is DailyReflectionEntry &&
      other.id == id &&
      other.summary == summary &&
      _listEquals(other.tags, tags) &&
      other.createdAt == createdAt;

  @override
  int get hashCode => Object.hash(id, summary, Object.hashAll(tags), createdAt);
}

class MemoryItem {
  const MemoryItem({
    required this.id,
    required this.category,
    required this.label,
    required this.createdAt,
  });

  final String id;
  final MemoryCategory category;
  final String label;
  final DateTime createdAt;

  Map<String, Object?> toJson() => {
    'id': id,
    'category': category.name,
    'label': label,
    'createdAt': createdAt.toIso8601String(),
  };

  factory MemoryItem.fromJson(Map<String, Object?> json) {
    return MemoryItem(
      id: json['id'] as String? ?? '',
      category: _memoryCategory(json['category']),
      label: json['label'] as String? ?? '',
      createdAt: _dateTime(json['createdAt']),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is MemoryItem &&
      other.id == id &&
      other.category == category &&
      other.label == label &&
      other.createdAt == createdAt;

  @override
  int get hashCode => Object.hash(id, category, label, createdAt);
}

class PersonMemory {
  const PersonMemory({
    required this.id,
    required this.label,
    required this.note,
    required this.createdAt,
  });

  final String id;
  final String label;
  final String note;
  final DateTime createdAt;

  Map<String, Object?> toJson() => {
    'id': id,
    'label': label,
    'note': note,
    'createdAt': createdAt.toIso8601String(),
  };

  factory PersonMemory.fromJson(Map<String, Object?> json) {
    return PersonMemory(
      id: json['id'] as String? ?? '',
      label: json['label'] as String? ?? '',
      note: json['note'] as String? ?? '',
      createdAt: _dateTime(json['createdAt']),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is PersonMemory &&
      other.id == id &&
      other.label == label &&
      other.note == note &&
      other.createdAt == createdAt;

  @override
  int get hashCode => Object.hash(id, label, note, createdAt);
}

class TodoMemory {
  const TodoMemory({
    required this.id,
    required this.title,
    required this.createdAt,
    this.isCompleted = false,
  });

  final String id;
  final String title;
  final DateTime createdAt;
  final bool isCompleted;

  Map<String, Object?> toJson() => {
    'id': id,
    'title': title,
    'createdAt': createdAt.toIso8601String(),
    'isCompleted': isCompleted,
  };

  factory TodoMemory.fromJson(Map<String, Object?> json) {
    return TodoMemory(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      createdAt: _dateTime(json['createdAt']),
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is TodoMemory &&
      other.id == id &&
      other.title == title &&
      other.createdAt == createdAt &&
      other.isCompleted == isCompleted;

  @override
  int get hashCode => Object.hash(id, title, createdAt, isCompleted);
}

class LocalMemorySnapshot {
  const LocalMemorySnapshot({
    required this.consentSettings,
    required this.companionPreference,
    required this.profile,
    required this.dailyEntries,
    required this.memoryItems,
    required this.people,
    required this.todos,
    required this.recurringKeywords,
  });

  factory LocalMemorySnapshot.empty() {
    return LocalMemorySnapshot(
      consentSettings: ConsentSettings.disabled(),
      companionPreference: const CompanionPreference(),
      profile: const LocalUserProfile(),
      dailyEntries: const [],
      memoryItems: const [],
      people: const [],
      todos: const [],
      recurringKeywords: const {},
    );
  }

  final ConsentSettings consentSettings;
  final CompanionPreference companionPreference;
  final LocalUserProfile profile;
  final List<DailyReflectionEntry> dailyEntries;
  final List<MemoryItem> memoryItems;
  final List<PersonMemory> people;
  final List<TodoMemory> todos;
  final Map<String, int> recurringKeywords;

  LocalMemorySnapshot copyWith({
    ConsentSettings? consentSettings,
    CompanionPreference? companionPreference,
    LocalUserProfile? profile,
    List<DailyReflectionEntry>? dailyEntries,
    List<MemoryItem>? memoryItems,
    List<PersonMemory>? people,
    List<TodoMemory>? todos,
    Map<String, int>? recurringKeywords,
  }) {
    return LocalMemorySnapshot(
      consentSettings: consentSettings ?? this.consentSettings,
      companionPreference: companionPreference ?? this.companionPreference,
      profile: profile ?? this.profile,
      dailyEntries: dailyEntries ?? this.dailyEntries,
      memoryItems: memoryItems ?? this.memoryItems,
      people: people ?? this.people,
      todos: todos ?? this.todos,
      recurringKeywords: recurringKeywords ?? this.recurringKeywords,
    );
  }

  Map<String, Object?> toJson() => {
    'consentSettings': consentSettings.toJson(),
    'companionPreference': companionPreference.toJson(),
    'profile': profile.toJson(),
    'dailyEntries': dailyEntries.map((entry) => entry.toJson()).toList(),
    'memoryItems': memoryItems.map((item) => item.toJson()).toList(),
    'people': people.map((person) => person.toJson()).toList(),
    'todos': todos.map((todo) => todo.toJson()).toList(),
    'recurringKeywords': recurringKeywords,
  };

  factory LocalMemorySnapshot.fromJson(Map<String, Object?> json) {
    return LocalMemorySnapshot(
      consentSettings: ConsentSettings.fromJson(_map(json['consentSettings'])),
      companionPreference: CompanionPreference.fromJson(
        _map(json['companionPreference']),
      ),
      profile: LocalUserProfile.fromJson(_map(json['profile'])),
      dailyEntries: _objectList(
        json['dailyEntries'],
      ).map(DailyReflectionEntry.fromJson).toList(),
      memoryItems: _objectList(
        json['memoryItems'],
      ).map(MemoryItem.fromJson).toList(),
      people: _objectList(json['people']).map(PersonMemory.fromJson).toList(),
      todos: _objectList(json['todos']).map(TodoMemory.fromJson).toList(),
      recurringKeywords: _stringIntMap(json['recurringKeywords']),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is LocalMemorySnapshot &&
      other.consentSettings == consentSettings &&
      other.companionPreference == companionPreference &&
      other.profile == profile &&
      _listEquals(other.dailyEntries, dailyEntries) &&
      _listEquals(other.memoryItems, memoryItems) &&
      _listEquals(other.people, people) &&
      _listEquals(other.todos, todos) &&
      _mapEquals(other.recurringKeywords, recurringKeywords);

  @override
  int get hashCode => Object.hash(
    consentSettings,
    companionPreference,
    profile,
    Object.hashAll(dailyEntries),
    Object.hashAll(memoryItems),
    Object.hashAll(people),
    Object.hashAll(todos),
    Object.hashAll(
      recurringKeywords.entries
          .map((entry) => '${entry.key}:${entry.value}')
          .toList()
        ..sort(),
    ),
  );
}

DateTime _dateTime(Object? value) {
  if (value is String) {
    return DateTime.tryParse(value) ??
        DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);
  }
  return DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);
}

MemoryCategory _memoryCategory(Object? value) {
  final name = value as String?;
  for (final category in MemoryCategory.values) {
    if (category.name == name) {
      return category;
    }
  }
  return MemoryCategory.profile;
}

List<String> _stringList(Object? value) {
  if (value is List) {
    return value.whereType<String>().toList();
  }
  return const [];
}

Map<String, Object?> _map(Object? value) {
  if (value is Map) {
    return value.map((key, value) => MapEntry(key.toString(), value));
  }
  return const {};
}

List<Map<String, Object?>> _objectList(Object? value) {
  if (value is List) {
    return value.whereType<Map>().map((item) => _map(item)).toList();
  }
  return const [];
}

Map<String, int> _stringIntMap(Object? value) {
  if (value is Map) {
    return value.map((key, value) {
      final count = value is int ? value : int.tryParse(value.toString()) ?? 0;
      return MapEntry(key.toString(), count);
    });
  }
  return const {};
}

bool _listEquals<T>(List<T> left, List<T> right) {
  if (left.length != right.length) {
    return false;
  }
  for (var index = 0; index < left.length; index += 1) {
    if (left[index] != right[index]) {
      return false;
    }
  }
  return true;
}

bool _mapEquals<K, V>(Map<K, V> left, Map<K, V> right) {
  if (left.length != right.length) {
    return false;
  }
  for (final entry in left.entries) {
    if (right[entry.key] != entry.value) {
      return false;
    }
  }
  return true;
}
