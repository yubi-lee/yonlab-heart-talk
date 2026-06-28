import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../application/companion_message_service.dart';
import '../application/growth_calculator.dart';
import '../application/local_insight_service.dart';
import '../application/rule_based_reflection_engine.dart';
import '../data/demo_reflection_repository.dart';
import '../data/local_memory_repository.dart';
import '../data/shared_preferences_memory_repository.dart';
import '../domain/companion_models.dart';
import '../domain/local_insight_models.dart';
import '../domain/local_memory_models.dart';
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
      people.add(
        PersonMemory(
          id: 'person-${now.microsecondsSinceEpoch}',
          label: parts.first.trim().isEmpty ? '관계' : parts.first.trim(),
          note: parts.length > 1
              ? parts.sublist(1).join(':').trim()
              : personNote,
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

    return Scaffold(
      appBar: AppBar(title: const Text('HeartTalk Daily Reflection Demo')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'A local-only daily reflection demo for ending the day gently.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              _InfoPanel(
                title: 'Privacy-first demo',
                children: const [
                  'This MVP does not read calls, SMS, messengers, notifications, voice, PPG, contacts, location, or health data.',
                  'Use only safe demo events or short non-sensitive text that you type yourself.',
                  'Processing is local and deterministic. No cloud AI, analytics, sync, database, or permission request is used.',
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Safe demo events',
                style: Theme.of(context).textTheme.titleMedium,
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
              const SizedBox(height: 16),
              TextField(
                key: const Key('reflectionNoteField'),
                controller: _controller,
                minLines: 3,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Manual reflection note',
                  hintText:
                      'Write one or two non-sensitive sentences about today.',
                  helperText:
                      'Do not enter private messages, health data, phone numbers, or real voice/PPG details.',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              FilledButton(
                key: const Key('generateButton'),
                onPressed: _generateFromManualText,
                child: const Text('Generate reflection'),
              ),
              const SizedBox(height: 16),
              _LocalMemoryPanel(
                snapshot: _memorySnapshot,
                growthState: _growthState,
                insight: localInsight,
                profileNameController: _profileNameController,
                todoMemoryController: _todoMemoryController,
                personMemoryController: _personMemoryController,
                onConsentChanged: _toggleLocalMemory,
                onRoleSelected: _selectRole,
                onSaveMemory: _saveMemoryInputs,
                onClearAll: _clearAllMemory,
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
                  title: 'Reflection preview',
                  children: [summary.preview, 'Source: ${summary.sourceLabel}'],
                ),
                if (companionMessage != null) ...[
                  const SizedBox(height: 12),
                  _InfoPanel(
                    title: 'Companion message',
                    children: [companionMessage],
                  ),
                ],
                const SizedBox(height: 12),
                _InfoPanel(
                  title: 'Daily reflection card',
                  children: [
                    'Summary: ${summary.todayFlow}',
                    'Gentle insight: ${summary.observedCue}',
                    'Closing prompt: ${summary.leftForTomorrow}',
                    'Tomorrow line: ${summary.tomorrowLine}',
                  ],
                ),
                const SizedBox(height: 12),
                if (showMorningBriefing)
                  _InfoPanel(
                    title: 'Morning briefing',
                    children: [
                      'Start line: ${morningDraft.startLine}',
                      'Next action: ${morningDraft.firstThing}',
                      'Tone hint: ${morningDraft.toneHint}',
                    ],
                  )
                else
                  const Text(
                    'Morning briefing appears after you keep this reflection.',
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
                      child: const Text('Keep for morning'),
                    ),
                    OutlinedButton(
                      key: const Key('resetButton'),
                      onPressed: _reset,
                      child: const Text('Reset / Delete'),
                    ),
                  ],
                ),
                if (_session.isKept) ...[
                  const SizedBox(height: 8),
                  const Text(
                    'Kept in this session only unless local memory consent is on.',
                    key: Key('keptMessage'),
                  ),
                ],
              ] else ...[
                const SizedBox(height: 16),
                const Text(
                  'No reflection generated yet.',
                  key: Key('emptyState'),
                ),
                const SizedBox(height: 4),
                const Text(
                  'No morning briefing yet.',
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
    required this.profileNameController,
    required this.todoMemoryController,
    required this.personMemoryController,
    required this.onConsentChanged,
    required this.onRoleSelected,
    required this.onSaveMemory,
    required this.onClearAll,
  });

  final LocalMemorySnapshot snapshot;
  final CompanionGrowthState growthState;
  final LocalInsightSummary insight;
  final TextEditingController profileNameController;
  final TextEditingController todoMemoryController;
  final TextEditingController personMemoryController;
  final ValueChanged<bool> onConsentChanged;
  final ValueChanged<CompanionRole> onRoleSelected;
  final VoidCallback onSaveMemory;
  final VoidCallback onClearAll;

  String _signalLine(List<RecurringSignal> signals) {
    if (signals.isEmpty) {
      return '반복 신호: 아직 없음';
    }
    return '반복 신호: ${signals.map((signal) => '${signal.label}(${signal.count})').join(', ')}';
  }

  @override
  Widget build(BuildContext context) {
    return _InfoPanel(
      title: 'Local memory consent',
      childrenWidgets: [
        SwitchListTile(
          key: const Key('localMemoryConsentSwitch'),
          contentPadding: EdgeInsets.zero,
          title: const Text('Store approved information on this device'),
          subtitle: const Text(
            'Profile, reflections, people, todos, and recurring keywords are stored only when consent is on.',
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
            labelText: 'Profile name',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          key: const Key('todoMemoryField'),
          controller: todoMemoryController,
          decoration: const InputDecoration(
            labelText: 'Todo memory',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          key: const Key('personMemoryField'),
          controller: personMemoryController,
          decoration: const InputDecoration(
            labelText: 'Person memory',
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
              child: const Text('Save memory'),
            ),
            OutlinedButton(
              key: const Key('clearAllMemoryButton'),
              onPressed: onClearAll,
              child: const Text('Clear all local memory'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text('내 기억'),
        Text('Role: ${snapshot.companionPreference.defaultRole.koreanLabel}'),
        Text(
          'Profile: ${snapshot.profile.displayName.trim().isEmpty ? '-' : snapshot.profile.displayName.trim()}',
        ),
        Text('Growth level: ${growthState.level}'),
        Text('Entries: ${snapshot.dailyEntries.length}'),
        Text(
          'People: ${snapshot.people.map((person) => person.note).join(', ')}',
        ),
        Text('Todos: ${snapshot.todos.map((todo) => todo.title).join(', ')}'),
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
