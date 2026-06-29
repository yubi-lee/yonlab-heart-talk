import '../domain/reflection_models.dart';

class RuleBasedReflectionEngine {
  static const forbiddenCopy = <String>[
    'depressed',
    'anxious',
    'at risk',
    'need treatment',
    'mental-health problem',
    'health condition is poor',
    'stress level is high',
    'medical problem',
    'predicts your illness',
    'safety risk',
  ];

  ReflectionResult generate(ReflectionInput input) {
    final normalized = input.text.trim().replaceAll(RegExp(r'\s+'), ' ');
    if (normalized.isEmpty) {
      return const ReflectionResult(
        validationMessage: '회고를 만들려면 한 문장 이상 적어주세요.',
      );
    }

    final profile = _profileFor(normalized);
    final sourceLabel = input.source == ReflectionInputSource.demo
        ? '데모 예시'
        : '직접 입력';

    final summary = ReflectionSummary(
      preview:
          '오늘은 ${profile.previewFocus} 하루였어요. 다정하게 마무리하고 내일의 첫 걸음만 작게 남겨볼 수 있어요.',
      todayFlow: profile.todayFlow,
      observedCue: profile.observedCue,
      leftForTomorrow: profile.leftForTomorrow,
      tomorrowLine: profile.tomorrowLine,
      sourceLabel: sourceLabel,
    );
    final morningDraft = MorningBriefingDraft(
      startLine: profile.tomorrowLine,
      firstThing: profile.firstThing,
      toneHint: profile.toneHint,
    );

    return ReflectionResult(summary: summary, morningDraft: morningDraft);
  }

  _ReflectionProfile _profileFor(String text) {
    final lower = text.toLowerCase();

    if (_containsAny(lower, const [
      'thank',
      'grateful',
      'gratitude',
      'helped',
      'appreciate',
      '고마',
      '감사',
      '도움',
    ])) {
      return const _ReflectionProfile(
        previewFocus: '고마움이 또렷하게 남은',
        todayFlow: '도움이 되었던 순간이 하루를 조금 더 따뜻하게 마무리해 줬어요.',
        observedCue: '적어둔 문장 사이에 고마움을 오래 붙잡고 싶은 마음이 보여요.',
        leftForTomorrow: '하루 전체보다 힘이 되었던 한 장면만 내일로 가져가도 충분해요.',
        tomorrowLine: '내일은 오늘 도움이 되었던 한 가지를 먼저 떠올려보세요.',
        firstThing: '도움이 되었던 한 장면 다시 적어보기',
        toneHint: '차분하고 고마운 톤으로 시작해 보세요.',
      );
    }

    if (_containsAny(lower, const [
      'meeting',
      'schedule',
      'coordinate',
      'coordination',
      'project',
      'work',
      'review',
      '회의',
      '일정',
      '정리',
      '프로젝트',
      '검토',
      '업무',
      '문서',
    ])) {
      return const _ReflectionProfile(
        previewFocus: '정리와 확인이 많이 필요했던',
        todayFlow: '정리와 결정이 오늘의 흐름을 만들었고, 남은 일도 아주 크지는 않아 보여요.',
        observedCue: '급하게 몰아치기보다 차근차근 확인하는 감각이 더 중요했던 하루예요.',
        leftForTomorrow: '내일까지 이어질 일은 하나만 이어 붙여도 흐름이 다시 살아나요.',
        tomorrowLine: '내일은 가장 작은 확인 한 가지로 시작해 보세요.',
        firstThing: '확인이 필요한 항목 하나만 먼저 보기',
        toneHint: '실행 가능한 첫 걸음 하나에만 집중해 보세요.',
      );
    }

    if (_containsAny(lower, const [
      'family',
      'conversation',
      'talk',
      'gentle',
      'evening',
      '가족',
      '대화',
      '이야기',
      '저녁',
      '차분',
    ])) {
      return const _ReflectionProfile(
        previewFocus: '관계의 온도가 남아 있는',
        todayFlow: '누군가와 나눈 말이 오늘 하루를 조금 더 사람답게 붙잡아 줬어요.',
        observedCue: '적어둔 문장 안에 관계를 다시 떠올리고 싶은 부드러운 신호가 있어요.',
        leftForTomorrow: '정말 마음에 남는 대화라면 내일 한 번 더 천천히 돌아봐도 괜찮아요.',
        tomorrowLine: '내일은 말투를 단순하고 다정하게 가져가 보세요.',
        firstThing: '짧게 안부를 건넬 한 문장 떠올리기',
        toneHint: '부드럽고 편안한 톤을 유지해 보세요.',
      );
    }

    if (_containsAny(lower, const [
      'tomorrow',
      'task',
      'unfinished',
      'need',
      'follow-up',
      'next',
      '내일',
      '할 일',
      '남아',
      '다음',
      '확인',
      '미뤄',
    ])) {
      return const _ReflectionProfile(
        previewFocus: '내일의 실마리가 또렷한',
        todayFlow: '끝나지 않은 일이 있지만, 어디서 다시 시작할지는 이미 보이고 있어요.',
        observedCue: '압박보다 정리 욕구가 더 크게 남아 있는 메모예요.',
        leftForTomorrow: '내일의 실마리는 큰 계획보다 아주 작은 시작점 하나면 충분해요.',
        tomorrowLine: '내일은 눈에 보이는 가장 작은 일 하나로 시작해 보세요.',
        firstThing: '가장 쉬운 다음 행동 하나 정하기',
        toneHint: '범위를 줄이고 가볍게 시작해 보세요.',
      );
    }

    return const _ReflectionProfile(
      previewFocus: '천천히 이름 붙여볼 만한 장면이 남은',
      todayFlow: '오늘 하루에서 조용히 정리해 둘 만한 부분이 하나 보였어요.',
      observedCue: '하루를 평가하기보다 잠깐 멈춰 보고 싶은 마음이 읽혀요.',
      leftForTomorrow: '내일까지 가져갈 것은 꼭 필요한 한 조각이면 충분해요.',
      tomorrowLine: '내일은 스스로에게 무리가 없는 한 걸음으로 시작해 보세요.',
      firstThing: '가장 작은 시작점 하나 적어두기',
      toneHint: '조용하고 부담 없는 톤으로 시작해 보세요.',
    );
  }

  bool _containsAny(String text, List<String> keywords) {
    return keywords.any(text.contains);
  }
}

class _ReflectionProfile {
  const _ReflectionProfile({
    required this.previewFocus,
    required this.todayFlow,
    required this.observedCue,
    required this.leftForTomorrow,
    required this.tomorrowLine,
    required this.firstThing,
    required this.toneHint,
  });

  final String previewFocus;
  final String todayFlow;
  final String observedCue;
  final String leftForTomorrow;
  final String tomorrowLine;
  final String firstThing;
  final String toneHint;
}
