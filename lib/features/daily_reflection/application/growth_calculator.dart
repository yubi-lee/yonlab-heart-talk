import '../domain/companion_models.dart';
import '../domain/local_memory_models.dart';

class GrowthCalculator {
  const GrowthCalculator();

  CompanionGrowthState calculate(LocalMemorySnapshot snapshot) {
    if (!snapshot.consentSettings.localMemoryEnabled) {
      return const CompanionGrowthState(
        level: 0,
        memoryScore: 0,
        daysWithEntries: 0,
        profileCompleteness: 0,
        recurringKeywordCount: 0,
        relationshipMemoryCount: 0,
        todoMemoryCount: 0,
      );
    }

    final daysWithEntries = snapshot.dailyEntries
        .map(
          (entry) => DateTime.utc(
            entry.createdAt.year,
            entry.createdAt.month,
            entry.createdAt.day,
          ),
        )
        .toSet()
        .length;
    final profileCompleteness = _profileCompleteness(snapshot.profile);
    final recurringKeywordCount = snapshot.recurringKeywords.values
        .where((count) => count >= 2)
        .length;
    final relationshipMemoryCount = snapshot.people.length;
    final todoMemoryCount = snapshot.todos.length;
    final memoryScore =
        daysWithEntries +
        profileCompleteness +
        recurringKeywordCount +
        relationshipMemoryCount +
        todoMemoryCount;

    return CompanionGrowthState(
      level: _levelFor(memoryScore),
      memoryScore: memoryScore,
      daysWithEntries: daysWithEntries,
      profileCompleteness: profileCompleteness,
      recurringKeywordCount: recurringKeywordCount,
      relationshipMemoryCount: relationshipMemoryCount,
      todoMemoryCount: todoMemoryCount,
    );
  }

  int _profileCompleteness(LocalUserProfile profile) {
    var score = 0;
    if (profile.displayName.trim().isNotEmpty) {
      score += 1;
    }
    if (profile.interests.isNotEmpty) {
      score += 1;
    }
    if (profile.importantContext.trim().isNotEmpty) {
      score += 1;
    }
    return score;
  }

  int _levelFor(int memoryScore) {
    if (memoryScore <= 0) {
      return 0;
    }
    if (memoryScore <= 2) {
      return 1;
    }
    if (memoryScore <= 4) {
      return 2;
    }
    if (memoryScore <= 6) {
      return 3;
    }
    if (memoryScore <= 9) {
      return 4;
    }
    return 5;
  }
}
