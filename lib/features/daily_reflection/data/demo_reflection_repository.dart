import '../domain/reflection_models.dart';

class DemoReflectionRepository {
  const DemoReflectionRepository();

  List<DemoReflectionEvent> listEvents() {
    return const [
      DemoReflectionEvent(
        id: 'work_coordination',
        title: '회의 후 정리',
        scenario: 'work_coordination',
        text: '오후 회의에서 일정과 역할을 다시 조율했다. 내일 확인할 일이 하나 남았다.',
        tags: ['demo', 'work', 'coordination'],
      ),
      DemoReflectionEvent(
        id: 'family_conversation',
        title: '가족과 저녁 대화',
        scenario: 'family_conversation',
        text: '저녁에 가족과 하루 이야기를 나눴다. 서로 바빴지만 잠깐 웃을 수 있었다.',
        tags: ['demo', 'family', 'conversation'],
      ),
      DemoReflectionEvent(
        id: 'gratitude_note',
        title: '고마운 도움',
        scenario: 'gratitude',
        text: '동료가 자료 정리를 도와줬다. 덕분에 오늘 일을 편하게 마무리했다.',
        tags: ['demo', 'gratitude'],
      ),
      DemoReflectionEvent(
        id: 'tomorrow_task',
        title: '내일 할 일',
        scenario: 'tomorrow_task',
        text: '오늘 다 끝내지 못한 문서가 있다. 내일 아침에 먼저 확인해야겠다.',
        tags: ['demo', 'tomorrow', 'task'],
      ),
      DemoReflectionEvent(
        id: 'unresolved_talk',
        title: '조금 남은 대화',
        scenario: 'unresolved_talk',
        text: '대화 중에 애매하게 넘어간 부분이 있었다. 아직 정리되지 않은 느낌이 남았다.',
        tags: ['demo', 'unresolved', 'conversation'],
      ),
    ];
  }
}
