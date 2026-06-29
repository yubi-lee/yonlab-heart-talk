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
      todayQuestion: _todayQuestion(latestEntry, insight),
      firstStep: _firstStep(activeTodo, insight),
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
      greeting: '좋은 아침이에요. 아직 알아가는 중이라서 오늘은 아주 작은 시작만 챙겨볼게요.',
      carryOverLine: '어제의 기록이 아직 많지 않아서, 오늘은 가볍게 리듬을 만드는 쪽으로 시작해봐요.',
      todayQuestion: const MorningQuestion(
        text: '오늘 가장 부담이 적은 시작은 무엇일까요?',
        source: MorningQuestionSource.fallback,
      ),
      firstStep: const FirstStepSuggestion(
        title: '첫 번째 작은 행동',
        body: '물 한 잔 마시고, 오늘 가장 쉬운 일 하나만 적어보세요.',
        estimatedMinutes: 3,
      ),
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
      0 || 1 => '오늘도 무리 없이 시작해봐요.',
      2 || 3 => '어제 남긴 흐름을 오늘의 시작점으로 이어가볼 수 있어요.',
      _ => '쌓인 기억을 바탕으로 오늘의 리듬을 조금 더 또렷하게 잡아볼 수 있어요.',
    };

    switch (preference.defaultRole) {
      case CompanionRole.friend:
        return '좋은 아침이에요. ${namePart.isEmpty ? '' : namePart}$stageLine';
      case CompanionRole.lover:
        return '좋은 아침이에요. ${namePart.isEmpty ? '' : namePart}오늘도 너무 무리하지 말고, 작은 시작부터 같이 가봐요.';
      case CompanionRole.family:
        return '좋은 아침이야. ${namePart.isEmpty ? '' : namePart}오늘도 생활 리듬부터 천천히 챙겨보자.';
      case CompanionRole.parent:
        return '좋은 아침이야. ${namePart.isEmpty ? '' : namePart}몸과 마음을 먼저 가볍게 챙기고 시작해도 괜찮아.';
      case CompanionRole.coach:
        return '좋은 아침입니다. ${namePart.isEmpty ? '' : namePart}오늘의 시작점은 작고 분명하게 잡아보죠.';
      case CompanionRole.teacher:
        return '좋은 아침이에요. ${namePart.isEmpty ? '' : namePart}오늘은 순서를 가볍게 정리하고 시작해볼게요.';
      case CompanionRole.listener:
        return '좋은 아침이에요. ${namePart.isEmpty ? '' : namePart}오늘 마음이 어디에 머무는지 조용히 살펴보며 시작해봐요.';
      case CompanionRole.custom:
        return '좋은 아침이에요. ${namePart.isEmpty ? '' : namePart}오늘의 시작을 부담 없이 열어볼게요.';
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
        ? '아직 이어볼 기록이 많지 않아서, 오늘은 가장 작은 리듬부터 만들어보면 좋아요.'
        : insight.patternBody;
  }

  MorningQuestion _todayQuestion(
    DailyReflectionEntry? latestEntry,
    LocalInsightSummary insight,
  ) {
    if (!insight.isFallback) {
      return MorningQuestion(
        text: insight.curiosityQuestion.text,
        source: MorningQuestionSource.localInsight,
      );
    }
    if (latestEntry != null) {
      return const MorningQuestion(
        text: '어제 가장 오래 남은 장면이 오늘의 시작에 어떤 힌트를 주고 있을까요?',
        source: MorningQuestionSource.recentReflection,
      );
    }
    return const MorningQuestion(
      text: '오늘 가장 부담이 적은 시작은 무엇일까요?',
      source: MorningQuestionSource.fallback,
    );
  }

  FirstStepSuggestion _firstStep(
    TodoMemory? activeTodo,
    LocalInsightSummary insight,
  ) {
    if (activeTodo != null) {
      return FirstStepSuggestion(
        title: '첫 번째 작은 행동',
        body: '"${activeTodo.title}"처럼 가장 쉬운 일 하나부터 가볍게 시작해보세요.',
        estimatedMinutes: 5,
      );
    }
    return FirstStepSuggestion(
      title: insight.tinyMission.title,
      body:
          '내일 첫 ${insight.tinyMission.estimatedMinutes}분은 ${insight.tinyMission.body}',
      estimatedMinutes: insight.tinyMission.estimatedMinutes,
    );
  }

  String _roleMessage(CompanionPreference preference, int level) {
    final levelLine = level <= 1 ? '아직 알아가는 중이니' : '쌓인 흐름을 바탕으로';

    switch (preference.defaultRole) {
      case CompanionRole.friend:
        return '친구처럼 옆에서 볼게요. $levelLine 오늘은 너무 큰 계획보다 쉬운 시작 하나면 충분해요.';
      case CompanionRole.lover:
        return '다정하게 응원할게요. $levelLine 오늘도 가장 작은 시작부터 같이 맞춰가봐요.';
      case CompanionRole.family:
        return '가족처럼 생활 리듬을 먼저 챙겨볼게요. 오늘은 안정감 있게 한 걸음만 떼도 좋아요.';
      case CompanionRole.parent:
        return '생활을 챙기는 말투로 함께할게요. 오늘은 쉬운 일 하나부터 차분하게 시작해보자.';
      case CompanionRole.coach:
        return '코치처럼 시작점을 분명하게 잡아볼게요. 지금 바로 할 수 있는 첫 행동 하나를 정하고 시작해봅시다.';
      case CompanionRole.teacher:
        return '선생님처럼 순서를 정리해볼게요. 먼저 할 일 하나를 고르고, 그 다음을 붙이면 됩니다.';
      case CompanionRole.listener:
        return '경청자로서 짧은 질문을 남길게요. 오늘 마음이 가장 덜 무거워지는 시작은 무엇일까요?';
      case CompanionRole.custom:
        final roleName = preference.customRoleName.trim();
        final label = roleName.isEmpty ? '당신이 고른 말투' : roleName;
        return '$label에 맞춘 톤으로 함께할게요. 오늘은 부담 없는 첫 시작 하나만 챙겨보면 충분해요.';
    }
  }

  String _fallbackRoleMessage(CompanionPreference preference) {
    switch (preference.defaultRole) {
      case CompanionRole.coach:
        return '코치처럼 짧게 짚어볼게요. 오늘은 3분 안에 시작할 수 있는 일 하나면 충분합니다.';
      case CompanionRole.listener:
        return '경청자로서 질문 하나를 남길게요. 지금 가장 가볍게 시작할 수 있는 일은 무엇일까요?';
      case CompanionRole.lover:
        return '다정하게 응원할게요. 오늘도 너무 무리하지 말고 작은 시작부터 해봐요.';
      case CompanionRole.parent:
        return '생활을 먼저 챙기듯 말해볼게요. 몸을 조금 돌보고 쉬운 일 하나부터 시작해보자.';
      case CompanionRole.family:
        return '가족처럼 편안하게 말할게요. 오늘은 리듬을 가볍게 만드는 것부터 해보자.';
      case CompanionRole.teacher:
        return '선생님처럼 정리해볼게요. 오늘은 가장 쉬운 첫 순서 하나만 정해도 충분해요.';
      case CompanionRole.custom:
        return '고른 말투에 맞춰 함께할게요. 오늘은 부담 없는 첫 시작 하나만 챙겨봐요.';
      case CompanionRole.friend:
        return '친구처럼 옆에서 볼게요. 오늘은 가볍게 몸을 풀듯 작은 시작 하나만 해봐요.';
    }
  }
}
