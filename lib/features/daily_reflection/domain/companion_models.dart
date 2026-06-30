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

enum CustomToneStyle { balanced, calm, warm, direct, reflective }

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

extension CompanionPreferencePresentation on CompanionPreference {
  String get roleDisplayName {
    if (defaultRole == CompanionRole.custom &&
        customRoleName.trim().isNotEmpty) {
      return customRoleName.trim();
    }
    return defaultRole.koreanLabel;
  }

  CustomToneStyle get customToneStyle {
    final hint = customToneHint.trim();
    if (hint.isEmpty) {
      return CustomToneStyle.balanced;
    }
    if (hint.contains('차분') || hint.contains('조용')) {
      return CustomToneStyle.calm;
    }
    if (hint.contains('다정') || hint.contains('부드')) {
      return CustomToneStyle.warm;
    }
    if (hint.contains('짧') ||
        hint.contains('간결') ||
        hint.contains('직설') ||
        hint.contains('구체') ||
        hint.contains('분명')) {
      return CustomToneStyle.direct;
    }
    if (hint.contains('질문') || hint.contains('들어') || hint.contains('경청')) {
      return CustomToneStyle.reflective;
    }
    return CustomToneStyle.balanced;
  }

  String get customToneDescriptor {
    switch (customToneStyle) {
      case CustomToneStyle.calm:
        return '차분하게';
      case CustomToneStyle.warm:
        return '다정하게';
      case CustomToneStyle.direct:
        return '짧고 분명하게';
      case CustomToneStyle.reflective:
        return '질문을 곁들여';
      case CustomToneStyle.balanced:
        return '부드럽고 간결하게';
    }
  }

  String get roleContextLine {
    switch (defaultRole) {
      case CompanionRole.friend:
        return '지금은 친구처럼 도와드릴게요.';
      case CompanionRole.lover:
        return '지금은 연인처럼 다정하게 도와드릴게요.';
      case CompanionRole.family:
        return '지금은 가족처럼 편안하게 도와드릴게요.';
      case CompanionRole.parent:
        return '지금은 부모처럼 생활을 챙기듯 도와드릴게요.';
      case CompanionRole.coach:
        return '지금은 코치처럼 도와드릴게요.';
      case CompanionRole.teacher:
        return '지금은 선생님처럼 정리해드릴게요.';
      case CompanionRole.listener:
        return '지금은 경청자처럼 들어드릴게요.';
      case CompanionRole.custom:
        return customRoleName.trim().isEmpty
            ? '지금은 사용자 지정 톤으로 도와드릴게요.'
            : '지금은 ${customRoleName.trim()} 톤으로 도와드릴게요.';
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
