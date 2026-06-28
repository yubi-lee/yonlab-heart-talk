enum RecurringSignalCategory { entryTag, recurringKeyword, todo, relationship }

enum DataDepthLabel {
  gettingStarted,
  learningPattern,
  enoughForPersonalizedHint,
}

class RecurringSignal {
  const RecurringSignal({
    required this.label,
    required this.count,
    required this.category,
  });

  final String label;
  final int count;
  final RecurringSignalCategory category;
}

class TomorrowHint {
  const TomorrowHint({required this.title, required this.body});

  final String title;
  final String body;
}

class CuriosityQuestion {
  const CuriosityQuestion({required this.text});

  final String text;
}

class TinyMission {
  const TinyMission({
    required this.title,
    required this.body,
    required this.estimatedMinutes,
  });

  final String title;
  final String body;
  final int estimatedMinutes;
}

class LocalInsightSummary {
  const LocalInsightSummary({
    required this.patternTitle,
    required this.patternBody,
    required this.recurringSignals,
    required this.tomorrowHint,
    required this.curiosityQuestion,
    required this.tinyMission,
    required this.roleMessage,
    required this.dataDepthLabel,
    required this.isFallback,
    required this.basisEntryCount,
  });

  final String patternTitle;
  final String patternBody;
  final List<RecurringSignal> recurringSignals;
  final TomorrowHint tomorrowHint;
  final CuriosityQuestion curiosityQuestion;
  final TinyMission tinyMission;
  final String roleMessage;
  final DataDepthLabel dataDepthLabel;
  final bool isFallback;
  final int basisEntryCount;
}
