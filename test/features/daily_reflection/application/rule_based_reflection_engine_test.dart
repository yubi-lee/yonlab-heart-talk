import 'package:flutter_test/flutter_test.dart';
import 'package:heart_talk/features/daily_reflection/application/rule_based_reflection_engine.dart';
import 'package:heart_talk/features/daily_reflection/domain/reflection_models.dart';

void main() {
  group('RuleBasedReflectionEngine', () {
    final engine = RuleBasedReflectionEngine();

    test('returns validation message for empty input', () {
      final result = engine.generate(
        const ReflectionInput(
          text: '   ',
          source: ReflectionInputSource.manual,
        ),
      );

      expect(result.isValid, isFalse);
      expect(result.validationMessage, contains('Write at least one sentence'));
    });

    test('returns deterministic output for the same manual input', () {
      const input = ReflectionInput(
        text:
            'Today I coordinated a project meeting and wrote down one task for tomorrow.',
        source: ReflectionInputSource.manual,
      );

      final first = engine.generate(input);
      final second = engine.generate(input);

      expect(first.summary?.preview, second.summary?.preview);
      expect(first.summary?.todayFlow, second.summary?.todayFlow);
      expect(first.morningDraft?.firstThing, second.morningDraft?.firstThing);
      expect(first.summary?.sourceLabel, 'Manual text');
    });

    test('creates summary and morning briefing for demo input', () {
      final result = engine.generate(
        const ReflectionInput(
          text:
              'A teammate helped organize the notes, and the day ended with a grateful feeling.',
          source: ReflectionInputSource.demo,
          demoEventId: 'gratitude_note',
        ),
      );

      expect(result.isValid, isTrue);
      expect(result.summary?.sourceLabel, 'Demo data');
      expect(result.summary?.preview, contains('Today'));
      expect(result.summary?.todayFlow, isNotEmpty);
      expect(result.summary?.observedCue, isNotEmpty);
      expect(result.summary?.leftForTomorrow, isNotEmpty);
      expect(result.summary?.tomorrowLine, isNotEmpty);
      expect(result.morningDraft?.startLine, isNotEmpty);
      expect(result.morningDraft?.firstThing, isNotEmpty);
      expect(result.morningDraft?.toneHint, isNotEmpty);
    });

    test('does not include forbidden diagnostic copy', () {
      final result = engine.generate(
        const ReflectionInput(
          text:
              'Today felt busy and I still need to check one small thing tomorrow.',
          source: ReflectionInputSource.manual,
        ),
      );
      final combined = [
        result.summary?.preview,
        result.summary?.todayFlow,
        result.summary?.observedCue,
        result.summary?.leftForTomorrow,
        result.summary?.tomorrowLine,
        result.morningDraft?.startLine,
        result.morningDraft?.firstThing,
        result.morningDraft?.toneHint,
      ].whereType<String>().join('\n');

      for (final phrase in RuleBasedReflectionEngine.forbiddenCopy) {
        expect(combined.toLowerCase(), isNot(contains(phrase.toLowerCase())));
      }
    });
  });
}
