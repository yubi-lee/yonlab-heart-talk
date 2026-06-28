import 'package:flutter_test/flutter_test.dart';
import 'package:heart_talk/features/daily_reflection/application/companion_message_service.dart';
import 'package:heart_talk/features/daily_reflection/application/growth_calculator.dart';
import 'package:heart_talk/features/daily_reflection/domain/companion_models.dart';
import 'package:heart_talk/features/daily_reflection/domain/local_memory_models.dart';

void main() {
  group('companion role and preferences', () {
    test('exposes required Korean role labels', () {
      expect(CompanionRole.friend.koreanLabel, '친구');
      expect(CompanionRole.lover.koreanLabel, '연인');
      expect(CompanionRole.family.koreanLabel, '가족');
      expect(CompanionRole.parent.koreanLabel, '부모');
      expect(CompanionRole.coach.koreanLabel, '코치');
      expect(CompanionRole.teacher.koreanLabel, '선생님');
      expect(CompanionRole.listener.koreanLabel, '경청자');
      expect(CompanionRole.custom.koreanLabel, '사용자 지정');
    });

    test('round trips companion preference through json', () {
      const preference = CompanionPreference(
        defaultRole: CompanionRole.coach,
        responseLength: CompanionResponseLength.long,
        affectionLevel: 4,
        directnessLevel: 3,
        avoidPhrases: ['힘내', '괜찮아'],
        customRoleName: '차분한 동료',
        customToneHint: '짧고 구체적으로 말하기',
      );

      expect(CompanionPreference.fromJson(preference.toJson()), preference);
    });
  });

  group('consent settings', () {
    test('stores nothing when local memory is disabled', () {
      final consent = ConsentSettings.disabled();

      expect(consent.localMemoryEnabled, isFalse);
      expect(consent.canStore(MemoryCategory.profile), isFalse);
      expect(consent.canStore(MemoryCategory.todos), isFalse);
    });

    test('stores only enabled categories when local memory is enabled', () {
      const consent = ConsentSettings(
        localMemoryEnabled: true,
        enabledCategories: {MemoryCategory.profile, MemoryCategory.todos},
      );

      expect(consent.canStore(MemoryCategory.profile), isTrue);
      expect(consent.canStore(MemoryCategory.todos), isTrue);
      expect(consent.canStore(MemoryCategory.people), isFalse);
      expect(ConsentSettings.fromJson(consent.toJson()), consent);
    });
  });

  group('growth calculator', () {
    test('returns level zero when local memory consent is off', () {
      final snapshot = LocalMemorySnapshot.empty().copyWith(
        consentSettings: ConsentSettings.disabled(),
        dailyEntries: [
          DailyReflectionEntry(
            id: 'entry-1',
            summary: '오늘은 회의가 많았고 내일 확인할 일이 남았다.',
            tags: const ['work'],
            createdAt: DateTime.utc(2026, 6, 28),
          ),
        ],
      );

      final state = const GrowthCalculator().calculate(snapshot);

      expect(state.level, 0);
      expect(state.memoryScore, 0);
    });

    test('calculates deterministic level from stored memory volume', () {
      final snapshot = LocalMemorySnapshot.empty().copyWith(
        consentSettings: ConsentSettings.allEnabled(),
        profile: const LocalUserProfile(
          displayName: '사용자',
          interests: ['산책', '기록'],
          importantContext: '저녁에 차분한 문장을 좋아함',
        ),
        dailyEntries: [
          DailyReflectionEntry(
            id: 'entry-1',
            summary: '오늘은 회의가 많았고 내일 확인할 일이 남았다.',
            tags: const ['work', 'todo'],
            createdAt: DateTime.utc(2026, 6, 24),
          ),
          DailyReflectionEntry(
            id: 'entry-2',
            summary: '가족과 짧게 안부를 나눴다.',
            tags: const ['family'],
            createdAt: DateTime.utc(2026, 6, 25),
          ),
          DailyReflectionEntry(
            id: 'entry-3',
            summary: '내일 다시 확인할 작은 일이 있다.',
            tags: const ['todo'],
            createdAt: DateTime.utc(2026, 6, 26),
          ),
        ],
        people: [
          PersonMemory(
            id: 'person-1',
            label: '가족',
            note: '짧은 안부를 좋아함',
            createdAt: DateTime.utc(2026, 6, 25),
          ),
        ],
        todos: [
          TodoMemory(
            id: 'todo-1',
            title: '문서 첫 부분 확인',
            createdAt: DateTime.utc(2026, 6, 26),
          ),
        ],
        recurringKeywords: {'todo': 2, 'family': 1},
      );

      final state = const GrowthCalculator().calculate(snapshot);

      expect(state.daysWithEntries, 3);
      expect(state.profileCompleteness, 3);
      expect(state.recurringKeywordCount, 1);
      expect(state.relationshipMemoryCount, 1);
      expect(state.todoMemoryCount, 1);
      expect(state.level, 4);
      expect(state.memoryScore, greaterThan(0));
    });
  });

  group('companion message service', () {
    test('generates different Korean messages by role and growth level', () {
      final service = const CompanionMessageService();
      const preference = CompanionPreference(defaultRole: CompanionRole.friend);
      const growth = CompanionGrowthState(
        level: 3,
        memoryScore: 8,
        daysWithEntries: 3,
        profileCompleteness: 2,
        recurringKeywordCount: 1,
        relationshipMemoryCount: 1,
        todoMemoryCount: 1,
      );

      final friendMessage = service.generateMessage(
        preference: preference,
        growthState: growth,
        reflectionSummary: '내일 확인할 작은 일이 남아 있다.',
      );
      final coachMessage = service.generateMessage(
        preference: preference.copyWith(defaultRole: CompanionRole.coach),
        growthState: growth,
        reflectionSummary: '내일 확인할 작은 일이 남아 있다.',
      );

      expect(friendMessage, contains('친구처럼'));
      expect(coachMessage, contains('한 걸음'));
      expect(friendMessage, isNot(coachMessage));
      expect(friendMessage, isNot(contains('진단')));
      expect(coachMessage, isNot(contains('치료')));
    });
  });
}
