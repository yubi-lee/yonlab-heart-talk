import '../domain/reflection_models.dart';

class RuleBasedReflectionEngine {
  static final forbiddenCopy = <String>[
    ['우울', '증'].join(),
    ['불안', '장애'].join(),
    ['치료가 ', '필요'].join(),
    ['위험', '합니다'].join(),
    ['진단', '합니다'].join(),
    ['의학적으로 ', '판단'].join(),
  ];

  ReflectionResult generate(ReflectionInput input) {
    final normalized = input.text.trim().replaceAll(RegExp(r'\s+'), ' ');
    if (normalized.isEmpty) {
      return const ReflectionResult(
        validationMessage: '오늘 남기고 싶은 말을 한 줄 이상 적어 주세요.',
      );
    }

    final tone = _detectTone(normalized);
    final carry = _detectCarryOver(normalized);
    final sourceLabel = input.source == ReflectionInputSource.demo
        ? '데모 데이터'
        : '직접 입력';
    final summary = ReflectionSummary(
      preview: '오늘은 $tone 하루처럼 보여요. $carry 여기까지만 정리해도 충분해요.',
      todayFlow: _todayFlowFor(normalized),
      observedCue: _observedCueFor(normalized),
      leftForTomorrow: carry,
      tomorrowLine: _tomorrowLineFor(normalized),
      sourceLabel: sourceLabel,
    );
    final morningDraft = MorningBriefingDraft(
      startLine: summary.tomorrowLine,
      firstThing: _firstThingFor(normalized),
      toneHint: '짧고 부드러운 말투로 시작해도 좋아요.',
    );

    return ReflectionResult(summary: summary, morningDraft: morningDraft);
  }

  String _detectTone(String text) {
    if (_containsAny(text, const ['고마', '감사', '도움', '덕분'])) {
      return '고마운 마음을 확인한';
    }
    if (_containsAny(text, const ['회의', '조율', '정리', '일정', '업무'])) {
      return '설명하고 맞추는 일이 많았던';
    }
    if (_containsAny(text, const ['가족', '집', '저녁', '부모', '아이'])) {
      return '가까운 사람들과 이야기를 나눈';
    }
    if (_containsAny(text, const ['내일', '해야', '할 일', '다시', '확인'])) {
      return '내일 볼 일을 남겨 둔';
    }
    if (_containsAny(text, const ['아직', '애매', '오해', '미뤄', '남아'])) {
      return '아직 정리 중인 장면을 알아차린';
    }
    return '작은 장면을 차분히 돌아본';
  }

  String _detectCarryOver(String text) {
    if (_containsAny(text, const ['내일', '해야', '할 일', '다시', '확인'])) {
      return '내일 다시 볼 일이 하나 남아 있어요.';
    }
    if (_containsAny(text, const ['아직', '애매', '오해', '미뤄', '남아'])) {
      return '덜 풀린 대화는 천천히 다시 확인해도 좋아요.';
    }
    if (_containsAny(text, const ['회의', '조율', '정리', '일정', '업무'])) {
      return '정리할 내용은 작은 목록 하나로 남겨두면 좋아요.';
    }
    return '오늘 기억하고 싶은 장면 하나만 남겨도 충분해요.';
  }

  String _todayFlowFor(String text) {
    if (_containsAny(text, const ['회의', '조율', '일정', '업무'])) {
      return '설명하고 맞추는 일이 중심이 된 하루처럼 보여요.';
    }
    if (_containsAny(text, const ['고마', '감사', '덕분'])) {
      return '고마움을 주고받은 장면이 남아 있는 하루예요.';
    }
    if (_containsAny(text, const ['가족', '집', '저녁'])) {
      return '가까운 사람과 나눈 일상 대화가 하루의 중심에 있었어요.';
    }
    return '짧은 기록 안에 돌아볼 만한 장면이 담겨 있어요.';
  }

  String _observedCueFor(String text) {
    if (_containsAny(text, const ['피곤', '지침', '늦게', '바빴'])) {
      return '조금 지친 표현이 보여요.';
    }
    if (_containsAny(text, const ['고마', '감사', '덕분'])) {
      return '고마움을 알아차린 표현이 보여요.';
    }
    if (_containsAny(text, const ['아직', '애매', '오해'])) {
      return '아직 정리 중인 마음이 남아 있는 것처럼 보여요.';
    }
    return '차분히 돌아보려는 표현이 보여요.';
  }

  String _tomorrowLineFor(String text) {
    if (_containsAny(text, const ['내일', '해야', '확인', '일정'])) {
      return '내일은 가장 작은 확인 하나부터 시작해 보세요.';
    }
    if (_containsAny(text, const ['고마', '감사', '덕분'])) {
      return '내일은 고마웠던 마음 하나를 짧게 전해도 좋아요.';
    }
    return '내일은 부담 없는 한 가지부터 시작해 보세요.';
  }

  String _firstThingFor(String text) {
    if (_containsAny(text, const ['내일', '해야', '확인', '일정'])) {
      return '남겨 둔 확인 사항 하나 보기';
    }
    if (_containsAny(text, const ['고마', '감사', '덕분'])) {
      return '고마웠던 장면 한 줄 남기기';
    }
    return '오늘 시작 전에 작은 할 일 하나 고르기';
  }

  bool _containsAny(String text, List<String> keywords) {
    return keywords.any(text.contains);
  }
}
