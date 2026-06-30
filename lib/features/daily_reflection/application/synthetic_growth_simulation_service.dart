import '../domain/companion_models.dart';
import '../domain/local_memory_models.dart';
import '../domain/synthetic_growth_simulation_models.dart';

const syntheticGrowthScenePresets = <LifeScenePreset>[
  LifeScenePreset(
    id: 'founder-busy-day',
    displayNameKo: '창업자 바쁜 하루',
    descriptionKo: '회의, 일정, 작은 결정이 계속 이어지는 하루를 가정한 장면이에요.',
    preferredRole: CompanionRole.coach,
    recurringKeywords: ['회의', '정리', '결정', '집중'],
    moodPattern: ['분주', '긴장', '집중', '차분'],
    todoThemes: ['아침 일정 정리', '회의 메모 정리', '우선순위 점검', '내일 준비'],
    personThemes: ['공동 창업 메모', '실무 협업 메모', '응원 메모'],
    reflectionTemplates: [
      '오늘은 {mood} 흐름이 길었지만 {todoTheme} 하나를 끝냈다.',
      '{personTheme} 이야기를 짧게라도 챙기니 {keyword} 신호가 또 보였다.',
      '바쁜 가운데서도 {todoTheme}를 정리하면서 하루를 다시 붙잡았다.',
    ],
    profileNameKo: '창업 체험 사용자',
    profileInterestsKo: ['가상 창업 기록', '우선순위 정리', '작은 실행'],
    profileContextKo: '실제 개인정보가 아닌 창업 시뮬레이션 데이터예요.',
  ),
  LifeScenePreset(
    id: 'work-stress',
    displayNameKo: '회사 업무 스트레스',
    descriptionKo: '업무와 회의가 겹치고 에너지가 빨리 닳는 장면이에요.',
    preferredRole: CompanionRole.coach,
    recurringKeywords: ['업무', '회의', '피로', '정리'],
    moodPattern: ['피곤', '조급', '무거움', '정돈'],
    todoThemes: ['메일 정리', '보고서 확인', '회의 준비', '퇴근 전 정리'],
    personThemes: ['팀 동료 메모', '협업 메모', '조율 메모'],
    reflectionTemplates: [
      '오늘은 {mood}한 기운이 있었지만 {todoTheme}를 끝내며 버텼다.',
      '{personTheme}를 챙기다 보니 {keyword}가 하루의 중심에 남았다.',
      '작게라도 {todoTheme}를 마치니 마음이 조금 덜 흔들렸다.',
    ],
    profileNameKo: '업무 체험 사용자',
    profileInterestsKo: ['가상 업무 기록', '정리 루틴', '작은 회복'],
    profileContextKo: '실제 회사 정보가 아닌 업무 시뮬레이션 데이터예요.',
  ),
  LifeScenePreset(
    id: 'family-talk',
    displayNameKo: '가족과의 대화',
    descriptionKo: '가족 안부와 생활 리듬이 부드럽게 이어지는 장면이에요.',
    preferredRole: CompanionRole.family,
    recurringKeywords: ['가족', '안부', '식사', '생활'],
    moodPattern: ['따뜻', '익숙', '안심', '포근'],
    todoThemes: ['저녁 안부', '식사 챙기기', '주말 일정 보기', '집안 정리'],
    personThemes: ['가족 메모', '안부 메모', '생활 메모'],
    reflectionTemplates: [
      '오늘은 {mood}한 분위기 속에서 {personTheme}을 천천히 챙겼다.',
      '{todoTheme}를 끝내고 나니 {keyword} 이야기가 더 또렷해졌다.',
      '작은 생활 메모를 남기며 하루를 부드럽게 정리했다.',
    ],
    profileNameKo: '가족 체험 사용자',
    profileInterestsKo: ['가상 가족 기록', '생활 루틴', '안부 챙김'],
    profileContextKo: '실제 가족 정보가 아닌 가상 생활 메모예요.',
  ),
  LifeScenePreset(
    id: 'warm-support',
    displayNameKo: '다정한 응원 모드',
    descriptionKo: '따뜻하게 다독이고 싶을 때 쓰는 장면이에요.',
    preferredRole: CompanionRole.lover,
    recurringKeywords: ['응원', '다정', '휴식', '안심'],
    moodPattern: ['다정', '부드러움', '안도', '포근'],
    todoThemes: ['잠깐 쉬기', '물 한 잔', '호흡 정리', '내일 준비'],
    personThemes: ['응원 메모', '따뜻한 메모', '기억 메모'],
    reflectionTemplates: [
      '오늘은 {mood}한 톤으로 하루를 넘기며 {todoTheme}를 챙겼다.',
      '{personTheme}를 떠올리니 {keyword} 신호가 조금 더 선명해졌다.',
      '무리하지 않고 {todoTheme}를 해내는 쪽으로 마음을 돌렸다.',
    ],
    profileNameKo: '다정 체험 사용자',
    profileInterestsKo: ['가상 응원 기록', '부드러운 회복', '작은 휴식'],
    profileContextKo: '실제 개인정보가 아닌 응원 시뮬레이션 데이터예요.',
  ),
  LifeScenePreset(
    id: 'study-cert',
    displayNameKo: '공부/자격증 준비',
    descriptionKo: '시험 공부와 정리 습관이 반복되는 장면이에요.',
    preferredRole: CompanionRole.teacher,
    recurringKeywords: ['공부', '복습', '정리', '문제'],
    moodPattern: ['집중', '차분', '끈기', '정리'],
    todoThemes: ['개념 복습', '오답 정리', '책상 정리', '짧은 모의 문제'],
    personThemes: ['스터디 메모', '질문 메모', '피드백 메모'],
    reflectionTemplates: [
      '오늘은 {mood}한 흐름으로 {todoTheme}를 끝냈다.',
      '{personTheme}를 남기니 {keyword}가 반복 신호로 더 잘 보였다.',
      '짧게라도 {todoTheme}를 지키며 하루의 결을 맞췄다.',
    ],
    profileNameKo: '학습 체험 사용자',
    profileInterestsKo: ['가상 공부 기록', '오답 정리', '꾸준한 복습'],
    profileContextKo: '실제 시험 정보가 아닌 학습 시뮬레이션 데이터예요.',
  ),
  LifeScenePreset(
    id: 'health-routine',
    displayNameKo: '운동/건강 루틴',
    descriptionKo: '몸을 조금씩 챙기면서 리듬을 만드는 장면이에요.',
    preferredRole: CompanionRole.coach,
    recurringKeywords: ['운동', '호흡', '수면', '루틴'],
    moodPattern: ['가벼움', '차분', '회복', '안정'],
    todoThemes: ['스트레칭', '물 마시기', '가벼운 산책', '수면 준비'],
    personThemes: ['루틴 메모', '회복 메모', '몸 상태 메모'],
    reflectionTemplates: [
      '오늘은 {mood}한 몸 상태를 따라가며 {todoTheme}를 챙겼다.',
      '{personTheme}를 적어두니 {keyword}가 자연스럽게 이어졌다.',
      '작은 루틴을 지키는 동안 마음도 함께 정돈됐다.',
    ],
    profileNameKo: '루틴 체험 사용자',
    profileInterestsKo: ['가상 건강 기록', '회복 루틴', '작은 운동'],
    profileContextKo: '실제 건강 정보가 아닌 루틴 시뮬레이션 데이터예요.',
  ),
  LifeScenePreset(
    id: 'burnout-recovery',
    displayNameKo: '번아웃 회복',
    descriptionKo: '에너지가 낮을 때, 다시 리듬을 찾는 장면이에요.',
    preferredRole: CompanionRole.friend,
    recurringKeywords: ['회복', '쉼', '호흡', '천천히'],
    moodPattern: ['느림', '무거움', '휴식', '안도'],
    todoThemes: ['휴식하기', '물 마시기', '짧게 걷기', '일찍 잠들기'],
    personThemes: ['회복 메모', '쉼 메모', '조용한 메모'],
    reflectionTemplates: [
      '오늘은 {mood}한 흐름이었지만 {todoTheme}를 해내며 버텼다.',
      '{personTheme}를 남기니 {keyword}가 회복의 힌트처럼 보였다.',
      '무리하지 않고 {todoTheme}를 선택한 것이 오늘의 핵심이었다.',
    ],
    profileNameKo: '회복 체험 사용자',
    profileInterestsKo: ['가상 회복 기록', '쉼의 리듬', '작은 회복'],
    profileContextKo: '실제 심리 정보가 아닌 회복 시뮬레이션 데이터예요.',
  ),
  LifeScenePreset(
    id: 'relationship-concern',
    displayNameKo: '관계 고민',
    descriptionKo: '사람 사이의 거리와 말을 다시 생각하는 장면이에요.',
    preferredRole: CompanionRole.listener,
    recurringKeywords: ['관계', '대화', '거리', '이해'],
    moodPattern: ['조심', '생각', '머뭇', '정리'],
    todoThemes: ['대화 정리', '마음 메모', '답장 생각', '거리 두기'],
    personThemes: ['관계 메모', '대화 메모', '기억 메모'],
    reflectionTemplates: [
      '오늘은 {mood}한 마음으로 {personTheme}를 다시 바라봤다.',
      '{todoTheme}를 적어두니 {keyword} 신호가 조금 더 또렷해졌다.',
      '조금씩 정리해보니 마음이 덜 복잡해졌다.',
    ],
    profileNameKo: '관계 체험 사용자',
    profileInterestsKo: ['가상 관계 기록', '대화 정리', '천천히 보기'],
    profileContextKo: '실제 관계 정보가 아닌 가상 관계 시뮬레이션 데이터예요.',
  ),
  LifeScenePreset(
    id: 'goal-coaching',
    displayNameKo: '목표 달성 코칭',
    descriptionKo: '목표를 작게 쪼개서 끝까지 가보는 장면이에요.',
    preferredRole: CompanionRole.coach,
    recurringKeywords: ['목표', '실행', '점검', '달성'],
    moodPattern: ['단단', '집중', '성실', '명료'],
    todoThemes: ['첫 행동', '중간 점검', '작은 완료', '내일 계획'],
    personThemes: ['코칭 메모', '점검 메모', '실행 메모'],
    reflectionTemplates: [
      '오늘은 {mood}한 흐름으로 {todoTheme}를 마쳤다.',
      '{personTheme}를 남기니 {keyword}가 다음 행동을 더 선명하게 했다.',
      '작은 완료를 쌓아가며 하루의 방향이 또렷해졌다.',
    ],
    profileNameKo: '목표 체험 사용자',
    profileInterestsKo: ['가상 목표 기록', '실행 계획', '작은 완료'],
    profileContextKo: '실제 목표 정보가 아닌 코칭 시뮬레이션 데이터예요.',
  ),
  LifeScenePreset(
    id: 'quiet-listening',
    displayNameKo: '조용히 들어주는 날',
    descriptionKo: '말보다 듣는 쪽이 더 편한 장면이에요.',
    preferredRole: CompanionRole.listener,
    recurringKeywords: ['경청', '침묵', '질문', '정리'],
    moodPattern: ['잔잔', '느긋', '차분', '정돈'],
    todoThemes: ['메모 멈추기', '숨 고르기', '질문 적기', '한 줄 정리'],
    personThemes: ['경청 메모', '조용한 메모', '한 줄 메모'],
    reflectionTemplates: [
      '오늘은 {mood}하게 흘러가며 {personTheme}를 천천히 남겼다.',
      '{todoTheme}를 통해 {keyword}가 하루의 중심에 남았다.',
      '조용히 정리해보니 마음의 결이 더 또렷해졌다.',
    ],
    profileNameKo: '경청 체험 사용자',
    profileInterestsKo: ['가상 경청 기록', '짧은 질문', '조용한 정리'],
    profileContextKo: '실제 개인정보가 아닌 경청 시뮬레이션 데이터예요.',
  ),
  LifeScenePreset(
    id: 'new-challenge',
    displayNameKo: '새로운 도전 준비',
    descriptionKo: '낯선 시작을 앞두고 기대와 긴장이 같이 있는 장면이에요.',
    preferredRole: CompanionRole.friend,
    recurringKeywords: ['도전', '준비', '긴장', '시작'],
    moodPattern: ['설렘', '긴장', '명료', '도전'],
    todoThemes: ['준비물 확인', '첫 일정 보기', '가벼운 연습', '내일 정리'],
    personThemes: ['도전 메모', '준비 메모', '응원 메모'],
    reflectionTemplates: [
      '오늘은 {mood}한 마음으로 {todoTheme}를 정리했다.',
      '{personTheme}를 적어두니 {keyword}가 더 이상 멀지 않게 느껴졌다.',
      '작은 준비를 쌓으며 새로운 시작을 받아들였다.',
    ],
    profileNameKo: '도전 체험 사용자',
    profileInterestsKo: ['가상 도전 기록', '새로운 시작', '가벼운 준비'],
    profileContextKo: '실제 도전 정보가 아닌 가상 준비 시뮬레이션 데이터예요.',
  ),
  LifeScenePreset(
    id: 'weekend-recovery',
    displayNameKo: '주말 회복 모드',
    descriptionKo: '한 주를 정리하고 다음 주를 가볍게 맞이하는 장면이에요.',
    preferredRole: CompanionRole.family,
    recurringKeywords: ['주말', '회복', '정리', '휴식'],
    moodPattern: ['느긋', '편안', '차분', '회복'],
    todoThemes: ['방 정리', '천천히 산책', '장보기 메모', '다음 주 준비'],
    personThemes: ['주말 메모', '휴식 메모', '정리 메모'],
    reflectionTemplates: [
      '오늘은 {mood}한 주말 흐름 속에서 {todoTheme}를 챙겼다.',
      '{personTheme}를 보며 {keyword}가 다음 주 준비로 이어졌다.',
      '쉬는 시간에 작은 정리를 더해 마음도 함께 회복됐다.',
    ],
    profileNameKo: '주말 체험 사용자',
    profileInterestsKo: ['가상 주말 기록', '회복 루틴', '다음 주 준비'],
    profileContextKo: '실제 생활 정보가 아닌 주말 시뮬레이션 데이터예요.',
  ),
];

class SyntheticGrowthSimulationService {
  const SyntheticGrowthSimulationService();

  SyntheticGrowthSimulationSession generate({
    required LifeScenePreset scene,
    int dayCount = 100,
    CompanionRole? role,
    DateTime? generatedAt,
  }) {
    final safeDayCount = dayCount < 1 ? 1 : dayCount;
    final now = (generatedAt ?? DateTime.now()).toUtc();
    final activeRole = role ?? scene.preferredRole;
    final preference = CompanionPreference(
      defaultRole: activeRole,
      responseLength: CompanionResponseLength.long,
      affectionLevel: _affectionFor(activeRole),
      directnessLevel: _directnessFor(activeRole),
      avoidPhrases: const [],
      customRoleName: activeRole == CompanionRole.custom ? '시뮬레이션 동행' : '',
      customToneHint: activeRole == CompanionRole.custom
          ? '가볍고 따뜻한 한국어 응원'
          : '',
    );

    final profile = LocalUserProfile(
      displayName: scene.profileNameKo,
      interests: scene.profileInterestsKo,
      importantContext: scene.profileContextKo,
    );

    final entries = <DailyReflectionEntry>[];
    final people = _buildPeople(scene);
    final todos = _buildTodos(scene);
    final memoryItems = _buildMemoryItems(scene, profile, people, todos);
    final recurringKeywords = <String, int>{};

    for (var index = 0; index < safeDayCount; index += 1) {
      final dayIndex = index + 1;
      final day = now.subtract(Duration(days: safeDayCount - dayIndex));
      final mood = scene.moodPattern[index % scene.moodPattern.length];
      final keyword =
          scene.recurringKeywords[index % scene.recurringKeywords.length];
      final todoTheme = scene.todoThemes[index % scene.todoThemes.length];
      final personTheme = scene.personThemes[index % scene.personThemes.length];
      final template =
          scene.reflectionTemplates[index % scene.reflectionTemplates.length];
      final summary = _composeReflection(
        template: template,
        mood: mood,
        keyword: keyword,
        todoTheme: todoTheme,
        personTheme: personTheme,
        dayIndex: dayIndex,
      );
      final tags = <String>[keyword, mood, todoTheme, personTheme, '100일 성장'];

      entries.add(
        DailyReflectionEntry(
          id: 'sim-${scene.id}-entry-$dayIndex',
          summary: summary,
          tags: tags,
          createdAt: day,
        ),
      );

      for (final tag in tags) {
        recurringKeywords[tag] = (recurringKeywords[tag] ?? 0) + 1;
      }
    }

    final snapshot = LocalMemorySnapshot(
      consentSettings: ConsentSettings.allEnabled(),
      companionPreference: preference,
      profile: profile,
      dailyEntries: entries,
      memoryItems: memoryItems,
      people: people,
      todos: todos,
      recurringKeywords: recurringKeywords,
    );

    return SyntheticGrowthSimulationSession(
      presetId: scene.id,
      generatedAt: now,
      dayCount: safeDayCount,
      snapshot: snapshot,
    );
  }

  List<PersonMemory> _buildPeople(LifeScenePreset scene) {
    final people = <PersonMemory>[];
    for (var index = 0; index < scene.personThemes.length; index += 1) {
      final theme = scene.personThemes[index];
      people.add(
        PersonMemory(
          id: '${scene.id}-person-${index + 1}',
          label: '$theme ${index + 1}',
          note: '${scene.displayNameKo}에서 $theme를 반복해서 기억해둔 가상 메모예요.',
          createdAt: DateTime.utc(2026, 1, index + 1),
        ),
      );
    }
    return people;
  }

  List<TodoMemory> _buildTodos(LifeScenePreset scene) {
    final todos = <TodoMemory>[];
    for (var index = 0; index < scene.todoThemes.length; index += 1) {
      final theme = scene.todoThemes[index];
      todos.add(
        TodoMemory(
          id: '${scene.id}-todo-${index + 1}',
          title: '$theme ${index + 1}',
          createdAt: DateTime.utc(2026, 2, index + 1),
        ),
      );
    }
    return todos;
  }

  List<MemoryItem> _buildMemoryItems(
    LifeScenePreset scene,
    LocalUserProfile profile,
    List<PersonMemory> people,
    List<TodoMemory> todos,
  ) {
    return [
      MemoryItem(
        id: '${scene.id}-memory-profile',
        category: MemoryCategory.profile,
        label: profile.displayName,
        createdAt: DateTime.utc(2026, 3, 1),
      ),
      MemoryItem(
        id: '${scene.id}-memory-people',
        category: MemoryCategory.people,
        label: '${scene.displayNameKo} 사람 메모 ${people.length}개',
        createdAt: DateTime.utc(2026, 3, 2),
      ),
      MemoryItem(
        id: '${scene.id}-memory-todos',
        category: MemoryCategory.todos,
        label: '${scene.displayNameKo} 할 일 메모 ${todos.length}개',
        createdAt: DateTime.utc(2026, 3, 3),
      ),
      MemoryItem(
        id: '${scene.id}-memory-entries',
        category: MemoryCategory.reflectionEntries,
        label: '${scene.displayNameKo} 하루 기록 ${100}일',
        createdAt: DateTime.utc(2026, 3, 4),
      ),
      MemoryItem(
        id: '${scene.id}-memory-keywords',
        category: MemoryCategory.recurringKeywords,
        label: '${scene.recurringKeywords.first} 외 반복 신호',
        createdAt: DateTime.utc(2026, 3, 5),
      ),
    ];
  }

  String _composeReflection({
    required String template,
    required String mood,
    required String keyword,
    required String todoTheme,
    required String personTheme,
    required int dayIndex,
  }) {
    return template
        .replaceAll('{mood}', mood)
        .replaceAll('{keyword}', keyword)
        .replaceAll('{todoTheme}', todoTheme)
        .replaceAll('{personTheme}', personTheme)
        .replaceAll('{dayIndex}', '$dayIndex');
  }

  int _affectionFor(CompanionRole role) {
    switch (role) {
      case CompanionRole.lover:
        return 4;
      case CompanionRole.family:
      case CompanionRole.parent:
        return 3;
      case CompanionRole.listener:
        return 2;
      case CompanionRole.custom:
      case CompanionRole.friend:
      case CompanionRole.coach:
      case CompanionRole.teacher:
        return 3;
    }
  }

  int _directnessFor(CompanionRole role) {
    switch (role) {
      case CompanionRole.coach:
      case CompanionRole.teacher:
        return 4;
      case CompanionRole.parent:
        return 3;
      case CompanionRole.listener:
        return 1;
      case CompanionRole.lover:
      case CompanionRole.family:
      case CompanionRole.friend:
      case CompanionRole.custom:
        return 2;
    }
  }
}
