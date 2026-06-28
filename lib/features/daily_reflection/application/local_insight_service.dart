import '../domain/companion_models.dart';
import '../domain/local_insight_models.dart';
import '../domain/local_memory_models.dart';

class LocalInsightService {
  const LocalInsightService();

  LocalInsightSummary generate({
    required LocalMemorySnapshot snapshot,
    required CompanionPreference preference,
    required CompanionGrowthState growthState,
  }) {
    if (!snapshot.consentSettings.localMemoryEnabled) {
      return _fallback(preference);
    }

    final signals = _signals(snapshot);
    final hasInsightBasis =
        snapshot.dailyEntries.isNotEmpty ||
        signals.isNotEmpty ||
        snapshot.todos.isNotEmpty ||
        snapshot.people.isNotEmpty;

    if (!hasInsightBasis) {
      return _fallback(preference);
    }

    final dataDepthLabel = _dataDepthLabel(growthState, snapshot, signals);
    final primarySignal = signals.isEmpty ? null : signals.first;
    final secondarySignal = signals.length > 1 ? signals[1] : null;

    return LocalInsightSummary(
      patternTitle: '오늘의 인사이트',
      patternBody: _patternBody(primarySignal, secondarySignal),
      recurringSignals: signals,
      tomorrowHint: _tomorrowHint(snapshot, primarySignal),
      curiosityQuestion: _curiosityQuestion(snapshot, primarySignal),
      tinyMission: _tinyMission(snapshot),
      roleMessage: _roleMessage(preference, dataDepthLabel),
      dataDepthLabel: dataDepthLabel,
      isFallback: false,
      basisEntryCount: snapshot.dailyEntries.length,
    );
  }

  LocalInsightSummary _fallback(CompanionPreference preference) {
    return LocalInsightSummary(
      patternTitle: '오늘의 인사이트',
      patternBody: '아직 알아가는 중이에요. 오늘 남긴 한 줄부터 천천히 실마리를 찾아볼게요.',
      recurringSignals: const [],
      tomorrowHint: const TomorrowHint(
        title: '내일의 작은 힌트',
        body: '내일은 작은 기록 하나만 남겨도 충분해요. 흐름은 천천히 쌓아볼게요.',
      ),
      curiosityQuestion: const CuriosityQuestion(
        text: '오늘 마음에 가장 오래 남은 장면은 무엇이었나요?',
      ),
      tinyMission: const TinyMission(
        title: 'tiny mission',
        body: '자기 전 작은 기록 한 문장만 남겨보세요.',
        estimatedMinutes: 3,
      ),
      roleMessage: _roleMessage(preference, DataDepthLabel.gettingStarted),
      dataDepthLabel: DataDepthLabel.gettingStarted,
      isFallback: true,
      basisEntryCount: 0,
    );
  }

  List<RecurringSignal> _signals(LocalMemorySnapshot snapshot) {
    final counts = <String, int>{};
    final categories = <String, RecurringSignalCategory>{};

    void addSignal(String label, int count, RecurringSignalCategory category) {
      if (count <= 0) {
        return;
      }
      counts[label] = (counts[label] ?? 0) + count;
      categories[label] = _preferredCategory(categories[label], category);
    }

    for (final entry in snapshot.dailyEntries) {
      for (final tag in entry.tags) {
        final label = _cleanLabel(tag);
        if (label == null || label == 'demo') {
          continue;
        }
        addSignal(label, 1, RecurringSignalCategory.entryTag);
      }
    }

    for (final entry in snapshot.recurringKeywords.entries) {
      final label = _cleanLabel(entry.key);
      if (label == null || label == 'demo') {
        continue;
      }
      addSignal(label, entry.value, RecurringSignalCategory.recurringKeyword);
    }

    final activeTodoCount = snapshot.todos
        .where((todo) => !todo.isCompleted)
        .length;
    if (activeTodoCount > 0) {
      addSignal('할 일', activeTodoCount, RecurringSignalCategory.todo);
    }

    if (snapshot.people.isNotEmpty) {
      addSignal(
        '관계',
        snapshot.people.length,
        RecurringSignalCategory.relationship,
      );
    }

    final signals =
        counts.entries
            .map(
              (entry) => RecurringSignal(
                label: entry.key,
                count: entry.value,
                category:
                    categories[entry.key] ?? RecurringSignalCategory.entryTag,
              ),
            )
            .toList()
          ..sort((left, right) {
            final countCompare = right.count.compareTo(left.count);
            if (countCompare != 0) {
              return countCompare;
            }
            return left.label.compareTo(right.label);
          });

    return signals.take(3).toList(growable: false);
  }

  RecurringSignalCategory _preferredCategory(
    RecurringSignalCategory? current,
    RecurringSignalCategory candidate,
  ) {
    if (current == null ||
        candidate == RecurringSignalCategory.recurringKeyword) {
      return candidate;
    }
    return current;
  }

  String? _cleanLabel(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return null;
    }
    return trimmed;
  }

  DataDepthLabel _dataDepthLabel(
    CompanionGrowthState growthState,
    LocalMemorySnapshot snapshot,
    List<RecurringSignal> signals,
  ) {
    if (growthState.level >= 3 || growthState.memoryScore >= 4) {
      return DataDepthLabel.enoughForPersonalizedHint;
    }
    if (snapshot.dailyEntries.isNotEmpty || signals.isNotEmpty) {
      return DataDepthLabel.learningPattern;
    }
    return DataDepthLabel.gettingStarted;
  }

  String _patternBody(RecurringSignal? primary, RecurringSignal? secondary) {
    if (primary == null) {
      return '오늘은 아직 뚜렷한 반복 신호보다 작은 기록이 먼저 보여요.';
    }
    if (secondary == null) {
      return '최근 기록에서 \'${primary.label}\' 흐름이 조금씩 보여요.';
    }
    return '최근 기록에서 \'${primary.label}\'와 \'${secondary.label}\'이 함께 자주 보여요.';
  }

  TomorrowHint _tomorrowHint(
    LocalMemorySnapshot snapshot,
    RecurringSignal? primary,
  ) {
    if (snapshot.todos.any((todo) => !todo.isCompleted)) {
      return const TomorrowHint(
        title: '내일의 작은 힌트',
        body: '내일은 큰 계획보다 가장 작은 시작점을 먼저 정하는 게 도움이 될 수 있어요.',
      );
    }
    if (primary != null) {
      return TomorrowHint(
        title: '내일의 작은 힌트',
        body: '\'${primary.label}\' 흐름이 다시 나타날 가능성이 있어요. 시작은 조금 작게 잡아볼게요.',
      );
    }
    return const TomorrowHint(
      title: '내일의 작은 힌트',
      body: '내일은 오늘보다 한 문장 더 가볍게 시작해볼 수 있어요.',
    );
  }

  CuriosityQuestion _curiosityQuestion(
    LocalMemorySnapshot snapshot,
    RecurringSignal? primary,
  ) {
    if (snapshot.people.isNotEmpty) {
      return const CuriosityQuestion(text: '그 관계에서 마음에 남은 장면은 어떤 의미였을까요?');
    }
    if (primary != null) {
      return CuriosityQuestion(
        text: '\'${primary.label}\'이 아직 마음에 남아 있는 이유는 무엇일까요?',
      );
    }
    return const CuriosityQuestion(text: '오늘 계속 떠오르는 장면은 무엇이었나요?');
  }

  TinyMission _tinyMission(LocalMemorySnapshot snapshot) {
    if (snapshot.todos.any((todo) => !todo.isCompleted)) {
      return const TinyMission(
        title: 'tiny mission',
        body: '내일 첫 3분은 가장 쉬운 할 일 하나만 정리해보세요.',
        estimatedMinutes: 3,
      );
    }
    return const TinyMission(
      title: 'tiny mission',
      body: '자기 전 내일 가장 쉬운 시작점 하나만 적어두세요.',
      estimatedMinutes: 3,
    );
  }

  String _roleMessage(CompanionPreference preference, DataDepthLabel depth) {
    final depthLine = switch (depth) {
      DataDepthLabel.gettingStarted => '아직은 작은 단서부터 볼게요.',
      DataDepthLabel.learningPattern => '조금씩 반복되는 흐름을 같이 살펴볼게요.',
      DataDepthLabel.enoughForPersonalizedHint =>
        '쌓인 기록을 바탕으로 조금 더 개인적인 힌트를 건네볼게요.',
    };

    final roleLine = switch (preference.defaultRole) {
      CompanionRole.friend => '친구처럼 곁에서 편하게 짚어볼게요.',
      CompanionRole.lover => '다정하게 응원하되 부담 없이 살펴볼게요.',
      CompanionRole.family => '가족처럼 편안한 안정감을 먼저 챙겨볼게요.',
      CompanionRole.parent => '생활 리듬을 차분히 챙기는 말투로 볼게요.',
      CompanionRole.coach => '코치처럼 실행 가능한 첫 걸음을 작게 잡아볼게요.',
      CompanionRole.teacher => '선생님처럼 구조를 나누어 차분히 정리해볼게요.',
      CompanionRole.listener => '경청자처럼 짧은 질문으로 마음의 방향을 들어볼게요.',
      CompanionRole.custom => _customRoleLine(preference),
    };

    return '$roleLine $depthLine';
  }

  String _customRoleLine(CompanionPreference preference) {
    final name = preference.customRoleName.trim();
    if (name.isEmpty) {
      return '사용자 지정 톤에 맞춰 조심스럽게 살펴볼게요.';
    }
    return '$name 톤에 맞춰 조심스럽게 살펴볼게요.';
  }
}
