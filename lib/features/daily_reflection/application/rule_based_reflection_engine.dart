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
        validationMessage:
            'Write at least one sentence to create a reflection.',
      );
    }

    final profile = _profileFor(normalized);
    final sourceLabel = input.source == ReflectionInputSource.demo
        ? 'Demo data'
        : 'Manual text';

    final summary = ReflectionSummary(
      preview:
          'Today ${profile.previewFocus}. You can close the day with one gentle note and leave the next step small.',
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
    ])) {
      return const _ReflectionProfile(
        previewFocus: 'held a clear moment of gratitude',
        todayFlow: 'A helpful moment gave the day a warmer ending.',
        observedCue: 'There is a note of appreciation in this reflection.',
        leftForTomorrow:
            'Carry forward the part that felt supportive, not the whole day.',
        tomorrowLine: 'Start tomorrow by naming one thing that helped today.',
        firstThing: 'Keep one useful note from today',
        toneHint: 'Begin with a calm and appreciative tone.',
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
    ])) {
      return const _ReflectionProfile(
        previewFocus: 'had a lot of coordination and follow-up energy',
        todayFlow: 'Coordination and decisions shaped the flow of the day.',
        observedCue:
            'The note suggests organization mattered more than urgency.',
        leftForTomorrow:
            'One follow-up can be enough to restart the thread tomorrow.',
        tomorrowLine: 'Start tomorrow with the smallest useful check-in.',
        firstThing: 'Review one follow-up item',
        toneHint: 'Keep the first step practical and light.',
      );
    }

    if (_containsAny(lower, const [
      'family',
      'conversation',
      'talk',
      'gentle',
      'evening',
    ])) {
      return const _ReflectionProfile(
        previewFocus: 'included a relationship moment worth noticing',
        todayFlow: 'A conversation gave the day a more personal shape.',
        observedCue: 'There is a gentle connection cue in what you wrote.',
        leftForTomorrow:
            'Leave room to return to the conversation only if it still matters.',
        tomorrowLine: 'Start tomorrow by keeping the tone simple and kind.',
        firstThing: 'Choose one kind phrase or small check-in',
        toneHint: 'Use a simple and warm tone.',
      );
    }

    if (_containsAny(lower, const [
      'tomorrow',
      'task',
      'unfinished',
      'need',
      'follow-up',
      'next',
    ])) {
      return const _ReflectionProfile(
        previewFocus: 'left one clear next step for tomorrow',
        todayFlow: 'The day ended with something still open but manageable.',
        observedCue: 'The note points to organization rather than pressure.',
        leftForTomorrow: 'One small next action is enough to hold the thread.',
        tomorrowLine: 'Start tomorrow with one small visible task.',
        firstThing: 'Pick the smallest next action',
        toneHint: 'Keep the morning plan narrow and doable.',
      );
    }

    return const _ReflectionProfile(
      previewFocus: 'has one moment worth gently organizing',
      todayFlow: 'A small part of the day is ready to be named and closed.',
      observedCue: 'The note shows a wish to pause without judging the day.',
      leftForTomorrow: 'Only carry forward what still feels useful tomorrow.',
      tomorrowLine: 'Start tomorrow with one clear and kind step.',
      firstThing: 'Name one small starting point',
      toneHint: 'Begin gently and keep the scope small.',
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
