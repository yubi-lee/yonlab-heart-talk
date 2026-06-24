class DemoReflectionEvent {
  const DemoReflectionEvent({
    required this.id,
    required this.title,
    required this.scenario,
    required this.text,
    required this.tags,
  });

  final String id;
  final String title;
  final String scenario;
  final String text;
  final List<String> tags;
}

enum ReflectionInputSource { demo, manual }

class ReflectionInput {
  const ReflectionInput({
    required this.text,
    required this.source,
    this.demoEventId,
  });

  final String text;
  final ReflectionInputSource source;
  final String? demoEventId;
}

class ReflectionSummary {
  const ReflectionSummary({
    required this.preview,
    required this.todayFlow,
    required this.observedCue,
    required this.leftForTomorrow,
    required this.tomorrowLine,
    required this.sourceLabel,
  });

  final String preview;
  final String todayFlow;
  final String observedCue;
  final String leftForTomorrow;
  final String tomorrowLine;
  final String sourceLabel;
}

class MorningBriefingDraft {
  const MorningBriefingDraft({
    required this.startLine,
    required this.firstThing,
    required this.toneHint,
  });

  final String startLine;
  final String firstThing;
  final String toneHint;
}

class ReflectionResult {
  const ReflectionResult({
    this.summary,
    this.morningDraft,
    this.validationMessage,
  });

  final ReflectionSummary? summary;
  final MorningBriefingDraft? morningDraft;
  final String? validationMessage;

  bool get isValid => summary != null && morningDraft != null;
}
