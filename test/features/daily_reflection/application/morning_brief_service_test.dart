import 'package:flutter_test/flutter_test.dart';
import 'package:heart_talk/features/daily_reflection/application/growth_calculator.dart';
import 'package:heart_talk/features/daily_reflection/application/local_insight_service.dart';
import 'package:heart_talk/features/daily_reflection/application/morning_brief_service.dart';
import 'package:heart_talk/features/daily_reflection/domain/companion_models.dart';
import 'package:heart_talk/features/daily_reflection/domain/local_memory_models.dart';
import 'package:heart_talk/features/daily_reflection/domain/morning_brief_models.dart';

void main() {
  const growthCalculator = GrowthCalculator();
  const insightService = LocalInsightService();
  const service = MorningBriefService();

  MorningBrief generate(LocalMemorySnapshot snapshot) {
    final growthState = growthCalculator.calculate(snapshot);
    final insight = insightService.generate(
      snapshot: snapshot,
      preference: snapshot.companionPreference,
      growthState: growthState,
    );
    return service.generate(
      snapshot: snapshot,
      insight: insight,
      preference: snapshot.companionPreference,
      growthState: growthState,
    );
  }

  test('creates fallback morning brief for an empty snapshot', () {
    final brief = generate(LocalMemorySnapshot.empty());

    expect(brief.isFallback, isTrue);
    expect(brief.usesPersonalMemory, isFalse);
    expect(brief.title, '오늘 시작하기');
    expect(brief.greeting, contains('좋은 아침'));
    expect(brief.firstStep.estimatedMinutes, 3);
  });

  test('does not personalize morning brief when local memory is disabled', () {
    final snapshot = LocalMemorySnapshot.empty().copyWith(
      profile: const LocalUserProfile(displayName: '테스트친구'),
      todos: [
        TodoMemory(
          id: 'todo-1',
          title: '문서 정리',
          createdAt: DateTime.utc(2026, 6, 29),
        ),
      ],
      dailyEntries: [
        DailyReflectionEntry(
          id: 'entry-1',
          summary: '회의가 길어서 조금 피곤했다.',
          tags: const ['work', 'fatigue'],
          createdAt: DateTime.utc(2026, 6, 29),
        ),
      ],
    );

    final brief = generate(snapshot);

    expect(brief.isFallback, isTrue);
    expect(brief.usesPersonalMemory, isFalse);
    expect(brief.carryOverLine, isNot(contains('회의가 길어서 조금 피곤했다.')));
    expect(brief.firstStep.body, isNot(contains('문서 정리')));
  });

  test('uses saved todo as the first step when consent is enabled', () {
    final snapshot = LocalMemorySnapshot.empty().copyWith(
      consentSettings: ConsentSettings.allEnabled(),
      companionPreference: const CompanionPreference(
        defaultRole: CompanionRole.coach,
      ),
      todos: [
        TodoMemory(
          id: 'todo-1',
          title: '아침에 가장 쉬운 문서 정리부터 시작하기',
          createdAt: DateTime.utc(2026, 6, 29),
        ),
      ],
    );

    final brief = generate(snapshot);

    expect(brief.isFallback, isFalse);
    expect(brief.usesPersonalMemory, isTrue);
    expect(brief.firstStep.body, contains('문서 정리'));
    expect(brief.roleMessage, contains('코치'));
  });

  test(
    'uses insight tiny mission as fallback first step when todo is missing',
    () {
      final snapshot = LocalMemorySnapshot.empty().copyWith(
        consentSettings: ConsentSettings.allEnabled(),
        dailyEntries: [
          DailyReflectionEntry(
            id: 'entry-1',
            summary: '오늘은 시작이 조금 무거웠다.',
            tags: const ['slow-start'],
            createdAt: DateTime.utc(2026, 6, 29),
          ),
        ],
        recurringKeywords: const {'slow-start': 2},
      );

      final brief = generate(snapshot);

      expect(brief.isFallback, isFalse);
      expect(brief.firstStep.body, contains('3분'));
    },
  );

  test(
    'uses recent reflection summary as a carry-over line without copying whole history',
    () {
      final snapshot = LocalMemorySnapshot.empty().copyWith(
        consentSettings: ConsentSettings.allEnabled(),
        dailyEntries: [
          DailyReflectionEntry(
            id: 'entry-1',
            summary: '회의가 많아서 조금 피곤했지만, 해야 할 일을 하나 끝냈다.',
            tags: const ['work', 'fatigue', 'progress'],
            createdAt: DateTime.utc(2026, 6, 29),
          ),
        ],
      );

      final brief = generate(snapshot);

      expect(brief.isFallback, isFalse);
      expect(brief.carryOverLine, contains('어제'));
      expect(brief.carryOverLine, isNotEmpty);
    },
  );

  test('creates role-specific morning messages for coach and listener', () {
    final snapshot = LocalMemorySnapshot.empty().copyWith(
      consentSettings: ConsentSettings.allEnabled(),
      dailyEntries: [
        DailyReflectionEntry(
          id: 'entry-1',
          summary: '조금씩 정리한 하루였다.',
          tags: const ['progress'],
          createdAt: DateTime.utc(2026, 6, 29),
        ),
      ],
    );
    final growthState = growthCalculator.calculate(snapshot);
    final insight = insightService.generate(
      snapshot: snapshot,
      preference: snapshot.companionPreference,
      growthState: growthState,
    );

    final coach = service.generate(
      snapshot: snapshot,
      insight: insight,
      preference: const CompanionPreference(defaultRole: CompanionRole.coach),
      growthState: growthState,
    );
    final listener = service.generate(
      snapshot: snapshot,
      insight: insight,
      preference: const CompanionPreference(
        defaultRole: CompanionRole.listener,
      ),
      growthState: growthState,
    );

    expect(coach.roleMessage, isNot(listener.roleMessage));
    expect(coach.roleMessage, contains('시작'));
    expect(listener.roleMessage, contains('질문'));
  });

  test('keeps lover and parent messages away from unsafe wording', () {
    final snapshot = LocalMemorySnapshot.empty().copyWith(
      consentSettings: ConsentSettings.allEnabled(),
      dailyEntries: [
        DailyReflectionEntry(
          id: 'entry-1',
          summary: '오늘은 시작이 조금 무거웠다.',
          tags: const ['slow-start'],
          createdAt: DateTime.utc(2026, 6, 29),
        ),
      ],
      recurringKeywords: const {'slow-start': 2},
    );
    final growthState = growthCalculator.calculate(snapshot);
    final insight = insightService.generate(
      snapshot: snapshot,
      preference: snapshot.companionPreference,
      growthState: growthState,
    );

    final lover = service.generate(
      snapshot: snapshot,
      insight: insight,
      preference: const CompanionPreference(defaultRole: CompanionRole.lover),
      growthState: growthState,
    );
    final parent = service.generate(
      snapshot: snapshot,
      insight: insight,
      preference: const CompanionPreference(defaultRole: CompanionRole.parent),
      growthState: growthState,
    );

    final combined = [
      lover.greeting,
      lover.roleMessage,
      parent.greeting,
      parent.roleMessage,
    ].join(' ');

    for (final forbidden in ['집착', '성적', '의존', '통제', '비난', '수치심', '진단', '치료']) {
      expect(combined, isNot(contains(forbidden)));
    }
  });
}
