import '../domain/reflection_models.dart';

class DemoReflectionRepository {
  const DemoReflectionRepository();

  List<DemoReflectionEvent> listEvents() {
    return const [
      DemoReflectionEvent(
        id: 'work_coordination',
        title: 'Work coordination',
        scenario: 'work_coordination',
        text:
            'Today included a project check-in, a schedule decision, and one follow-up to review tomorrow.',
        tags: ['demo', 'work', 'coordination'],
      ),
      DemoReflectionEvent(
        id: 'family_conversation',
        title: 'Family check-in',
        scenario: 'family_conversation',
        text:
            'A family conversation felt gentle, and it helped the evening feel a little more settled.',
        tags: ['demo', 'family', 'conversation'],
      ),
      DemoReflectionEvent(
        id: 'gratitude_note',
        title: 'Gratitude note',
        scenario: 'gratitude',
        text:
            'A teammate helped organize the notes, and the day ended with a grateful feeling.',
        tags: ['demo', 'gratitude'],
      ),
      DemoReflectionEvent(
        id: 'tomorrow_task',
        title: 'Tomorrow task',
        scenario: 'tomorrow_task',
        text:
            'One document is not finished yet. Tomorrow can start by reviewing the first small section.',
        tags: ['demo', 'tomorrow', 'task'],
      ),
      DemoReflectionEvent(
        id: 'unresolved_talk',
        title: 'Unresolved talk',
        scenario: 'unresolved_talk',
        text:
            'A conversation still feels unfinished, but there is time to return to it with a calmer tone.',
        tags: ['demo', 'unresolved', 'conversation'],
      ),
    ];
  }
}
