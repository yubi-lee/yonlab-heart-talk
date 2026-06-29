import 'package:flutter_test/flutter_test.dart';
import 'package:heart_talk/features/daily_reflection/application/growth_calculator.dart';
import 'package:heart_talk/features/daily_reflection/application/local_insight_service.dart';
import 'package:heart_talk/features/daily_reflection/application/local_memory_management_service.dart';
import 'package:heart_talk/features/daily_reflection/application/morning_brief_service.dart';
import 'package:heart_talk/features/daily_reflection/domain/companion_models.dart';
import 'package:heart_talk/features/daily_reflection/domain/local_memory_models.dart';

void main() {
  const service = LocalMemoryManagementService();
  const growthCalculator = GrowthCalculator();
  const insightService = LocalInsightService();
  const morningBriefService = MorningBriefService();

  LocalMemorySnapshot buildSnapshot() {
    return LocalMemorySnapshot.empty().copyWith(
      consentSettings: ConsentSettings.allEnabled(),
      companionPreference: const CompanionPreference(
        defaultRole: CompanionRole.coach,
      ),
      profile: const LocalUserProfile(displayName: '테스트친구'),
      dailyEntries: [
        DailyReflectionEntry(
          id: 'entry-1',
          summary: '회의가 많아서 피곤했지만 할 일을 하나 끝냈다.',
          tags: const ['fatigue', 'task'],
          createdAt: DateTime.utc(2026, 6, 30),
        ),
        DailyReflectionEntry(
          id: 'entry-2',
          summary: '동료와 대화를 마치고 조금 정리된 기분이 들었다.',
          tags: const ['conversation'],
          createdAt: DateTime.utc(2026, 6, 29),
        ),
      ],
      people: [
        PersonMemory(
          id: 'person-1',
          label: '동료 A',
          note: '회의 뒤에 다시 이야기하기',
          createdAt: DateTime.utc(2026, 6, 30),
        ),
      ],
      todos: [
        TodoMemory(
          id: 'todo-1',
          title: '문서 정리부터 시작하기',
          createdAt: DateTime.utc(2026, 6, 30),
        ),
      ],
      recurringKeywords: const {'fatigue': 1, 'task': 1, 'conversation': 1},
    );
  }

  group('LocalMemoryManagementService', () {
    test('updates the profile display name with trimmed text', () {
      final snapshot = buildSnapshot();

      final updated = service.updateProfileDisplayName(snapshot, '  새로운 이름  ');

      expect(updated.profile.displayName, '새로운 이름');
      expect(updated.todos, snapshot.todos);
    });

    test('updates todo title by id', () {
      final snapshot = buildSnapshot();

      final updated = service.updateTodoTitle(
        snapshot,
        todoId: 'todo-1',
        title: '아침에 가장 쉬운 문서부터 정리하기',
      );

      expect(updated.todos.single.title, '아침에 가장 쉬운 문서부터 정리하기');
    });

    test('deletes person and todo items by id', () {
      final snapshot = buildSnapshot();

      final withoutPerson = service.deletePerson(
        snapshot,
        personId: 'person-1',
      );
      final withoutTodo = service.deleteTodo(withoutPerson, todoId: 'todo-1');

      expect(withoutTodo.people, isEmpty);
      expect(withoutTodo.todos, isEmpty);
    });

    test('deletes reflection entry and rebuilds recurring keywords', () {
      final snapshot = buildSnapshot();

      final updated = service.deleteReflectionEntry(
        snapshot,
        entryId: 'entry-1',
      );

      expect(updated.dailyEntries.map((entry) => entry.id), ['entry-2']);
      expect(updated.recurringKeywords, {'conversation': 1});
    });

    test(
      'delete and update results change derived growth insight and morning brief',
      () {
        final snapshot = buildSnapshot();
        final initialGrowth = growthCalculator.calculate(snapshot);
        final initialInsight = insightService.generate(
          snapshot: snapshot,
          preference: snapshot.companionPreference,
          growthState: initialGrowth,
        );
        final initialBrief = morningBriefService.generate(
          snapshot: snapshot,
          insight: initialInsight,
          preference: snapshot.companionPreference,
          growthState: initialGrowth,
        );

        final updated = service.deleteTodo(
          service.updateProfileDisplayName(snapshot, '코치모드'),
          todoId: 'todo-1',
        );
        final updatedGrowth = growthCalculator.calculate(updated);
        final updatedInsight = insightService.generate(
          snapshot: updated,
          preference: updated.companionPreference,
          growthState: updatedGrowth,
        );
        final updatedBrief = morningBriefService.generate(
          snapshot: updated,
          insight: updatedInsight,
          preference: updated.companionPreference,
          growthState: updatedGrowth,
        );

        expect(initialGrowth.todoMemoryCount, 1);
        expect(updatedGrowth.todoMemoryCount, 0);
        expect(updated.profile.displayName, '코치모드');
        expect(initialBrief.firstStep.body, contains('문서 정리부터 시작하기'));
        expect(updatedBrief.firstStep.body, isNot(contains('문서 정리부터 시작하기')));
        expect(updatedInsight.isFallback, isFalse);
      },
    );
  });
}
