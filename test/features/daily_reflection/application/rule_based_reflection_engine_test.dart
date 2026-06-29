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
      expect(result.validationMessage, contains('한 문장 이상 적어주세요'));
    });

    test('returns deterministic output for the same manual input', () {
      const input = ReflectionInput(
        text: '오늘은 프로젝트 회의를 정리하고 내일 확인할 작은 일을 적어두었다.',
        source: ReflectionInputSource.manual,
      );

      final first = engine.generate(input);
      final second = engine.generate(input);

      expect(first.summary?.preview, second.summary?.preview);
      expect(first.summary?.todayFlow, second.summary?.todayFlow);
      expect(first.morningDraft?.firstThing, second.morningDraft?.firstThing);
      expect(first.summary?.sourceLabel, '직접 입력');
    });

    test('creates summary and tomorrow note for demo input', () {
      final result = engine.generate(
        const ReflectionInput(
          text: '동료가 메모를 정리해줘서 하루 끝이 조금 더 가벼워졌다.',
          source: ReflectionInputSource.demo,
          demoEventId: 'gratitude_note',
        ),
      );

      expect(result.isValid, isTrue);
      expect(result.summary?.sourceLabel, '데모 예시');
      expect(result.summary?.preview, contains('오늘'));
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
          text: '오늘은 바빴고 내일 작은 할 일을 하나만 다시 확인하면 된다.',
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
