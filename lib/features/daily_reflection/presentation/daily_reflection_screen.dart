import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../application/companion_message_service.dart';
import '../application/growth_calculator.dart';
import '../application/local_insight_service.dart';
import '../application/local_memory_management_service.dart';
import '../application/morning_brief_service.dart';
import '../application/rule_based_reflection_engine.dart';
import '../application/synthetic_growth_simulation_service.dart';
import '../data/demo_reflection_repository.dart';
import '../data/local_memory_repository.dart';
import '../data/synthetic_growth_simulation_repository.dart';
import '../data/shared_preferences_memory_repository.dart';
import '../domain/companion_models.dart';
import '../domain/local_insight_models.dart';
import '../domain/local_memory_models.dart';
import '../domain/morning_brief_models.dart';
import '../domain/synthetic_growth_simulation_models.dart';
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

  static const _onboardingSeenKey = 'heart_talk.first_run_onboarding_seen.v1';

  SharedPreferences? _preferences;
  bool _hasLoadedOnboardingState = false;
  bool _hasSeenOnboarding = false;

  LocalMemoryRepository? _memoryRepository;
  ReflectionSessionState _session = const ReflectionSessionState();
  LocalMemorySnapshot _memorySnapshot = LocalMemorySnapshot.empty();
  SyntheticGrowthSimulationRepository? _simulationRepository;
  SyntheticGrowthSimulationSession? _simulationSession;

  List<DemoReflectionEvent> get _events => _repository.listEvents();
  CompanionGrowthState get _growthState =>
      _growthCalculator.calculate(_memorySnapshot);

  @override
  void initState() {
    super.initState();
    _loadPersistentState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _profileNameController.dispose();
    _todoMemoryController.dispose();
    _personMemoryController.dispose();
    super.dispose();
  }

  Future<void> _loadPersistentState() async {
    final preferences = await SharedPreferences.getInstance();
    final repository = SharedPreferencesLocalMemoryRepository(preferences);
    final simulationRepository =
        SharedPreferencesSyntheticGrowthSimulationRepository(preferences);
    final onboardingSeen = preferences.getBool(_onboardingSeenKey) ?? false;
    final snapshot = await repository.loadSnapshot();
    final simulationSession = await simulationRepository.loadSession();
    if (!mounted) {
      return;
    }
    setState(() {
      _preferences = preferences;
      _memoryRepository = repository;
      _simulationRepository = simulationRepository;
      _memorySnapshot = snapshot;
      _simulationSession = simulationSession;
      _profileNameController.text = snapshot.profile.displayName;
      _hasLoadedOnboardingState = true;
      _hasSeenOnboarding = onboardingSeen;
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
    final simulationRepository = _simulationRepository;
    if (simulationRepository != null) {
      await simulationRepository.clearSession();
    }
    setState(() {
      _memorySnapshot = LocalMemorySnapshot.empty();
      _simulationSession = null;
      _profileNameController.clear();
      _todoMemoryController.clear();
      _personMemoryController.clear();
    });
  }

  Future<void> _markOnboardingSeen() async {
    final preferences = _preferences ?? await SharedPreferences.getInstance();
    await preferences.setBool(_onboardingSeenKey, true);
    if (!mounted) {
      return;
    }
    setState(() {
      _hasLoadedOnboardingState = true;
      _hasSeenOnboarding = true;
    });
  }

  Future<void> _showOnboardingHelp() async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            children: [
              _buildOnboardingGuide(sheetContext, showActions: false),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.of(sheetContext).pop(),
                  child: const Text('닫기'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOnboardingGuide(
    BuildContext context, {
    required bool showActions,
  }) {
    return _InfoPanel(
      title: '처음 실행 안내',
      childrenWidgets: [
        const Text('HeartTalk은 나를 기억하는 하루 친구예요.'),
        const SizedBox(height: 4),
        const Text('동의한 기억은 이 기기 안에만 저장돼요.'),
        const SizedBox(height: 4),
        const Text('오늘은 친구, 코치, 가족처럼 다른 말투로 함께할 수 있어요.'),
        const SizedBox(height: 4),
        const Text('기록이 쌓이면 오늘의 인사이트와 오늘 시작하기가 더 자연스러워져요.'),
        const SizedBox(height: 4),
        const Text('100일 성장 체험은 실제 개인정보가 아닌 가상 데이터 데모예요.'),
        const SizedBox(height: 4),
        const Text('저장된 기억은 언제든지 지울 수 있어요.'),
        if (showActions) ...[
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilledButton(
                key: const Key('onboardingStartButton'),
                onPressed: _markOnboardingSeen,
                child: const Text('시작하기'),
              ),
              OutlinedButton(
                key: const Key('onboardingAcknowledgeButton'),
                onPressed: _markOnboardingSeen,
                child: const Text('이해했어요'),
              ),
            ],
          ),
        ],
      ],
    );
  }

  LifeScenePreset? _simulationPreset() {
    final session = _simulationSession;
    if (session == null) {
      return null;
    }
    for (final preset in syntheticGrowthScenePresets) {
      if (preset.id == session.presetId) {
        return preset;
      }
    }
    return null;
  }

  Future<void> _startSimulation(LifeScenePreset preset) async {
    final session = const SyntheticGrowthSimulationService().generate(
      scene: preset,
      dayCount: 100,
    );
    final repository = _simulationRepository;
    if (repository != null) {
      await repository.saveSession(session);
    }
    if (!mounted) {
      return;
    }
    setState(() {
      _simulationSession = session;
    });
  }

  Future<void> _clearSimulation() async {
    final repository = _simulationRepository;
    if (repository != null) {
      await repository.clearSession();
    }
    if (!mounted) {
      return;
    }
    setState(() {
      _simulationSession = null;
    });
  }

  Future<void> _showSimulationPicker() async {
    final selectedPreset = await showModalBottomSheet<LifeScenePreset>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            children: [
              Text(
                '100일 성장 체험하기',
                style: Theme.of(sheetContext).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              const Text(
                '실제 기억과 섞이지 않는 가상 데이터예요. 씬을 골라 100일 성장 체험을 바로 시작할 수 있어요.',
              ),
              const SizedBox(height: 12),
              for (final preset in syntheticGrowthScenePresets) ...[
                ListTile(
                  title: Text(preset.displayNameKo),
                  subtitle: Text(preset.descriptionKo),
                  onTap: () => Navigator.of(sheetContext).pop(preset),
                ),
                const Divider(height: 1),
              ],
            ],
          ),
        );
      },
    );

    if (selectedPreset != null) {
      await _startSimulation(selectedPreset);
    }
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
    final simulationSession = _simulationSession;
    final simulationPreset = _simulationPreset();
    final simulationSnapshot = simulationSession?.snapshot;
    final simulationGrowthState = simulationSnapshot == null
        ? null
        : _growthCalculator.calculate(simulationSnapshot);
    final simulationInsight = simulationSnapshot == null
        ? null
        : _insightService.generate(
            snapshot: simulationSnapshot,
            preference: simulationSnapshot.companionPreference,
            growthState: simulationGrowthState!,
          );
    final simulationMorningBrief = simulationSnapshot == null
        ? null
        : _morningBriefService.generate(
            snapshot: simulationSnapshot,
            insight: simulationInsight!,
            preference: simulationSnapshot.companionPreference,
            growthState: simulationGrowthState!,
          );

    return Scaffold(
      appBar: AppBar(
        title: const Text('HeartTalk 하루 대화'),
        actions: [
          IconButton(
            tooltip: '도움말 다시 보기',
            icon: const Icon(Icons.help_outline),
            onPressed: _showOnboardingHelp,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_hasLoadedOnboardingState && !_hasSeenOnboarding) ...[
                _buildOnboardingGuide(context, showActions: true),
                const SizedBox(height: 16),
              ],
              Text(
                '기기 안에서만 이어지는 하루 대화예요. 오늘 기록을 남기고, 인사이트를 보고, 내일의 작은 시작까지 차분하게 이어가볼게요.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              _InfoPanel(
                title: '사생활을 지키는 대화',
                children: const [
                  '이 MVP는 통화, 문자, 메신저, 알림, 음성, PPG, 연락처, 위치, 건강 정보를 읽지 않아요.',
                  '직접 적는 짧은 문장과 안전한 데모 예시만 사용해 주세요.',
                  '모든 처리는 기기 안에서만 이뤄지고 Cloud AI, 분석, 동기화, 데이터베이스, 추가 권한 요청은 없어요.',
                ],
              ),
              const SizedBox(height: 16),
              _InfoPanel(
                title: '현재 companion 상태',
                childrenWidgets: [
                  Text(
                    _memorySnapshot.companionPreference.roleContextLine,
                    key: const Key('selectedRoleContextLine'),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '대화 역할: ${_memorySnapshot.companionPreference.roleDisplayName}',
                  ),
                  Text(
                    '내 소개: ${_memorySnapshot.profile.displayName.trim().isEmpty ? '-' : _memorySnapshot.profile.displayName.trim()}',
                  ),
                  Text('함께 알아가는 단계: ${_growthState.level}'),
                  Text('하루 기록: ${_memorySnapshot.dailyEntries.length}'),
                ],
              ),
              const SizedBox(height: 16),
              _SimulationPanel(
                preset: simulationPreset,
                session: simulationSession,
                growthState: simulationGrowthState,
                insight: simulationInsight,
                morningBrief: simulationMorningBrief,
                onStartSimulation: _showSimulationPicker,
                onClearSimulation: _clearSimulation,
              ),
              const SizedBox(height: 16),
              _InfoPanel(
                title: '기기 안에 기억하기',
                childrenWidgets: [
                  const Text('동의한 정보만 이 기기에 저장하고, 언제든 다시 지울 수 있어요.'),
                  const SizedBox(height: 12),
                  SwitchListTile(
                    key: const Key('localMemoryConsentSwitch'),
                    contentPadding: EdgeInsets.zero,
                    title: const Text('동의한 정보만 기기 안에 기억해요'),
                    subtitle: const Text(
                      '내 소개, 하루 기록, 기억할 사람, 내일 할 일, 반복 키워드를 동의한 경우에만 저장해요.',
                    ),
                    value: _memorySnapshot.consentSettings.localMemoryEnabled,
                    onChanged: _toggleLocalMemory,
                  ),
                  const SizedBox(height: 4),
                  Text('대화 역할', style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      for (final role in CompanionRole.values)
                        ChoiceChip(
                          key: Key('roleChip-${role.name}'),
                          label: Text(role.koreanLabel),
                          selected:
                              _memorySnapshot.companionPreference.defaultRole ==
                              role,
                          onSelected: (_) => _selectRole(role),
                        ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _InfoPanel(
                title: '오늘 기록하기',
                childrenWidgets: [
                  const Text('오늘 있었던 일과 기억하고 싶은 사람, 할 일을 가볍게 남겨보세요.'),
                  const SizedBox(height: 12),
                  Text(
                    '안전한 데모 예시',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
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
                  const SizedBox(height: 12),
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
                  const SizedBox(height: 8),
                  TextField(
                    key: const Key('profileNameField'),
                    controller: _profileNameController,
                    decoration: const InputDecoration(
                      labelText: '내 소개',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    key: const Key('personMemoryField'),
                    controller: _personMemoryController,
                    decoration: const InputDecoration(
                      labelText: '기억할 사람',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    key: const Key('todoMemoryField'),
                    controller: _todoMemoryController,
                    decoration: const InputDecoration(
                      labelText: '내일 할 일',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      FilledButton(
                        key: const Key('generateButton'),
                        onPressed: _generateFromManualText,
                        child: const Text('대화 만들기'),
                      ),
                      FilledButton.tonal(
                        key: const Key('saveMemoryButton'),
                        onPressed: _saveMemoryInputs,
                        child: const Text('기억 저장하기'),
                      ),
                    ],
                  ),
                ],
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

class _SimulationPanel extends StatelessWidget {
  const _SimulationPanel({
    required this.preset,
    required this.session,
    required this.growthState,
    required this.insight,
    required this.morningBrief,
    required this.onStartSimulation,
    required this.onClearSimulation,
  });

  final LifeScenePreset? preset;
  final SyntheticGrowthSimulationSession? session;
  final CompanionGrowthState? growthState;
  final LocalInsightSummary? insight;
  final MorningBrief? morningBrief;
  final Future<void> Function() onStartSimulation;
  final Future<void> Function() onClearSimulation;

  @override
  Widget build(BuildContext context) {
    final hasSession =
        preset != null &&
        session != null &&
        growthState != null &&
        insight != null &&
        morningBrief != null;
    final signalLine = insight == null || insight!.recurringSignals.isEmpty
        ? '아직 없어요'
        : insight!.recurringSignals.map((signal) => signal.label).join(', ');

    return _InfoPanel(
      title: '100일 성장 체험하기',
      childrenWidgets: [
        const Text('실제 기억과 섞이지 않는 가상 데이터예요. 선택한 씬으로 100일 성장 체험을 볼 수 있어요.'),
        const SizedBox(height: 8),
        if (!hasSession) ...[
          const Text('아직 체험 중인 씬이 없어요.'),
        ] else ...[
          Text(
            '씬: ${preset!.displayNameKo}',
            key: const Key('simulationSceneLine'),
          ),
          Text('설명: ${preset!.descriptionKo}'),
          Text('함께 알아가는 단계: ${growthState!.level}'),
          Text(
            '하루 기록 수: ${session!.snapshot.dailyEntries.length}',
            key: const Key('simulationDayCountLine'),
          ),
          Text('반복 신호: $signalLine'),
          Text(
            '오늘의 인사이트: ${insight!.patternTitle}',
            key: const Key('simulationInsightLine'),
          ),
          Text(
            '오늘 시작하기: ${morningBrief!.greeting}',
            key: const Key('simulationMorningBriefLine'),
          ),
          Text(
            '오늘의 질문: ${morningBrief!.todayQuestion.text}',
            key: const Key('simulationQuestionLine'),
          ),
          Text(
            '작은 미션: ${insight!.tinyMission.body}',
            key: const Key('simulationMissionLine'),
          ),
          Text('첫 번째 행동: ${morningBrief!.firstStep.body}'),
          Text('역할 메시지: ${morningBrief!.roleMessage}'),
        ],
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            FilledButton.tonal(
              key: const Key('startSimulationButton'),
              onPressed: () => onStartSimulation(),
              child: const Text('100일 성장 체험하기'),
            ),
            if (hasSession)
              OutlinedButton(
                key: const Key('clearSimulationButton'),
                onPressed: () => onClearSimulation(),
                child: const Text('시뮬레이션 기억 지우기'),
              ),
          ],
        ),
      ],
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _InfoPanel(
          title: insight.patternTitle,
          titleKey: const Key('localInsightTitle'),
          childrenWidgets: [
            Text(insight.patternBody),
            const SizedBox(height: 4),
            Text(_signalLine(insight.recurringSignals)),
            const SizedBox(height: 4),
            Text('${insight.tomorrowHint.title}: ${insight.tomorrowHint.body}'),
            Text('질문: ${insight.curiosityQuestion.text}'),
            Text('${insight.tinyMission.title}: ${insight.tinyMission.body}'),
            Text(insight.roleMessage),
          ],
        ),
        const SizedBox(height: 16),
        _InfoPanel(
          title: morningBrief.title,
          titleKey: const Key('morningBriefTitle'),
          childrenWidgets: [
            Text(morningBrief.greeting),
            const SizedBox(height: 4),
            Text(morningBrief.carryOverLine),
            const SizedBox(height: 4),
            Text('오늘의 질문: ${morningBrief.todayQuestion.text}'),
            Text(
              '${morningBrief.firstStep.title}: ${morningBrief.firstStep.body}',
            ),
            Text(morningBrief.roleMessage),
          ],
        ),
        const SizedBox(height: 16),
        _InfoPanel(
          title: '내 기억 관리',
          titleKey: const Key('memoryManagementTitle'),
          childrenWidgets: [
            const Text('저장된 정보를 보고 고치거나 지울 수 있어요.'),
            const SizedBox(height: 8),
            ExpansionTile(
              key: const Key('memoryManagementExpansion'),
              tilePadding: EdgeInsets.zero,
              childrenPadding: const EdgeInsets.only(bottom: 8),
              title: const Text('저장된 기억 펼쳐보기'),
              children: [
                if (!snapshot.consentSettings.localMemoryEnabled)
                  const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(
                      '기기 안에 기억하기를 켜면 저장된 정보를 여기서 관리할 수 있어요.',
                      key: Key('memoryConsentOffMessage'),
                    ),
                  )
                else ...[
                  _buildProfileSection(context),
                  const SizedBox(height: 8),
                  _buildPeopleSection(context),
                  const SizedBox(height: 8),
                  _buildTodoSection(context),
                  const SizedBox(height: 8),
                  _buildReflectionSection(),
                ],
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        _InfoPanel(
          title: '전체 초기화',
          childrenWidgets: [
            const Text('저장된 기억을 모두 지우고 처음 상태로 돌아가요.'),
            const SizedBox(height: 8),
            OutlinedButton(
              key: const Key('clearAllMemoryButton'),
              onPressed: onClearAll,
              child: const Text('저장된 기억 모두 지우기'),
            ),
          ],
        ),
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
    this.titleKey,
    this.children = const [],
    this.childrenWidgets = const [],
  });

  final String title;
  final Key? titleKey;
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
            Text(
              title,
              key: titleKey,
              style: Theme.of(context).textTheme.titleMedium,
            ),
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
