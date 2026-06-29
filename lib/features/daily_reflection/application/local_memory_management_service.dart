import '../domain/local_memory_models.dart';

class LocalMemoryManagementService {
  const LocalMemoryManagementService();

  LocalMemorySnapshot updateProfileDisplayName(
    LocalMemorySnapshot snapshot,
    String displayName,
  ) {
    final trimmed = displayName.trim();
    if (trimmed == snapshot.profile.displayName) {
      return snapshot;
    }

    return snapshot.copyWith(
      profile: LocalUserProfile(
        displayName: trimmed,
        interests: snapshot.profile.interests,
        importantContext: snapshot.profile.importantContext,
      ),
    );
  }

  LocalMemorySnapshot updateTodoTitle(
    LocalMemorySnapshot snapshot, {
    required String todoId,
    required String title,
  }) {
    final trimmed = title.trim();
    if (trimmed.isEmpty) {
      return snapshot;
    }

    final todos = snapshot.todos
        .map(
          (todo) => todo.id == todoId
              ? TodoMemory(
                  id: todo.id,
                  title: trimmed,
                  createdAt: todo.createdAt,
                  isCompleted: todo.isCompleted,
                )
              : todo,
        )
        .toList(growable: false);

    return snapshot.copyWith(todos: todos);
  }

  LocalMemorySnapshot deleteTodo(
    LocalMemorySnapshot snapshot, {
    required String todoId,
  }) {
    return snapshot.copyWith(
      todos: snapshot.todos
          .where((todo) => todo.id != todoId)
          .toList(growable: false),
    );
  }

  LocalMemorySnapshot updatePerson(
    LocalMemorySnapshot snapshot, {
    required String personId,
    required String label,
    required String note,
  }) {
    final trimmedLabel = label.trim();
    final trimmedNote = note.trim();
    if (trimmedLabel.isEmpty || trimmedNote.isEmpty) {
      return snapshot;
    }

    final people = snapshot.people
        .map(
          (person) => person.id == personId
              ? PersonMemory(
                  id: person.id,
                  label: trimmedLabel,
                  note: trimmedNote,
                  createdAt: person.createdAt,
                )
              : person,
        )
        .toList(growable: false);

    return snapshot.copyWith(people: people);
  }

  LocalMemorySnapshot deletePerson(
    LocalMemorySnapshot snapshot, {
    required String personId,
  }) {
    return snapshot.copyWith(
      people: snapshot.people
          .where((person) => person.id != personId)
          .toList(growable: false),
    );
  }

  LocalMemorySnapshot deleteReflectionEntry(
    LocalMemorySnapshot snapshot, {
    required String entryId,
  }) {
    final entries = snapshot.dailyEntries
        .where((entry) => entry.id != entryId)
        .toList(growable: false);
    return snapshot.copyWith(
      dailyEntries: entries,
      recurringKeywords: _rebuildRecurringKeywords(entries),
    );
  }

  Map<String, int> _rebuildRecurringKeywords(
    List<DailyReflectionEntry> entries,
  ) {
    final recurringKeywords = <String, int>{};
    for (final entry in entries) {
      for (final tag in entry.tags) {
        final trimmed = tag.trim();
        if (trimmed.isEmpty || trimmed == 'demo') {
          continue;
        }
        recurringKeywords[trimmed] = (recurringKeywords[trimmed] ?? 0) + 1;
      }
    }
    return recurringKeywords;
  }
}
