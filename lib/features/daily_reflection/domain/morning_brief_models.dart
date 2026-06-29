import 'local_insight_models.dart';

enum MorningQuestionSource { fallback, recentReflection, localInsight }

class MorningQuestion {
  const MorningQuestion({required this.text, required this.source});

  final String text;
  final MorningQuestionSource source;
}

class FirstStepSuggestion {
  const FirstStepSuggestion({
    required this.title,
    required this.body,
    required this.estimatedMinutes,
  });

  final String title;
  final String body;
  final int estimatedMinutes;
}

class MorningBrief {
  const MorningBrief({
    required this.title,
    required this.greeting,
    required this.carryOverLine,
    required this.todayQuestion,
    required this.firstStep,
    required this.roleMessage,
    required this.dataDepthLabel,
    required this.isFallback,
    required this.usesPersonalMemory,
    required this.basisEntryCount,
    required this.basisTodoCount,
  });

  final String title;
  final String greeting;
  final String carryOverLine;
  final MorningQuestion todayQuestion;
  final FirstStepSuggestion firstStep;
  final String roleMessage;
  final DataDepthLabel dataDepthLabel;
  final bool isFallback;
  final bool usesPersonalMemory;
  final int basisEntryCount;
  final int basisTodoCount;
}
