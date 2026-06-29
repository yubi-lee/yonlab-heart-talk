import '../domain/reflection_models.dart';

class DemoReflectionRepository {
  const DemoReflectionRepository();

  List<DemoReflectionEvent> listEvents() {
    return const [
      DemoReflectionEvent(
        id: 'work_coordination',
        title: '회의와 정리',
        scenario: 'work_coordination',
        text: '오늘은 프로젝트 점검과 일정 정리가 이어졌고, 내일 다시 볼 확인 항목이 하나 남았다.',
        tags: ['demo', 'work', 'coordination'],
      ),
      DemoReflectionEvent(
        id: 'family_conversation',
        title: '가족과 나눈 말',
        scenario: 'family_conversation',
        text: '가족과 나눈 대화가 부드럽게 남아서 저녁이 조금 더 차분하게 느껴졌다.',
        tags: ['demo', 'family', 'conversation'],
      ),
      DemoReflectionEvent(
        id: 'gratitude_note',
        title: '고마웠던 순간',
        scenario: 'gratitude',
        text: '동료가 메모를 정리하는 걸 도와줘서 하루 끝이 조금 더 가벼워졌다.',
        tags: ['demo', 'gratitude'],
      ),
      DemoReflectionEvent(
        id: 'tomorrow_task',
        title: '내일 시작할 일',
        scenario: 'tomorrow_task',
        text: '문서 하나가 아직 덜 끝나서 내일은 가장 작은 부분부터 다시 확인하면 좋겠다.',
        tags: ['demo', 'tomorrow', 'task'],
      ),
      DemoReflectionEvent(
        id: 'unresolved_talk',
        title: '마음에 남은 대화',
        scenario: 'unresolved_talk',
        text: '끝나지 않은 대화가 남아 있지만, 조금 더 차분한 톤으로 다시 돌아갈 시간은 있다.',
        tags: ['demo', 'unresolved', 'conversation'],
      ),
    ];
  }
}
