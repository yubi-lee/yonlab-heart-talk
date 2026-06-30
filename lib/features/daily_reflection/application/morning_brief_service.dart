import '../domain/companion_models.dart';
import '../domain/local_insight_models.dart';
import '../domain/local_memory_models.dart';
import '../domain/morning_brief_models.dart';

class MorningBriefService {
  const MorningBriefService();

  MorningBrief generate({
    required LocalMemorySnapshot snapshot,
    required LocalInsightSummary insight,
    required CompanionPreference preference,
    required CompanionGrowthState growthState,
  }) {
    if (!snapshot.consentSettings.localMemoryEnabled) {
      return _fallback(preference);
    }

    final hasBasis =
        snapshot.dailyEntries.isNotEmpty ||
        snapshot.todos.isNotEmpty ||
        snapshot.people.isNotEmpty ||
        snapshot.recurringKeywords.isNotEmpty ||
        snapshot.profile.displayName.trim().isNotEmpty;

    if (!hasBasis) {
      return _fallback(preference);
    }

    final latestEntry = _latestEntry(snapshot);
    final activeTodo = _activeTodo(snapshot);

    return MorningBrief(
      title: '오늘 시작하기',
      greeting: _greeting(snapshot, preference, growthState),
      carryOverLine: _carryOverLine(latestEntry, insight),
      todayQuestion: _todayQuestion(latestEntry, insight, preference),
      firstStep: _firstStep(activeTodo, insight, preference),
      roleMessage: _roleMessage(preference, growthState.level),
      dataDepthLabel: insight.dataDepthLabel,
      isFallback: false,
      usesPersonalMemory: true,
      basisEntryCount: snapshot.dailyEntries.length,
      basisTodoCount: snapshot.todos.where((todo) => !todo.isCompleted).length,
    );
  }

  MorningBrief _fallback(CompanionPreference preference) {
    return MorningBrief(
      title: '오늘 시작하기',
      greeting: _fallbackGreeting(preference),
      carryOverLine: '어제의 기록이 아직 많지 않아서, 오늘은 가볍게 리듬을 만드는 쪽으로 시작해봐요.',
      todayQuestion: _fallbackQuestion(preference),
      firstStep: _fallbackFirstStep(preference),
      roleMessage: _fallbackRoleMessage(preference),
      dataDepthLabel: DataDepthLabel.gettingStarted,
      isFallback: true,
      usesPersonalMemory: false,
      basisEntryCount: 0,
      basisTodoCount: 0,
    );
  }

  DailyReflectionEntry? _latestEntry(LocalMemorySnapshot snapshot) {
    if (snapshot.dailyEntries.isEmpty) {
      return null;
    }
    final entries = [...snapshot.dailyEntries]
      ..sort((left, right) => right.createdAt.compareTo(left.createdAt));
    return entries.first;
  }

  TodoMemory? _activeTodo(LocalMemorySnapshot snapshot) {
    final todos = snapshot.todos.where((todo) => !todo.isCompleted).toList()
      ..sort((left, right) => left.createdAt.compareTo(right.createdAt));
    if (todos.isEmpty) {
      return null;
    }
    return todos.first;
  }

  String _greeting(
    LocalMemorySnapshot snapshot,
    CompanionPreference preference,
    CompanionGrowthState growthState,
  ) {
    final name = snapshot.profile.displayName.trim();
    final namePart = name.isEmpty ? '' : '$name님, ';
    final stageLine = switch (growthState.level) {
      0 || 1 => '오늘의 시작점은 작고 분명하게 잡아보죠.',
      2 || 3 => '어제 흐름을 오늘의 시작점으로 이어가볼 수 있어요.',
      _ => '쌓인 기억을 바탕으로 오늘 리듬을 조금 더 선명하게 잡아볼 수 있어요.',
    };

    switch (preference.defaultRole) {
      case CompanionRole.friend:
        return '좋은 아침이에요. $namePart$stageLine';
      case CompanionRole.lover:
        return '좋은 아침이에요. $namePart오늘도 너무 무리하지 말고, 가장 작은 시작부터 같이 가봐요.';
      case CompanionRole.family:
        return '좋은 아침이야. $namePart오늘은 익숙한 리듬부터 천천히 붙여보자.';
      case CompanionRole.parent:
        return '좋은 아침이야. $namePart몸과 마음을 조금 챙기고, 쉬운 일 하나부터 가볍게 시작해도 괜찮아.';
      case CompanionRole.coach:
        return '좋은 아침입니다. $namePart오늘의 시작점은 작고 분명하게 잡아보죠.';
      case CompanionRole.teacher:
        return '좋은 아침이에요. $namePart오늘은 순서를 가볍게 정리하고 시작해보죠.';
      case CompanionRole.listener:
        return '좋은 아침이에요. $namePart오늘 마음이 어디에 머무는지 조용히 살펴보며 시작해봐요.';
      case CompanionRole.custom:
        return '좋은 아침이에요. $namePart오늘은 ${preference.customToneDescriptor} 시작해볼게요.';
    }
  }

  String _carryOverLine(
    DailyReflectionEntry? latestEntry,
    LocalInsightSummary insight,
  ) {
    if (latestEntry != null) {
      final summary = latestEntry.summary.trim();
      final excerpt = summary.length > 42
          ? '${summary.substring(0, 42)}…'
          : summary;
      return '어제는 "$excerpt" 같은 흐름이 남아 있었어요.';
    }
    return insight.isFallback
        ? '아직 이어볼 기록이 많지 않아서, 오늘은 가벼운 리듬부터 만들어보면 좋아요.'
        : insight.patternBody;
  }

  MorningQuestion _todayQuestion(
    DailyReflectionEntry? latestEntry,
    LocalInsightSummary insight,
    CompanionPreference preference,
  ) {
    switch (preference.defaultRole) {
      case CompanionRole.coach:
        return const MorningQuestion(
          text: '오늘 어디서 가장 막힐 수 있을지 먼저 짚어볼까요?',
          source: MorningQuestionSource.localInsight,
        );
      case CompanionRole.listener:
        return const MorningQuestion(
          text: '오늘 마음이 가장 오래 머무는 지점은 어디일까요?',
          source: MorningQuestionSource.localInsight,
        );
      case CompanionRole.teacher:
        return const MorningQuestion(
          text: '오늘의 흐름을 한 문장으로 정리하면 무엇일까요?',
          source: MorningQuestionSource.localInsight,
        );
      case CompanionRole.custom:
        return MorningQuestion(
          text: preference.customToneStyle == CustomToneStyle.reflective
              ? '오늘 마음이 남긴 작은 힌트 하나는 무엇일까요?'
              : '오늘 가장 가볍게 시작할 수 있는 일은 무엇일까요?',
          source: MorningQuestionSource.localInsight,
        );
      case CompanionRole.parent:
        return const MorningQuestion(
          text: '오늘 몸과 마음을 조금 덜 무겁게 시작하려면 무엇이 좋을까요?',
          source: MorningQuestionSource.localInsight,
        );
      case CompanionRole.family:
        return const MorningQuestion(
          text: '오늘 부담이 적은 시작 하나는 무엇일까요?',
          source: MorningQuestionSource.localInsight,
        );
      case CompanionRole.lover:
        return const MorningQuestion(
          text: '오늘 너무 무리하지 않고 시작할 수 있는 일은 무엇일까요?',
          source: MorningQuestionSource.localInsight,
        );
      case CompanionRole.friend:
        if (!insight.isFallback) {
          return MorningQuestion(
            text: insight.curiosityQuestion.text,
            source: MorningQuestionSource.localInsight,
          );
        }
        if (latestEntry != null) {
          return const MorningQuestion(
            text: '어제 가볍게 남은 장면이 오늘의 시작에 어떤 힌트를 줄까요?',
            source: MorningQuestionSource.recentReflection,
          );
        }
        return const MorningQuestion(
          text: '오늘 가장 부담이 적은 시작은 무엇일까요?',
          source: MorningQuestionSource.fallback,
        );
    }
  }

  FirstStepSuggestion _firstStep(
    TodoMemory? activeTodo,
    LocalInsightSummary insight,
    CompanionPreference preference,
  ) {
    if (activeTodo != null) {
      switch (preference.defaultRole) {
        case CompanionRole.coach:
          return FirstStepSuggestion(
            title: '첫 번째 작은 행동',
            body: '"${activeTodo.title}"에서 가장 쉬운 한 단계만 바로 시작해보세요.',
            estimatedMinutes: 5,
          );
        case CompanionRole.listener:
          return FirstStepSuggestion(
            title: '첫 번째 작은 행동',
            body: '"${activeTodo.title}"를 떠올리며, 너무 서두르지 말고 천천히 손을 대보세요.',
            estimatedMinutes: 5,
          );
        case CompanionRole.teacher:
          return FirstStepSuggestion(
            title: '첫 번째 작은 행동',
            body: '"${activeTodo.title}"를 오늘의 1번 순서로 두고 차례대로 시작해보세요.',
            estimatedMinutes: 5,
          );
        case CompanionRole.parent:
          return FirstStepSuggestion(
            title: '첫 번째 작은 행동',
            body: '"${activeTodo.title}"처럼 가장 쉬운 일 하나부터 몸에 무리 없게 시작해보세요.',
            estimatedMinutes: 5,
          );
        case CompanionRole.family:
          return FirstStepSuggestion(
            title: '첫 번째 작은 행동',
            body: '"${activeTodo.title}"처럼 부담이 적은 일 하나부터 편하게 시작해보세요.',
            estimatedMinutes: 5,
          );
        case CompanionRole.lover:
          return FirstStepSuggestion(
            title: '첫 번째 작은 행동',
            body: '"${activeTodo.title}"처럼 가장 쉬운 일 하나부터 가볍게 시작해봐요.',
            estimatedMinutes: 5,
          );
        case CompanionRole.custom:
          return FirstStepSuggestion(
            title: '첫 번째 작은 행동',
            body:
                '"${activeTodo.title}"를 ${preference.customToneDescriptor} 시작해보세요.',
            estimatedMinutes: 5,
          );
        case CompanionRole.friend:
          return FirstStepSuggestion(
            title: '첫 번째 작은 행동',
            body: '"${activeTodo.title}"처럼 가장 쉬운 일 하나부터 가볍게 시작해보세요.',
            estimatedMinutes: 5,
          );
      }
    }

    return FirstStepSuggestion(
      title: insight.tinyMission.title,
      body: _missionToFirstStep(insight.tinyMission.body, preference),
      estimatedMinutes: insight.tinyMission.estimatedMinutes,
    );
  }

  String _missionToFirstStep(String body, CompanionPreference preference) {
    switch (preference.defaultRole) {
      case CompanionRole.listener:
        return '너무 서두르지 말고, $body';
      case CompanionRole.teacher:
        return '$body 순서만 가볍게 잡아도 좋아요.';
      case CompanionRole.custom:
        return '${preference.customToneDescriptor} $body';
      default:
        return '내일 첫 ${3}분은 $body';
    }
  }

  String _roleMessage(CompanionPreference preference, int level) {
    final levelLine = level <= 1 ? '아직 알아가는 중이지만' : '쌓인 흐름을 바탕으로';

    switch (preference.defaultRole) {
      case CompanionRole.friend:
        return '친구처럼 옆에서 볼게요. $levelLine 오늘은 가볍게 몸을 풀듯 작은 시작 하나만 해봐요.';
      case CompanionRole.lover:
        return '다정하게 응원할게요. $levelLine 오늘도 가장 작은 시작부터 같이 맞춰가봐요.';
      case CompanionRole.family:
        return '가족처럼 편안하게 볼게요. $levelLine 오늘은 생활 리듬부터 천천히 붙여봐요.';
      case CompanionRole.parent:
        return '생활을 챙기듯 볼게요. $levelLine 쉬운 일 하나부터 차분하게 시작해보세요.';
      case CompanionRole.coach:
        return '코치처럼 시작점을 분명하게 잡아볼게요. 지금 바로 할 수 있는 첫 행동 하나를 정하고 시작해봅시다.';
      case CompanionRole.teacher:
        return '선생님처럼 정리해볼게요. 먼저 순서를 잡고, 그 다음에 가장 쉬운 단계부터 붙이면 됩니다.';
      case CompanionRole.listener:
        return '경청자처럼 짧은 질문 하나를 곁들여 함께 있을게요. 오늘 마음이 가장 덜 무거운 시작 하나만 골라볼까요?';
      case CompanionRole.custom:
        return '${preference.roleDisplayName} 톤으로 ${preference.customToneDescriptor} 함께 볼게요. 오늘은 부담이 덜한 시작 하나만 골라도 충분해요.';
    }
  }

  String _fallbackGreeting(CompanionPreference preference) {
    switch (preference.defaultRole) {
      case CompanionRole.coach:
        return '좋은 아침입니다. 오늘의 시작점은 작고 분명하게 잡아보죠.';
      case CompanionRole.listener:
        return '좋은 아침이에요. 오늘 마음이 어디에 머무는지 조용히 살펴보며 시작해봐요.';
      case CompanionRole.teacher:
        return '좋은 아침이에요. 오늘은 순서를 가볍게 정리하고 시작해보죠.';
      case CompanionRole.lover:
        return '좋은 아침이에요. 오늘도 너무 무리하지 말고, 가장 작은 시작부터 같이 가봐요.';
      case CompanionRole.parent:
        return '좋은 아침이야. 몸과 마음을 조금 챙기고, 쉬운 일 하나부터 시작해도 괜찮아.';
      case CompanionRole.family:
        return '좋은 아침이야. 오늘은 익숙한 리듬부터 천천히 붙여보자.';
      case CompanionRole.custom:
        return '좋은 아침이에요. 오늘은 ${preference.customToneDescriptor} 시작해볼게요.';
      case CompanionRole.friend:
        return '좋은 아침이에요. 아직 알아가는 중이라서 오늘은 아주 작은 시작만 챙겨볼게요.';
    }
  }

  MorningQuestion _fallbackQuestion(CompanionPreference preference) {
    switch (preference.defaultRole) {
      case CompanionRole.coach:
        return const MorningQuestion(
          text: '오늘 가장 가볍게 실행할 수 있는 일은 무엇일까요?',
          source: MorningQuestionSource.fallback,
        );
      case CompanionRole.listener:
        return const MorningQuestion(
          text: '오늘 마음이 가장 편한 시작은 무엇일까요?',
          source: MorningQuestionSource.fallback,
        );
      case CompanionRole.teacher:
        return const MorningQuestion(
          text: '오늘의 시작을 한 문장으로 정리하면 무엇일까요?',
          source: MorningQuestionSource.fallback,
        );
      case CompanionRole.custom:
        return MorningQuestion(
          text: preference.customToneStyle == CustomToneStyle.reflective
              ? '오늘 마음이 남긴 작은 힌트 하나는 무엇일까요?'
              : '오늘 가장 부담이 적은 시작은 무엇일까요?',
          source: MorningQuestionSource.fallback,
        );
      case CompanionRole.parent:
        return const MorningQuestion(
          text: '오늘 몸과 마음이 덜 무거워질 시작은 무엇일까요?',
          source: MorningQuestionSource.fallback,
        );
      case CompanionRole.family:
        return const MorningQuestion(
          text: '오늘 부담이 적은 시작 하나는 무엇일까요?',
          source: MorningQuestionSource.fallback,
        );
      case CompanionRole.lover:
        return const MorningQuestion(
          text: '오늘 너무 무리하지 않고 시작할 수 있는 일은 무엇일까요?',
          source: MorningQuestionSource.fallback,
        );
      case CompanionRole.friend:
        return const MorningQuestion(
          text: '오늘 가장 부담이 적은 시작은 무엇일까요?',
          source: MorningQuestionSource.fallback,
        );
    }
  }

  FirstStepSuggestion _fallbackFirstStep(CompanionPreference preference) {
    switch (preference.defaultRole) {
      case CompanionRole.coach:
        return const FirstStepSuggestion(
          title: '첫 번째 작은 행동',
          body: '지금 바로 시작할 수 있는 일 하나만 정해보세요.',
          estimatedMinutes: 3,
        );
      case CompanionRole.listener:
        return const FirstStepSuggestion(
          title: '첫 번째 작은 행동',
          body: '물 한 잔 마시고, 지금 마음에 떠오른 장면 하나만 적어보세요.',
          estimatedMinutes: 3,
        );
      case CompanionRole.teacher:
        return const FirstStepSuggestion(
          title: '첫 번째 작은 행동',
          body: '오늘 할 일을 한 줄로 정리하고 1번 순서를 붙여보세요.',
          estimatedMinutes: 3,
        );
      case CompanionRole.custom:
        return FirstStepSuggestion(
          title: '첫 번째 작은 행동',
          body: '${preference.customToneDescriptor} 오늘의 시작 한 줄만 적어보세요.',
          estimatedMinutes: 3,
        );
      case CompanionRole.parent:
        return const FirstStepSuggestion(
          title: '첫 번째 작은 행동',
          body: '물 한 잔 마시고, 오늘 가장 쉬운 일 하나만 적어보세요.',
          estimatedMinutes: 3,
        );
      case CompanionRole.family:
        return const FirstStepSuggestion(
          title: '첫 번째 작은 행동',
          body: '오늘 가볍게 시작할 일 하나만 적어보세요.',
          estimatedMinutes: 3,
        );
      case CompanionRole.lover:
        return const FirstStepSuggestion(
          title: '첫 번째 작은 행동',
          body: '오늘 너무 무리하지 않는 시작 하나만 적어보세요.',
          estimatedMinutes: 3,
        );
      case CompanionRole.friend:
        return const FirstStepSuggestion(
          title: '첫 번째 작은 행동',
          body: '물 한 잔 마시고, 오늘 가장 쉬운 일 하나만 적어보세요.',
          estimatedMinutes: 3,
        );
    }
  }

  String _fallbackRoleMessage(CompanionPreference preference) {
    switch (preference.defaultRole) {
      case CompanionRole.coach:
        return '코치처럼 짚어볼게요. 오늘은 3분 안에 시작할 수 있는 일 하나면 충분합니다.';
      case CompanionRole.listener:
        return '경청자처럼 물어볼게요. 지금 가장 가볍게 시작할 수 있는 일은 무엇일까요?';
      case CompanionRole.lover:
        return '다정하게 응원할게요. 오늘은 너무 무리하지 말고 작은 시작 하나면 충분해요.';
      case CompanionRole.parent:
        return '생활을 먼저 챙기듯 볼게요. 몸을 조금 풀고 쉬운 일 하나부터 시작해보세요.';
      case CompanionRole.family:
        return '가족처럼 편안하게 볼게요. 오늘은 리듬을 붙이는 작은 시작 하나면 좋아요.';
      case CompanionRole.teacher:
        return '선생님처럼 정리해볼게요. 오늘은 가장 쉬운 순서 하나만 정해도 충분해요.';
      case CompanionRole.custom:
        return '${preference.roleDisplayName} 톤으로 ${preference.customToneDescriptor} 볼게요. 오늘은 부담 없는 시작 하나면 충분해요.';
      case CompanionRole.friend:
        return '친구처럼 옆에서 볼게요. 오늘은 가볍게 몸을 풀듯 작은 시작 하나만 해봐요.';
    }
  }
}
