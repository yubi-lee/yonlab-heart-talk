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
      expect(result.validationMessage, contains('한 줄 이상'));
    });

    test('returns deterministic output for the same input', () {
      const input = ReflectionInput(
        text: '오늘 회의에서 일정을 조율했고 내일 확인할 일이 남았다.',
        source: ReflectionInputSource.manual,
      );

      final first = engine.generate(input);
      final second = engine.generate(input);

      expect(first.summary?.preview, second.summary?.preview);
      expect(first.summary?.todayFlow, second.summary?.todayFlow);
      expect(first.morningDraft?.firstThing, second.morningDraft?.firstThing);
    });

    test('creates summary and morning briefing for demo input', () {
      final result = engine.generate(
        const ReflectionInput(
          text: '동료가 자료 정리를 도와줬다. 덕분에 오늘 일을 마무리했다.',
          source: ReflectionInputSource.demo,
          demoEventId: 'gratitude_note',
        ),
      );

      expect(result.isValid, isTrue);
      expect(result.summary?.sourceLabel, contains('데모 데이터'));
      expect(result.summary?.todayFlow, contains('고마움'));
      expect(result.morningDraft?.startLine, isNotEmpty);
    });

    test('does not include forbidden diagnostic copy', () {
      final result = engine.generate(
        const ReflectionInput(
          text: '오늘은 바빴고 내일 확인할 일이 있다.',
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
        expect(combined.contains(phrase), isFalse, reason: phrase);
      }
    });
  });
}
