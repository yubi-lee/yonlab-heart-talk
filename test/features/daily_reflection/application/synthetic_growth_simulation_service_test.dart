import 'package:flutter_test/flutter_test.dart';
import 'package:heart_talk/features/daily_reflection/application/growth_calculator.dart';
import 'package:heart_talk/features/daily_reflection/application/local_insight_service.dart';
import 'package:heart_talk/features/daily_reflection/application/morning_brief_service.dart';
import 'package:heart_talk/features/daily_reflection/application/synthetic_growth_simulation_service.dart';
import 'package:heart_talk/features/daily_reflection/data/synthetic_growth_simulation_repository.dart';
import 'package:heart_talk/features/daily_reflection/domain/local_memory_models.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool _containsSensitivePattern(String value) {
  return RegExp(
    r'(\b\d{2,3}-\d{3,4}-\d{4}\b|@|https?://|www\.)',
  ).hasMatch(value);
}

Iterable<String> _snapshotStrings(LocalMemorySnapshot snapshot) sync* {
  yield snapshot.profile.displayName;
  yield snapshot.profile.importantContext;
  yield* snapshot.profile.interests;
  for (final entry in snapshot.dailyEntries) {
    yield entry.summary;
    yield* entry.tags;
  }
  for (final person in snapshot.people) {
    yield person.label;
    yield person.note;
  }
  for (final todo in snapshot.todos) {
    yield todo.title;
  }
  for (final item in snapshot.memoryItems) {
    yield item.label;
  }
  for (final keyword in snapshot.recurringKeywords.keys) {
    yield keyword;
  }
}

void main() {
  const growthCalculator = GrowthCalculator();
  const insightService = LocalInsightService();
  const morningBriefService = MorningBriefService();
  const simulationService = SyntheticGrowthSimulationService();

  test('exposes at least eight Korean scene presets', () {
    expect(syntheticGrowthScenePresets.length, greaterThanOrEqualTo(8));
    expect(
      syntheticGrowthScenePresets.map((preset) => preset.displayNameKo),
      containsAll(<String>[
        '창업자 바쁜 하루',
        '회사 업무 스트레스',
        '가족과의 대화',
        '다정한 응원 모드',
        '공부/자격증 준비',
        '운동/건강 루틴',
        '번아웃 회복',
        '관계 고민',
      ]),
    );
  });

  test('generates a 100-day synthetic snapshot with high growth', () {
    final session = simulationService.generate(
      scene: syntheticGrowthScenePresets.first,
      dayCount: 100,
      generatedAt: DateTime.utc(2026, 6, 30),
    );
    final snapshot = session.snapshot;
    final growthState = growthCalculator.calculate(snapshot);

    expect(session.dayCount, 100);
    expect(snapshot.dailyEntries.length, 100);
    expect(growthState.level, 5);
    expect(snapshot.people, isNotEmpty);
    expect(snapshot.todos, isNotEmpty);
    expect(
      snapshot.recurringKeywords.values.where((count) => count >= 2),
      isNotEmpty,
    );
    for (final value in _snapshotStrings(snapshot)) {
      expect(_containsSensitivePattern(value), isFalse);
    }
  });

  test('creates different scene specific signals and summaries', () {
    final founder = simulationService.generate(
      scene: syntheticGrowthScenePresets.firstWhere(
        (preset) => preset.id == 'founder-busy-day',
      ),
      generatedAt: DateTime.utc(2026, 6, 30),
    );
    final listener = simulationService.generate(
      scene: syntheticGrowthScenePresets.firstWhere(
        (preset) => preset.id == 'quiet-listening',
      ),
      generatedAt: DateTime.utc(2026, 6, 30),
    );

    expect(
      founder.snapshot.dailyEntries.first.summary,
      isNot(equals(listener.snapshot.dailyEntries.first.summary)),
    );
    expect(
      founder.snapshot.dailyEntries.first.tags,
      isNot(equals(listener.snapshot.dailyEntries.first.tags)),
    );
    expect(
      founder.snapshot.profile.displayName,
      isNot(equals(listener.snapshot.profile.displayName)),
    );
  });

  test(
    'generated snapshot produces personalized insight and morning brief',
    () {
      final session = simulationService.generate(
        scene: syntheticGrowthScenePresets.firstWhere(
          (preset) => preset.id == 'goal-coaching',
        ),
        generatedAt: DateTime.utc(2026, 6, 30),
      );
      final snapshot = session.snapshot;
      final growthState = growthCalculator.calculate(snapshot);
      final insight = insightService.generate(
        snapshot: snapshot,
        preference: snapshot.companionPreference,
        growthState: growthState,
      );
      final morningBrief = morningBriefService.generate(
        snapshot: snapshot,
        insight: insight,
        preference: snapshot.companionPreference,
        growthState: growthState,
      );

      expect(insight.isFallback, isFalse);
      expect(insight.patternBody, isNotEmpty);
      expect(insight.recurringSignals, isNotEmpty);
      expect(morningBrief.isFallback, isFalse);
      expect(morningBrief.firstStep.body, isNotEmpty);
      expect(morningBrief.roleMessage, contains('코치'));
    },
  );

  test('repository save load and clear keeps simulation separate', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final repository = SharedPreferencesSyntheticGrowthSimulationRepository(
      prefs,
    );

    final session = simulationService.generate(
      scene: syntheticGrowthScenePresets.firstWhere(
        (preset) => preset.id == 'weekend-recovery',
      ),
      generatedAt: DateTime.utc(2026, 6, 30),
    );

    await repository.saveSession(session);
    final loaded = await repository.loadSession();
    expect(loaded, isNotNull);
    expect(loaded!.presetId, session.presetId);
    expect(
      loaded.snapshot.dailyEntries.length,
      session.snapshot.dailyEntries.length,
    );

    await repository.clearSession();
    expect(await repository.loadSession(), isNull);
  });
}
