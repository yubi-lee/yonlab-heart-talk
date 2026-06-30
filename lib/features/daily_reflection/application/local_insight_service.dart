import '../domain/companion_models.dart';
import '../domain/local_insight_models.dart';
import '../domain/local_memory_models.dart';

class LocalInsightService {
  const LocalInsightService();

  static const Map<String, String> _signalLabelMap = {
    'work': '일',
    'coordination': '정리',
    'fatigue': '피곤함',
    'delay': '미룸',
    'family': '가족',
    'conversation': '대화',
    'gratitude': '고마움',
    'tomorrow': '내일',
    'task': '할 일',
    'unresolved': '마음에 남음',
    'progress': '진전',
    'slow-start': '느린 시작',
    'todo': '할 일',
  };

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
      tomorrowHint: _tomorrowHint(snapshot, primarySignal, preference),
      curiosityQuestion: _curiosityQuestion(
        snapshot,
        primarySignal,
        preference,
      ),
      tinyMission: _tinyMission(snapshot, preference),
      roleMessage: _roleMessage(preference, dataDepthLabel),
      dataDepthLabel: dataDepthLabel,
      isFallback: false,
      basisEntryCount: snapshot.dailyEntries.length,
    );
  }

  LocalInsightSummary _fallback(CompanionPreference preference) {
    return LocalInsightSummary(
      patternTitle: '오늘의 인사이트',
      patternBody: '아직 알아가는 중이에요. 오늘의 한 줄만 있어도 다음 흐름을 천천히 찾아볼게요.',
      recurringSignals: const [],
      tomorrowHint: const TomorrowHint(
        title: '내일의 실마리',
        body: '내일은 작은 기록 하나만 남겨도 충분해요. 흐름을 천천히 알아가볼게요.',
      ),
      curiosityQuestion: _fallbackQuestion(preference),
      tinyMission: _fallbackMission(preference),
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
        if (label == null) {
          continue;
        }
        addSignal(label, 1, RecurringSignalCategory.entryTag);
      }
    }

    for (final entry in snapshot.recurringKeywords.entries) {
      final label = _cleanLabel(entry.key);
      if (label == null) {
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
    if (trimmed.isEmpty || trimmed == 'demo') {
      return null;
    }
    final lower = trimmed.toLowerCase();
    return _signalLabelMap[lower] ?? trimmed;
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
      return '오늘은 아직 선명한 반복 신호보다 작은 기록이 먼저 보였어요.';
    }
    if (secondary == null) {
      return "최근 기록에서 '${primary.label}' 흐름이 조금 더 자주 보였어요.";
    }
    return "최근 기록에서 '${primary.label}'과 '${secondary.label}'이 함께 자주 보였어요.";
  }

  TomorrowHint _tomorrowHint(
    LocalMemorySnapshot snapshot,
    RecurringSignal? primary,
    CompanionPreference preference,
  ) {
    if (snapshot.todos.any((todo) => !todo.isCompleted)) {
      switch (preference.defaultRole) {
        case CompanionRole.coach:
          return const TomorrowHint(
            title: '내일의 실마리',
            body: '내일은 가장 쉬운 할 일 하나를 바로 시작하는 쪽이 흐름을 살리기 좋아요.',
          );
        case CompanionRole.teacher:
          return const TomorrowHint(
            title: '내일의 실마리',
            body: '내일은 할 일의 순서를 먼저 세우고, 가장 쉬운 항목부터 차례대로 시작해보세요.',
          );
        case CompanionRole.listener:
          return const TomorrowHint(
            title: '내일의 실마리',
            body: '내일은 가장 마음이 덜 무거운 일 하나를 골라 조용히 시작해봐도 괜찮아요.',
          );
        case CompanionRole.parent:
          return const TomorrowHint(
            title: '내일의 실마리',
            body: '내일은 몸을 조금 챙기고, 가장 쉬운 할 일 하나부터 가볍게 시작해보세요.',
          );
        case CompanionRole.family:
          return const TomorrowHint(
            title: '내일의 실마리',
            body: '내일은 부담이 적은 일 하나부터 시작하면 생활 리듬을 붙이기 쉬워요.',
          );
        case CompanionRole.lover:
          return const TomorrowHint(
            title: '내일의 실마리',
            body: '내일은 너무 큰 계획보다 가장 작은 시작 하나를 정해두는 쪽이 편안할 수 있어요.',
          );
        case CompanionRole.custom:
          return TomorrowHint(
            title: '내일의 실마리',
            body:
                '내일은 ${preference.customToneDescriptor} 가장 쉬운 할 일 하나부터 시작해보세요.',
          );
        case CompanionRole.friend:
          return const TomorrowHint(
            title: '내일의 실마리',
            body: '내일은 큰 계획보다 가장 쉬운 일 하나부터 시작해도 충분해요.',
          );
      }
    }

    if (primary != null) {
      return TomorrowHint(
        title: '내일의 실마리',
        body: "'${primary.label}' 흐름이 다시 올 가능성이 있어요. 시작은 조금 더 가볍게 잡아볼게요.",
      );
    }

    return const TomorrowHint(
      title: '내일의 실마리',
      body: '내일은 오늘보다 한 문장 더 가볍게 시작해도 괜찮아요.',
    );
  }

  CuriosityQuestion _curiosityQuestion(
    LocalMemorySnapshot snapshot,
    RecurringSignal? primary,
    CompanionPreference preference,
  ) {
    switch (preference.defaultRole) {
      case CompanionRole.coach:
        return const CuriosityQuestion(text: '내일 가장 막히기 쉬운 지점은 어디일까요?');
      case CompanionRole.listener:
        if (snapshot.people.isNotEmpty) {
          return const CuriosityQuestion(text: '그 관계에서 마음이 오래 머문 이유는 무엇일까요?');
        }
        return const CuriosityQuestion(text: '오늘 어떤 장면이 가장 오래 마음에 남았을까요?');
      case CompanionRole.teacher:
        return const CuriosityQuestion(text: '오늘의 흐름을 한 문장으로 정리하면 무엇이 핵심일까요?');
      case CompanionRole.parent:
        return const CuriosityQuestion(text: '오늘 몸과 마음이 같이 무거워진 순간은 언제였을까요?');
      case CompanionRole.family:
        return const CuriosityQuestion(
          text: '오늘 마음이 머문 장면 하나를 편하게 떠올리면 무엇일까요?',
        );
      case CompanionRole.lover:
        return const CuriosityQuestion(text: '오늘 마음에 오래 남은 장면 하나를 천천히 떠올려볼까요?');
      case CompanionRole.custom:
        return CuriosityQuestion(
          text: preference.customToneStyle == CustomToneStyle.reflective
              ? '오늘 마음이 남긴 작은 신호 하나는 무엇이었을까요?'
              : '오늘 다시 꺼내보고 싶은 장면 하나는 무엇일까요?',
        );
      case CompanionRole.friend:
        if (primary != null) {
          return CuriosityQuestion(
            text: "'${primary.label}'이 오늘 계속 따라온 이유는 무엇일까요?",
          );
        }
        return const CuriosityQuestion(text: '오늘 계속 떠오르는 장면은 무엇이었을까요?');
    }
  }

  TinyMission _tinyMission(
    LocalMemorySnapshot snapshot,
    CompanionPreference preference,
  ) {
    switch (preference.defaultRole) {
      case CompanionRole.coach:
        return const TinyMission(
          title: '작은 미션',
          body: '내일 첫 3분은 가장 쉬운 일 하나를 바로 시작해보세요.',
          estimatedMinutes: 3,
        );
      case CompanionRole.listener:
        return const TinyMission(
          title: '작은 미션',
          body: '오늘 마음에 남은 한 장면을 한 줄로만 적어보세요.',
          estimatedMinutes: 3,
        );
      case CompanionRole.teacher:
        return const TinyMission(
          title: '작은 미션',
          body: '내일 할 일을 1, 2, 3 순서로 한 줄씩 정리해보세요.',
          estimatedMinutes: 3,
        );
      case CompanionRole.parent:
        return const TinyMission(
          title: '작은 미션',
          body: '물 한 잔 마시고, 가장 쉬운 일 하나만 적어두세요.',
          estimatedMinutes: 3,
        );
      case CompanionRole.family:
        return const TinyMission(
          title: '작은 미션',
          body: '내일 시작할 일을 한 줄 적고 쉬어도 괜찮아요.',
          estimatedMinutes: 3,
        );
      case CompanionRole.lover:
        return const TinyMission(
          title: '작은 미션',
          body: '너무 무리하지 말고, 가장 작은 시작 하나만 적어보세요.',
          estimatedMinutes: 3,
        );
      case CompanionRole.custom:
        return TinyMission(
          title: '작은 미션',
          body: '${preference.customToneDescriptor} 내일 가장 쉬운 시작 하나만 적어보세요.',
          estimatedMinutes: 3,
        );
      case CompanionRole.friend:
        return snapshot.todos.any((todo) => !todo.isCompleted)
            ? const TinyMission(
                title: '작은 미션',
                body: '내일 첫 3분은 가장 쉬운 일 하나만 가볍게 정리해보세요.',
                estimatedMinutes: 3,
              )
            : const TinyMission(
                title: '작은 미션',
                body: '자기 전, 내일 가장 쉬운 시작 하나만 적어보세요.',
                estimatedMinutes: 3,
              );
    }
  }

  CuriosityQuestion _fallbackQuestion(CompanionPreference preference) {
    switch (preference.defaultRole) {
      case CompanionRole.coach:
        return const CuriosityQuestion(text: '내일 가장 가볍게 시작할 수 있는 일은 무엇일까요?');
      case CompanionRole.listener:
        return const CuriosityQuestion(text: '오늘 마음이 조금 가벼워질 시작은 무엇일까요?');
      case CompanionRole.teacher:
        return const CuriosityQuestion(text: '오늘의 시작을 한 문장으로 정리하면 무엇이 좋을까요?');
      case CompanionRole.parent:
        return const CuriosityQuestion(
          text: '오늘 몸과 마음을 조금 덜 무겁게 만드는 시작은 무엇일까요?',
        );
      case CompanionRole.family:
        return const CuriosityQuestion(text: '오늘 부담이 적은 시작 하나는 무엇일까요?');
      case CompanionRole.lover:
        return const CuriosityQuestion(
          text: '오늘 너무 무리하지 않고 시작할 수 있는 일은 무엇일까요?',
        );
      case CompanionRole.custom:
        return CuriosityQuestion(
          text: preference.customToneStyle == CustomToneStyle.reflective
              ? '오늘 마음이 남긴 작은 힌트 하나는 무엇일까요?'
              : '오늘 가장 부담이 적은 시작은 무엇일까요?',
        );
      case CompanionRole.friend:
        return const CuriosityQuestion(text: '오늘 가장 부담이 적은 시작은 무엇일까요?');
    }
  }

  TinyMission _fallbackMission(CompanionPreference preference) {
    switch (preference.defaultRole) {
      case CompanionRole.coach:
        return const TinyMission(
          title: '작은 미션',
          body: '지금 바로 시작할 수 있는 일 하나를 적어보세요.',
          estimatedMinutes: 3,
        );
      case CompanionRole.listener:
        return const TinyMission(
          title: '작은 미션',
          body: '지금 마음에 떠오른 장면 하나만 한 줄로 적어보세요.',
          estimatedMinutes: 3,
        );
      case CompanionRole.teacher:
        return const TinyMission(
          title: '작은 미션',
          body: '오늘 할 일을 한 줄로 정리해보세요.',
          estimatedMinutes: 3,
        );
      case CompanionRole.custom:
        return TinyMission(
          title: '작은 미션',
          body: '${preference.customToneDescriptor} 오늘의 시작 한 줄만 적어보세요.',
          estimatedMinutes: 3,
        );
      case CompanionRole.parent:
        return const TinyMission(
          title: '작은 미션',
          body: '물 한 잔 마시고, 오늘 가장 쉬운 일 하나만 적어보세요.',
          estimatedMinutes: 3,
        );
      case CompanionRole.family:
        return const TinyMission(
          title: '작은 미션',
          body: '오늘 가볍게 시작할 일 하나만 적어보세요.',
          estimatedMinutes: 3,
        );
      case CompanionRole.lover:
        return const TinyMission(
          title: '작은 미션',
          body: '오늘 너무 무리하지 않는 시작 하나만 적어보세요.',
          estimatedMinutes: 3,
        );
      case CompanionRole.friend:
        return const TinyMission(
          title: '작은 미션',
          body: '자기 전, 오늘 떠오른 한 줄만 적어보세요.',
          estimatedMinutes: 3,
        );
    }
  }

  String _roleMessage(CompanionPreference preference, DataDepthLabel depth) {
    final depthLine = switch (depth) {
      DataDepthLabel.gettingStarted => '아직은 작은 단서부터 같이 볼게요.',
      DataDepthLabel.learningPattern => '조금씩 보이는 반복 흐름을 같이 짚어볼게요.',
      DataDepthLabel.enoughForPersonalizedHint =>
        '쌓인 기록을 바탕으로 조금 더 맞는 힌트를 건네볼게요.',
    };

    final roleLine = switch (preference.defaultRole) {
      CompanionRole.friend => '친구처럼 편하게 공감하며 볼게요.',
      CompanionRole.lover => '다정하게 응원하되 기대게 만들지 않는 쪽으로 볼게요.',
      CompanionRole.family => '가족처럼 익숙하고 안정된 말투로 볼게요.',
      CompanionRole.parent => '생활 리듬을 챙기듯 차분한 말투로 볼게요.',
      CompanionRole.coach => '코치처럼 실행 가능한 첫 행동부터 잡아볼게요.',
      CompanionRole.teacher => '선생님처럼 흐름을 정리하고 핵심을 분명히 볼게요.',
      CompanionRole.listener => '경청자처럼 짧게 반응하고 질문으로 함께 볼게요.',
      CompanionRole.custom =>
        '${preference.roleDisplayName} 톤에 맞춰 ${preference.customToneDescriptor} 짚어볼게요.',
    };

    return '$roleLine $depthLine';
  }
}
