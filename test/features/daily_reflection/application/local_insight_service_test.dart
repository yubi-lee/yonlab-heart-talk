import 'package:flutter_test/flutter_test.dart';
import 'package:heart_talk/features/daily_reflection/application/growth_calculator.dart';
import 'package:heart_talk/features/daily_reflection/application/local_insight_service.dart';
import 'package:heart_talk/features/daily_reflection/domain/companion_models.dart';
import 'package:heart_talk/features/daily_reflection/domain/local_insight_models.dart';
import 'package:heart_talk/features/daily_reflection/domain/local_memory_models.dart';

void main() {
  const service = LocalInsightService();
  const growthCalculator = GrowthCalculator();

  LocalInsightSummary generate(LocalMemorySnapshot snapshot) {
    return service.generate(
      snapshot: snapshot,
      preference: snapshot.companionPreference,
      growthState: growthCalculator.calculate(snapshot),
    );
  }

  test('creates fallback insight for an empty snapshot', () {
    final insight = generate(LocalMemorySnapshot.empty());

    expect(insight.isFallback, isTrue);
    expect(insight.dataDepthLabel, DataDepthLabel.gettingStarted);
    expect(insight.recurringSignals, isEmpty);
    expect(insight.patternBody, contains('아직 알아가는 중'));
    expect(insight.tomorrowHint.body, contains('작은 기록'));
    expect(insight.tinyMission.estimatedMinutes, 3);
  });

  test(
    'does not create personalized insight when local memory is disabled',
    () {
      final snapshot = LocalMemorySnapshot.empty().copyWith(
        dailyEntries: [
          DailyReflectionEntry(
            id: 'entry-1',
            summary: '피곤함과 미룸이 같이 남은 날',
            tags: const ['fatigue', 'delay'],
            createdAt: DateTime.utc(2026, 6, 28),
          ),
        ],
        recurringKeywords: const {'fatigue': 3},
        todos: [
          TodoMemory(
            id: 'todo-1',
            title: '문서 정리',
            createdAt: DateTime.utc(2026, 6, 28),
          ),
        ],
      );

      final insight = generate(snapshot);

      expect(insight.isFallback, isTrue);
      expect(insight.basisEntryCount, 0);
      expect(insight.recurringSignals, isEmpty);
      expect(insight.patternBody, isNot(contains('fatigue')));
    },
  );

  test(
    'creates deterministic pattern insight from saved entries and keywords',
    () {
      final snapshot = LocalMemorySnapshot.empty().copyWith(
        consentSettings: ConsentSettings.allEnabled(),
        dailyEntries: [
          DailyReflectionEntry(
            id: 'entry-1',
            summary: '회의가 길고 피곤했던 날',
            tags: const ['work', 'fatigue'],
            createdAt: DateTime.utc(2026, 6, 27),
          ),
          DailyReflectionEntry(
            id: 'entry-2',
            summary: '할 일을 미루고 피곤함이 남은 날',
            tags: const ['fatigue', 'delay'],
            createdAt: DateTime.utc(2026, 6, 28),
          ),
        ],
        recurringKeywords: const {'fatigue': 2, 'delay': 1},
      );

      final insight = generate(snapshot);

      expect(insight.isFallback, isFalse);
      expect(insight.basisEntryCount, 2);
      expect(insight.dataDepthLabel, DataDepthLabel.learningPattern);
      expect(insight.recurringSignals.first.label, 'fatigue');
      expect(insight.recurringSignals.first.count, 4);
      expect(insight.patternBody, contains('fatigue'));
      expect(insight.tomorrowHint.body, contains('가능성'));
    },
  );

  test(
    'reflects todo and person memory without overexposing relationship text',
    () {
      final snapshot = LocalMemorySnapshot.empty().copyWith(
        consentSettings: ConsentSettings.allEnabled(),
        todos: [
          TodoMemory(
            id: 'todo-1',
            title: '내일 문서 정리',
            createdAt: DateTime.utc(2026, 6, 28),
          ),
        ],
        people: [
          PersonMemory(
            id: 'person-1',
            label: '동료',
            note: '긴 대화를 나눈 사람',
            createdAt: DateTime.utc(2026, 6, 28),
          ),
        ],
      );

      final insight = generate(snapshot);

      expect(
        insight.recurringSignals.map((signal) => signal.label),
        contains('할 일'),
      );
      expect(
        insight.recurringSignals.map((signal) => signal.label),
        contains('관계'),
      );
      expect(insight.curiosityQuestion.text, contains('관계'));
      expect(insight.curiosityQuestion.text, isNot(contains('긴 대화')));
      expect(insight.tinyMission.body, contains('3분'));
    },
  );

  test('creates different role messages for friend coach and listener', () {
    final snapshot = LocalMemorySnapshot.empty().copyWith(
      consentSettings: ConsentSettings.allEnabled(),
      dailyEntries: [
        DailyReflectionEntry(
          id: 'entry-1',
          summary: '작은 성취가 있던 날',
          tags: const ['progress'],
          createdAt: DateTime.utc(2026, 6, 28),
        ),
      ],
    );
    final growthState = growthCalculator.calculate(snapshot);

    final friend = service.generate(
      snapshot: snapshot,
      preference: const CompanionPreference(defaultRole: CompanionRole.friend),
      growthState: growthState,
    );
    final coach = service.generate(
      snapshot: snapshot,
      preference: const CompanionPreference(defaultRole: CompanionRole.coach),
      growthState: growthState,
    );
    final listener = service.generate(
      snapshot: snapshot,
      preference: const CompanionPreference(
        defaultRole: CompanionRole.listener,
      ),
      growthState: growthState,
    );

    expect(friend.roleMessage, isNot(coach.roleMessage));
    expect(coach.roleMessage, isNot(listener.roleMessage));
    expect(friend.roleMessage, contains('곁'));
    expect(coach.roleMessage, contains('실행'));
    expect(listener.roleMessage, contains('질문'));
  });

  test(
    'keeps lover parent and growth copy away from unsafe or diagnostic wording',
    () {
      final snapshot = LocalMemorySnapshot.empty().copyWith(
        consentSettings: ConsentSettings.allEnabled(),
        dailyEntries: [
          DailyReflectionEntry(
            id: 'entry-1',
            summary: '오늘은 시작이 조금 무거웠던 날',
            tags: const ['slow-start'],
            createdAt: DateTime.utc(2026, 6, 28),
          ),
        ],
        recurringKeywords: const {'slow-start': 3},
        todos: [
          TodoMemory(
            id: 'todo-1',
            title: '가벼운 정리',
            createdAt: DateTime.utc(2026, 6, 28),
          ),
        ],
        people: [
          PersonMemory(
            id: 'person-1',
            label: '가족',
            note: '안부를 나눈 사람',
            createdAt: DateTime.utc(2026, 6, 28),
          ),
        ],
      );
      final growthState = growthCalculator.calculate(snapshot);

      final lover = service.generate(
        snapshot: snapshot,
        preference: const CompanionPreference(defaultRole: CompanionRole.lover),
        growthState: growthState,
      );
      final parent = service.generate(
        snapshot: snapshot,
        preference: const CompanionPreference(
          defaultRole: CompanionRole.parent,
        ),
        growthState: growthState,
      );
      final combined = [
        lover.patternBody,
        lover.tomorrowHint.body,
        lover.roleMessage,
        parent.patternBody,
        parent.tomorrowHint.body,
        parent.roleMessage,
      ].join(' ');

      for (final forbidden in [
        '진단',
        '치료',
        '위험도',
        '반드시',
        '집착',
        '성적',
        '수치심',
        '비난',
        '통제',
      ]) {
        expect(combined, isNot(contains(forbidden)));
      }
      expect(lover.roleMessage, contains('다정'));
      expect(parent.roleMessage, contains('생활'));
      expect(lover.dataDepthLabel, DataDepthLabel.enoughForPersonalizedHint);
    },
  );
}
