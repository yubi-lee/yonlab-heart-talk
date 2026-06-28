enum CompanionRole {
  friend,
  lover,
  family,
  parent,
  coach,
  teacher,
  listener,
  custom,
}

enum CompanionResponseLength { short, medium, long }

enum MemoryCategory {
  profile,
  reflectionEntries,
  people,
  todos,
  recurringKeywords,
}

extension CompanionRoleLabel on CompanionRole {
  String get koreanLabel {
    switch (this) {
      case CompanionRole.friend:
        return '친구';
      case CompanionRole.lover:
        return '연인';
      case CompanionRole.family:
        return '가족';
      case CompanionRole.parent:
        return '부모';
      case CompanionRole.coach:
        return '코치';
      case CompanionRole.teacher:
        return '선생님';
      case CompanionRole.listener:
        return '경청자';
      case CompanionRole.custom:
        return '사용자 지정';
    }
  }
}

class CompanionPreference {
  const CompanionPreference({
    this.defaultRole = CompanionRole.friend,
    this.responseLength = CompanionResponseLength.medium,
    this.affectionLevel = 3,
    this.directnessLevel = 2,
    this.avoidPhrases = const [],
    this.customRoleName = '',
    this.customToneHint = '',
  });

  final CompanionRole defaultRole;
  final CompanionResponseLength responseLength;
  final int affectionLevel;
  final int directnessLevel;
  final List<String> avoidPhrases;
  final String customRoleName;
  final String customToneHint;

  CompanionPreference copyWith({
    CompanionRole? defaultRole,
    CompanionResponseLength? responseLength,
    int? affectionLevel,
    int? directnessLevel,
    List<String>? avoidPhrases,
    String? customRoleName,
    String? customToneHint,
  }) {
    return CompanionPreference(
      defaultRole: defaultRole ?? this.defaultRole,
      responseLength: responseLength ?? this.responseLength,
      affectionLevel: affectionLevel ?? this.affectionLevel,
      directnessLevel: directnessLevel ?? this.directnessLevel,
      avoidPhrases: avoidPhrases ?? this.avoidPhrases,
      customRoleName: customRoleName ?? this.customRoleName,
      customToneHint: customToneHint ?? this.customToneHint,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'defaultRole': defaultRole.name,
      'responseLength': responseLength.name,
      'affectionLevel': affectionLevel,
      'directnessLevel': directnessLevel,
      'avoidPhrases': avoidPhrases,
      'customRoleName': customRoleName,
      'customToneHint': customToneHint,
    };
  }

  factory CompanionPreference.fromJson(Map<String, Object?> json) {
    return CompanionPreference(
      defaultRole: _enumByName(
        CompanionRole.values,
        json['defaultRole'] as String?,
        CompanionRole.friend,
      ),
      responseLength: _enumByName(
        CompanionResponseLength.values,
        json['responseLength'] as String?,
        CompanionResponseLength.medium,
      ),
      affectionLevel: json['affectionLevel'] as int? ?? 3,
      directnessLevel: json['directnessLevel'] as int? ?? 2,
      avoidPhrases: _stringList(json['avoidPhrases']),
      customRoleName: json['customRoleName'] as String? ?? '',
      customToneHint: json['customToneHint'] as String? ?? '',
    );
  }

  @override
  bool operator ==(Object other) {
    return other is CompanionPreference &&
        other.defaultRole == defaultRole &&
        other.responseLength == responseLength &&
        other.affectionLevel == affectionLevel &&
        other.directnessLevel == directnessLevel &&
        _listEquals(other.avoidPhrases, avoidPhrases) &&
        other.customRoleName == customRoleName &&
        other.customToneHint == customToneHint;
  }

  @override
  int get hashCode => Object.hash(
    defaultRole,
    responseLength,
    affectionLevel,
    directnessLevel,
    Object.hashAll(avoidPhrases),
    customRoleName,
    customToneHint,
  );
}

class ConsentSettings {
  const ConsentSettings({
    required this.localMemoryEnabled,
    required this.enabledCategories,
  });

  factory ConsentSettings.disabled() {
    return const ConsentSettings(
      localMemoryEnabled: false,
      enabledCategories: {},
    );
  }

  factory ConsentSettings.allEnabled() {
    return const ConsentSettings(
      localMemoryEnabled: true,
      enabledCategories: {
        MemoryCategory.profile,
        MemoryCategory.reflectionEntries,
        MemoryCategory.people,
        MemoryCategory.todos,
        MemoryCategory.recurringKeywords,
      },
    );
  }

  final bool localMemoryEnabled;
  final Set<MemoryCategory> enabledCategories;

  bool canStore(MemoryCategory category) {
    return localMemoryEnabled && enabledCategories.contains(category);
  }

  ConsentSettings copyWith({
    bool? localMemoryEnabled,
    Set<MemoryCategory>? enabledCategories,
  }) {
    return ConsentSettings(
      localMemoryEnabled: localMemoryEnabled ?? this.localMemoryEnabled,
      enabledCategories: enabledCategories ?? this.enabledCategories,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'localMemoryEnabled': localMemoryEnabled,
      'enabledCategories': enabledCategories
          .map((category) => category.name)
          .toList(),
    };
  }

  factory ConsentSettings.fromJson(Map<String, Object?> json) {
    return ConsentSettings(
      localMemoryEnabled: json['localMemoryEnabled'] as bool? ?? false,
      enabledCategories: _stringList(json['enabledCategories'])
          .map((name) => _enumByName(MemoryCategory.values, name, null))
          .whereType<MemoryCategory>()
          .toSet(),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ConsentSettings &&
        other.localMemoryEnabled == localMemoryEnabled &&
        _setEquals(other.enabledCategories, enabledCategories);
  }

  @override
  int get hashCode => Object.hash(
    localMemoryEnabled,
    Object.hashAll(
      enabledCategories.map((category) => category.name).toList()..sort(),
    ),
  );
}

class CompanionGrowthState {
  const CompanionGrowthState({
    required this.level,
    required this.memoryScore,
    required this.daysWithEntries,
    required this.profileCompleteness,
    required this.recurringKeywordCount,
    required this.relationshipMemoryCount,
    required this.todoMemoryCount,
  });

  final int level;
  final int memoryScore;
  final int daysWithEntries;
  final int profileCompleteness;
  final int recurringKeywordCount;
  final int relationshipMemoryCount;
  final int todoMemoryCount;

  @override
  bool operator ==(Object other) {
    return other is CompanionGrowthState &&
        other.level == level &&
        other.memoryScore == memoryScore &&
        other.daysWithEntries == daysWithEntries &&
        other.profileCompleteness == profileCompleteness &&
        other.recurringKeywordCount == recurringKeywordCount &&
        other.relationshipMemoryCount == relationshipMemoryCount &&
        other.todoMemoryCount == todoMemoryCount;
  }

  @override
  int get hashCode => Object.hash(
    level,
    memoryScore,
    daysWithEntries,
    profileCompleteness,
    recurringKeywordCount,
    relationshipMemoryCount,
    todoMemoryCount,
  );
}

T _enumByName<T extends Enum>(List<T> values, String? name, T? fallback) {
  for (final value in values) {
    if (value.name == name) {
      return value;
    }
  }
  if (fallback != null) {
    return fallback;
  }
  throw ArgumentError.value(name, 'name', 'Unknown enum value');
}

List<String> _stringList(Object? value) {
  if (value is List) {
    return value.whereType<String>().toList();
  }
  return const [];
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

bool _setEquals<T>(Set<T> left, Set<T> right) {
  return left.length == right.length && left.containsAll(right);
}
