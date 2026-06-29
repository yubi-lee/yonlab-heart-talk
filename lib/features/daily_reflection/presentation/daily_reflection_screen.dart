import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../application/companion_message_service.dart';
import '../application/growth_calculator.dart';
import '../application/local_insight_service.dart';
import '../application/local_memory_management_service.dart';
import '../application/morning_brief_service.dart';
import '../application/rule_based_reflection_engine.dart';
import '../data/demo_reflection_repository.dart';
import '../data/local_memory_repository.dart';
import '../data/shared_preferences_memory_repository.dart';
import '../domain/companion_models.dart';
import '../domain/local_insight_models.dart';
import '../domain/local_memory_models.dart';
import '../domain/morning_brief_models.dart';
import '../domain/reflection_models.dart';

class DailyReflectionScreen extends StatefulWidget {
  const DailyReflectionScreen({super.key});

  @override
  State<DailyReflectionScreen> createState() => _DailyReflectionScreenState();
}

class _DailyReflectionScreenState extends State<DailyReflectionScreen> {
  final _repository = const DemoReflectionRepository();
  final _engine = RuleBasedReflectionEngine();
  final _growthCalculator = const GrowthCalculator();
  final _messageService = const CompanionMessageService();
  final _insightService = const LocalInsightService();
  final _memoryManagementService = const LocalMemoryManagementService();
  final _morningBriefService = const MorningBriefService();
  final _controller = TextEditingController();
  final _profileNameController = TextEditingController();
  final _todoMemoryController = TextEditingController();
  final _personMemoryController = TextEditingController();

  LocalMemoryRepository? _memoryRepository;
  ReflectionSessionState _session = const ReflectionSessionState();
  LocalMemorySnapshot _memorySnapshot = LocalMemorySnapshot.empty();

  List<DemoReflectionEvent> get _events => _repository.listEvents();
  CompanionGrowthState get _growthState =>
      _growthCalculator.calculate(_memorySnapshot);

  @override
  void initState() {
    super.initState();
    _loadMemoryRepository();
  }

  @override
  void dispose() {
    _controller.dispose();
    _profileNameController.dispose();
    _todoMemoryController.dispose();
    _personMemoryController.dispose();
    super.dispose();
  }

  Future<void> _loadMemoryRepository() async {
    final preferences = await SharedPreferences.getInstance();
    final repository = SharedPreferencesLocalMemoryRepository(preferences);
    final snapshot = await repository.loadSnapshot();
    if (!mounted) {
      return;
    }
    setState(() {
      _memoryRepository = repository;
      _memorySnapshot = snapshot;
      _profileNameController.text = snapshot.profile.displayName;
    });
  }

  Future<void> _persistMemory(LocalMemorySnapshot snapshot) async {
    final repository = _memoryRepository;
    final sanitized = sanitizeSnapshotForConsent(snapshot);
    setState(() {
      _memorySnapshot = sanitized;
    });
    if (repository != null) {
      await repository.saveSnapshot(sanitized);
    }
  }

  Future<void> _toggleLocalMemory(bool enabled) async {
    final nextConsent = enabled
        ? ConsentSettings.allEnabled()
        : ConsentSettings.disabled();
    final nextSnapshot = _memorySnapshot.copyWith(consentSettings: nextConsent);
    await _persistMemory(nextSnapshot);
  }

  Future<void> _selectRole(CompanionRole role) async {
    final nextSnapshot = _memorySnapshot.copyWith(
      companionPreference: _memorySnapshot.companionPreference.copyWith(
        defaultRole: role,
      ),
    );
    await _persistMemory(nextSnapshot);
  }

  Future<void> _saveMemoryInputs() async {
    final now = DateTime.now().toUtc();
    final profileName = _profileNameController.text.trim();
    final todoTitle = _todoMemoryController.text.trim();
    final personNote = _personMemoryController.text.trim();

    final todos = [..._memorySnapshot.todos];
    if (todoTitle.isNotEmpty) {
      todos.add(
        TodoMemory(
          id: 'todo-${now.microsecondsSinceEpoch}',
          title: todoTitle,
          createdAt: now,
        ),
      );
      _todoMemoryController.clear();
    }

    final people = [..._memorySnapshot.people];
    if (personNote.isNotEmpty) {
      final parts = personNote.split(':');
      final label = parts.first.trim().isEmpty ? '관계 메모' : parts.first.trim();
      final note = parts.length > 1
          ? parts.sublist(1).join(':').trim()
          : personNote;
      people.add(
        PersonMemory(
          id: 'person-${now.microsecondsSinceEpoch}',
          label: label,
          note: note,
          createdAt: now,
        ),
      );
      _personMemoryController.clear();
    }

    final nextSnapshot = _memorySnapshot.copyWith(
      profile: LocalUserProfile(displayName: profileName),
      todos: todos,
      people: people,
    );
    await _persistMemory(nextSnapshot);
  }

  Future<void> _updateProfileDisplayName(String displayName) async {
    final nextSnapshot = _memoryManagementService.updateProfileDisplayName(
      _memorySnapshot,
      displayName,
    );
    _profileNameController.text = nextSnapshot.profile.displayName;
    await _persistMemory(nextSnapshot);
  }

  Future<void> _updateTodoTitle(String todoId, String title) async {
    final nextSnapshot = _memoryManagementService.updateTodoTitle(
      _memorySnapshot,
      todoId: todoId,
      title: title,
    );
    await _persistMemory(nextSnapshot);
  }

  Future<void> _deleteTodo(String todoId) async {
    final nextSnapshot = _memoryManagementService.deleteTodo(
      _memorySnapshot,
      todoId: todoId,
    );
    await _persistMemory(nextSnapshot);
  }

  Future<void> _updatePerson(String personId, String label, String note) async {
    final nextSnapshot = _memoryManagementService.updatePerson(
      _memorySnapshot,
      personId: personId,
      label: label,
      note: note,
    );
    await _persistMemory(nextSnapshot);
  }

  Future<void> _deletePerson(String personId) async {
    final nextSnapshot = _memoryManagementService.deletePerson(
      _memorySnapshot,
      personId: personId,
    );
    await _persistMemory(nextSnapshot);
  }

  Future<void> _deleteReflectionEntry(String entryId) async {
    final nextSnapshot = _memoryManagementService.deleteReflectionEntry(
      _memorySnapshot,
      entryId: entryId,
    );
    await _persistMemory(nextSnapshot);
  }

  Future<void> _clearAllMemory() async {
    final repository = _memoryRepository;
    if (repository != null) {
      await repository.clearAll();
    }
    setState(() {
      _memorySnapshot = LocalMemorySnapshot.empty();
      _profileNameController.clear();
      _todoMemoryController.clear();
      _personMemoryController.clear();
    });
  }

  void _selectEvent(DemoReflectionEvent event) {
    setState(() {
      _controller.text = event.text;
      _session = ReflectionSessionState(
        selectedEvent: event,
        result: _engine.generate(
          ReflectionInput(
            text: event.text,
            source: ReflectionInputSource.demo,
            demoEventId: event.id,
          ),
        ),
      );
    });
  }

  void _generateFromManualText() {
    setState(() {
      _session = ReflectionSessionState(
        result: _engine.generate(
          ReflectionInput(
            text: _controller.text,
            source: ReflectionInputSource.manual,
          ),
        ),
      );
    });
  }

  Future<void> _keep() async {
    if (!_session.hasPreview) {
      return;
    }
    setState(() {
      _session = _session.copyWith(isKept: true);
    });

    final summary = _session.result?.summary;
    if (summary == null ||
        !_memorySnapshot.consentSettings.localMemoryEnabled) {
      return;
    }

    final now = DateTime.now().toUtc();
    final recurringKeywords = Map<String, int>.from(
      _memorySnapshot.recurringKeywords,
    );
    for (final tag in _session.selectedEvent?.tags ?? const <String>[]) {
      if (tag == 'demo') {
        continue;
      }
      recurringKeywords[tag] = (recurringKeywords[tag] ?? 0) + 1;
    }

    final nextSnapshot = _memorySnapshot.copyWith(
      dailyEntries: [
        ..._memorySnapshot.dailyEntries,
        DailyReflectionEntry(
          id: 'entry-${now.microsecondsSinceEpoch}',
          summary: summary.todayFlow,
          tags: _session.selectedEvent?.tags ?? const [],
          createdAt: now,
        ),
      ],
      recurringKeywords: recurringKeywords,
    );
    await _persistMemory(nextSnapshot);
  }

  void _reset() {
    setState(() {
      _controller.clear();
      _session = const ReflectionSessionState();
    });
  }

  @override
  Widget build(BuildContext context) {
    final result = _session.result;
    final summary = result?.summary;
    final morningDraft = result?.morningDraft;
    final showMorningBriefing =
        _session.shouldShowMorningBriefing && morningDraft != null;
    final companionMessage = summary == null
        ? null
        : _messageService.generateMessage(
            preference: _memorySnapshot.companionPreference,
            growthState: _growthState,
            reflectionSummary: summary.todayFlow,
          );
    final localInsight = _insightService.generate(
      snapshot: _memorySnapshot,
      preference: _memorySnapshot.companionPreference,
      growthState: _growthState,
    );
    final morningBrief = _morningBriefService.generate(
      snapshot: _memorySnapshot,
      insight: localInsight,
      preference: _memorySnapshot.companionPreference,
      growthState: _growthState,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('HeartTalk 하루 대화')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '기기 안에서만 이어지는 하루 대화예요. 오늘을 다정하게 정리하고, 내일의 작은 시작도 함께 꺼내볼 수 있어요.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              _InfoPanel(
                title: '사생활을 지키는 대화',
                children: const [
                  '이 MVP는 통화, 문자, 메신저, 알림, 음성, PPG, 연락처, 위치, 건강 정보를 읽지 않아요.',
                  '직접 적는 짧은 문장이나 안전한 데모 예시만 사용해 주세요.',
                  '처리는 기기 안에서만 이뤄지고 Cloud AI, 분석, 동기화, 외부 데이터베이스, 추가 권한 요청은 없어요.',
                ],
              ),
              const SizedBox(height: 16),
              Text('안전한 데모 예시', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final event in _events)
                    ChoiceChip(
                      label: Text(event.title),
                      selected: _session.selectedEvent?.id == event.id,
                      onSelected: (_) => _selectEvent(event),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                key: const Key('reflectionNoteField'),
                controller: _controller,
                minLines: 3,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: '오늘 있었던 일 한 줄',
                  hintText: '오늘 있었던 일을 짧고 편하게 적어보세요.',
                  helperText: '실제 개인정보, 건강 정보, 전화번호, 사적인 대화 전문은 적지 마세요.',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              FilledButton(
                key: const Key('generateButton'),
                onPressed: _generateFromManualText,
                child: const Text('대화 만들기'),
              ),
              const SizedBox(height: 16),
              _LocalMemoryPanel(
                snapshot: _memorySnapshot,
                growthState: _growthState,
                insight: localInsight,
                morningBrief: morningBrief,
                profileNameController: _profileNameController,
                todoMemoryController: _todoMemoryController,
                personMemoryController: _personMemoryController,
                onConsentChanged: _toggleLocalMemory,
                onRoleSelected: _selectRole,
                onSaveMemory: _saveMemoryInputs,
                onClearAll: _clearAllMemory,
                onUpdateProfileName: _updateProfileDisplayName,
                onUpdateTodo: _updateTodoTitle,
                onDeleteTodo: _deleteTodo,
                onUpdatePerson: _updatePerson,
                onDeletePerson: _deletePerson,
                onDeleteReflectionEntry: _deleteReflectionEntry,
              ),
              if (result?.validationMessage != null) ...[
                const SizedBox(height: 12),
                Text(
                  result!.validationMessage!,
                  key: const Key('validationMessage'),
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ],
              if (summary != null && morningDraft != null) ...[
                const SizedBox(height: 16),
                _InfoPanel(
                  title: '대화 미리보기',
                  children: [summary.preview, '입력 방식: ${summary.sourceLabel}'],
                ),
                if (companionMessage != null) ...[
                  const SizedBox(height: 12),
                  _InfoPanel(title: '오늘의 한마디', children: [companionMessage]),
                ],
                const SizedBox(height: 12),
                _InfoPanel(
                  title: '오늘의 대화 카드',
                  children: [
                    '오늘의 흐름: ${summary.todayFlow}',
                    '눈에 띈 신호: ${summary.observedCue}',
                    '내일로 남긴 흐름: ${summary.leftForTomorrow}',
                    '내일의 시작: ${summary.tomorrowLine}',
                  ],
                ),
                const SizedBox(height: 12),
                if (showMorningBriefing)
                  _InfoPanel(
                    title: '내일 시작 메모',
                    children: [
                      '시작 한마디: ${morningDraft.startLine}',
                      '가장 먼저 할 일: ${morningDraft.firstThing}',
                      '톤 가이드: ${morningDraft.toneHint}',
                    ],
                  )
                else
                  const Text(
                    '이 대화를 아끼면 내일 시작 메모가 아래 보여요',
                    key: Key('morningBriefingLockedMessage'),
                  ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    FilledButton.tonal(
                      key: const Key('keepButton'),
                      onPressed: _keep,
                      child: const Text('내일로 아끼기'),
                    ),
                    OutlinedButton(
                      key: const Key('resetButton'),
                      onPressed: _reset,
                      child: const Text('지우고 다시 쓰기'),
                    ),
                  ],
                ),
                if (_session.isKept) ...[
                  const SizedBox(height: 8),
                  const Text(
                    '기기 안에 기억하기를 켜지 않으면 이번 실행 동안만 남아요.',
                    key: Key('keptMessage'),
                  ),
                ],
              ] else ...[
                const SizedBox(height: 16),
                const Text('아직 대화를 만들지 않았어요.', key: Key('emptyState')),
                const SizedBox(height: 4),
                const Text(
                  '아직 내일 시작 메모가 없어요.',
                  key: Key('morningBriefingEmptyMessage'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _LocalMemoryPanel extends StatelessWidget {
  const _LocalMemoryPanel({
    required this.snapshot,
    required this.growthState,
    required this.insight,
    required this.morningBrief,
    required this.profileNameController,
    required this.todoMemoryController,
    required this.personMemoryController,
    required this.onConsentChanged,
    required this.onRoleSelected,
    required this.onSaveMemory,
    required this.onClearAll,
    required this.onUpdateProfileName,
    required this.onUpdateTodo,
    required this.onDeleteTodo,
    required this.onUpdatePerson,
    required this.onDeletePerson,
    required this.onDeleteReflectionEntry,
  });

  final LocalMemorySnapshot snapshot;
  final CompanionGrowthState growthState;
  final LocalInsightSummary insight;
  final MorningBrief morningBrief;
  final TextEditingController profileNameController;
  final TextEditingController todoMemoryController;
  final TextEditingController personMemoryController;
  final ValueChanged<bool> onConsentChanged;
  final ValueChanged<CompanionRole> onRoleSelected;
  final VoidCallback onSaveMemory;
  final VoidCallback onClearAll;
  final ValueChanged<String> onUpdateProfileName;
  final Future<void> Function(String todoId, String title) onUpdateTodo;
  final Future<void> Function(String todoId) onDeleteTodo;
  final Future<void> Function(String personId, String label, String note)
  onUpdatePerson;
  final Future<void> Function(String personId) onDeletePerson;
  final Future<void> Function(String entryId) onDeleteReflectionEntry;
  String _signalLine(List<RecurringSignal> signals) {
    if (signals.isEmpty) {
      return '반복 신호: 아직 없어요.';
    }
    return '반복 신호: ${signals.map((signal) => '${signal.label}(${signal.count})').join(', ')}';
  }

  int get _profileCount => snapshot.profile.displayName.trim().isEmpty ? 0 : 1;

  Future<void> _showEditProfileDialog(BuildContext context) async {
    final controller = TextEditingController(
      text: snapshot.profile.displayName.trim(),
    );
    final shouldSave = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('내 소개 수정'),
          content: TextField(
            key: const Key('editProfileNameField'),
            controller: controller,
            decoration: const InputDecoration(
              labelText: '닉네임',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('취소'),
            ),
            FilledButton(
              key: const Key('confirmEditProfileButton'),
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('저장'),
            ),
          ],
        );
      },
    );

    if (shouldSave == true) {
      onUpdateProfileName(controller.text);
    }
  }

  Future<void> _showEditTodoDialog(
    BuildContext context,
    TodoMemory todo,
  ) async {
    final controller = TextEditingController(text: todo.title);
    final shouldSave = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('내일 할 일 수정'),
          content: TextField(
            key: const Key('editTodoTitleField'),
            controller: controller,
            decoration: const InputDecoration(
              labelText: '할 일',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('취소'),
            ),
            FilledButton(
              key: const Key('confirmEditTodoButton'),
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('저장'),
            ),
          ],
        );
      },
    );

    if (shouldSave == true) {
      await onUpdateTodo(todo.id, controller.text);
    }
  }

  Future<void> _showEditPersonDialog(
    BuildContext context,
    PersonMemory person,
  ) async {
    final labelController = TextEditingController(text: person.label);
    final noteController = TextEditingController(text: person.note);
    final shouldSave = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('기억할 사람 수정'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                key: const Key('editPersonLabelField'),
                controller: labelController,
                decoration: const InputDecoration(
                  labelText: '이름 또는 관계',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                key: const Key('editPersonNoteField'),
                controller: noteController,
                minLines: 2,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: '硫붾え',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('취소'),
            ),
            FilledButton(
              key: const Key('confirmEditPersonButton'),
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('저장'),
            ),
          ],
        );
      },
    );

    if (shouldSave == true) {
      await onUpdatePerson(
        person.id,
        labelController.text,
        noteController.text,
      );
    }
  }

  Widget _buildProfileSection(BuildContext context) {
    return _MemoryCategorySection(
      title: '내 소개',
      count: _profileCount,
      child: _profileCount == 0
          ? const Text('아직 저장된 내 소개가 없어요.')
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text('닉네임: ${snapshot.profile.displayName.trim()}'),
                ),
                TextButton(
                  key: const Key('editProfileButton'),
                  onPressed: () {
                    _showEditProfileDialog(context);
                  },
                  child: const Text('수정'),
                ),
              ],
            ),
    );
  }

  Widget _buildPeopleSection(BuildContext context) {
    return _MemoryCategorySection(
      title: '기억할 사람',
      count: snapshot.people.length,
      child: snapshot.people.isEmpty
          ? const Text('아직 저장된 사람이 없어요.')
          : Column(
              children: [
                for (var index = 0; index < snapshot.people.length; index += 1)
                  _MemoryItemRow(
                    title: snapshot.people[index].label,
                    subtitle: snapshot.people[index].note,
                    editKey: Key('editPersonButton-$index'),
                    deleteKey: Key('deletePersonButton-$index'),
                    onEdit: () {
                      _showEditPersonDialog(context, snapshot.people[index]);
                    },
                    onDelete: () async {
                      await onDeletePerson(snapshot.people[index].id);
                    },
                  ),
              ],
            ),
    );
  }

  Widget _buildTodoSection(BuildContext context) {
    return _MemoryCategorySection(
      title: '내일 할 일',
      count: snapshot.todos.length,
      child: snapshot.todos.isEmpty
          ? const Text('아직 저장된 할 일이 없어요.')
          : Column(
              children: [
                for (var index = 0; index < snapshot.todos.length; index += 1)
                  _MemoryItemRow(
                    title: snapshot.todos[index].title,
                    editKey: Key('editTodoButton-$index'),
                    deleteKey: Key('deleteTodoButton-$index'),
                    onEdit: () {
                      _showEditTodoDialog(context, snapshot.todos[index]);
                    },
                    onDelete: () async {
                      await onDeleteTodo(snapshot.todos[index].id);
                    },
                  ),
              ],
            ),
    );
  }

  Widget _buildReflectionSection() {
    return _MemoryCategorySection(
      title: '하루 기록',
      count: snapshot.dailyEntries.length,
      child: snapshot.dailyEntries.isEmpty
          ? const Text('아직 저장된 하루 기록이 없어요.')
          : Column(
              children: [
                for (
                  var index = 0;
                  index < snapshot.dailyEntries.length;
                  index += 1
                )
                  _MemoryItemRow(
                    title: snapshot.dailyEntries[index].summary,
                    subtitle: snapshot.dailyEntries[index].tags.isEmpty
                        ? null
                        : '태그: ${snapshot.dailyEntries[index].tags.join(', ')}',
                    deleteKey: Key('deleteReflectionButton-$index'),
                    onDelete: () async {
                      await onDeleteReflectionEntry(
                        snapshot.dailyEntries[index].id,
                      );
                    },
                  ),
              ],
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _InfoPanel(
      title: '기기 안에 기억하기',
      childrenWidgets: [
        Text(morningBrief.title, key: const Key('morningBriefTitle')),
        const SizedBox(height: 4),
        Text(morningBrief.greeting),
        const SizedBox(height: 4),
        Text(morningBrief.carryOverLine),
        const SizedBox(height: 4),
        Text('오늘의 질문: ${morningBrief.todayQuestion.text}'),
        Text('${morningBrief.firstStep.title}: ${morningBrief.firstStep.body}'),
        Text(morningBrief.roleMessage),
        const SizedBox(height: 12),
        SwitchListTile(
          key: const Key('localMemoryConsentSwitch'),
          contentPadding: EdgeInsets.zero,
          title: const Text('동의한 정보만 기기 안에 기억해요'),
          subtitle: const Text(
            '내 소개, 하루 기록, 기억할 사람, 내일 할 일, 반복 키워드를 동의한 경우에만 저장해요.',
          ),
          value: snapshot.consentSettings.localMemoryEnabled,
          onChanged: onConsentChanged,
        ),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: [
            for (final role in CompanionRole.values)
              ChoiceChip(
                key: Key('roleChip-${role.name}'),
                label: Text(role.koreanLabel),
                selected: snapshot.companionPreference.defaultRole == role,
                onSelected: (_) => onRoleSelected(role),
              ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          key: const Key('profileNameField'),
          controller: profileNameController,
          decoration: const InputDecoration(
            labelText: '내 소개',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          key: const Key('todoMemoryField'),
          controller: todoMemoryController,
          decoration: const InputDecoration(
            labelText: '내일 할 일',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          key: const Key('personMemoryField'),
          controller: personMemoryController,
          decoration: const InputDecoration(
            labelText: '기억할 사람',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            FilledButton.tonal(
              key: const Key('saveMemoryButton'),
              onPressed: onSaveMemory,
              child: const Text('기억 저장하기'),
            ),
            OutlinedButton(
              key: const Key('clearAllMemoryButton'),
              onPressed: onClearAll,
              child: const Text('저장된 기억 모두 지우기'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text('내 기억'),
        Text('대화 역할: ${snapshot.companionPreference.defaultRole.koreanLabel}'),
        Text(
          '내 소개: ${snapshot.profile.displayName.trim().isEmpty ? '-' : snapshot.profile.displayName.trim()}',
        ),
        Text('함께 알아가는 단계: ${growthState.level}'),
        Text('하루 기록: ${snapshot.dailyEntries.length}'),
        const SizedBox(height: 12),
        const Text('내 기억 관리', key: Key('memoryManagementTitle')),
        if (!snapshot.consentSettings.localMemoryEnabled)
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              '기기 안에 기억하기를 켜면 저장된 정보를 여기서 관리할 수 있어요.',
              key: Key('memoryConsentOffMessage'),
            ),
          )
        else ...[
          const SizedBox(height: 8),
          _buildProfileSection(context),
          const SizedBox(height: 8),
          _buildPeopleSection(context),
          const SizedBox(height: 8),
          _buildTodoSection(context),
          const SizedBox(height: 8),
          _buildReflectionSection(),
        ],
        const SizedBox(height: 8),
        Text(insight.patternTitle, key: const Key('localInsightTitle')),
        Text(insight.patternBody),
        Text(_signalLine(insight.recurringSignals)),
        Text('${insight.tomorrowHint.title}: ${insight.tomorrowHint.body}'),
        Text('질문: ${insight.curiosityQuestion.text}'),
        Text('${insight.tinyMission.title}: ${insight.tinyMission.body}'),
        Text(insight.roleMessage),
      ],
    );
  }
}

class _MemoryCategorySection extends StatelessWidget {
  const _MemoryCategorySection({
    required this.title,
    required this.count,
    required this.child,
  });

  final String title;
  final int count;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Text('$title ($count)'), const SizedBox(height: 8), child],
        ),
      ),
    );
  }
}

class _MemoryItemRow extends StatelessWidget {
  const _MemoryItemRow({
    required this.title,
    this.subtitle,
    this.editKey,
    this.deleteKey,
    this.onEdit,
    required this.onDelete,
  });

  final String title;
  final String? subtitle;
  final Key? editKey;
  final Key? deleteKey;
  final VoidCallback? onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title),
                if (subtitle != null && subtitle!.trim().isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(subtitle!),
                ],
              ],
            ),
          ),
          if (onEdit != null)
            TextButton(
              key: editKey,
              onPressed: onEdit,
              child: const Text('수정'),
            ),
          TextButton(
            key: deleteKey,
            onPressed: onDelete,
            child: const Text('삭제'),
          ),
        ],
      ),
    );
  }
}

class _InfoPanel extends StatelessWidget {
  const _InfoPanel({
    required this.title,
    this.children = const [],
    this.childrenWidgets = const [],
  });

  final String title;
  final List<String> children;
  final List<Widget> childrenWidgets;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            for (final child in children) ...[
              Text(child),
              const SizedBox(height: 4),
            ],
            ...childrenWidgets,
          ],
        ),
      ),
    );
  }
}
