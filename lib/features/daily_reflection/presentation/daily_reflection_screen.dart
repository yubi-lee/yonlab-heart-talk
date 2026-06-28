import 'package:flutter/material.dart';

import '../application/rule_based_reflection_engine.dart';
import '../data/demo_reflection_repository.dart';
import '../domain/reflection_models.dart';

class DailyReflectionScreen extends StatefulWidget {
  const DailyReflectionScreen({super.key});

  @override
  State<DailyReflectionScreen> createState() => _DailyReflectionScreenState();
}

class _DailyReflectionScreenState extends State<DailyReflectionScreen> {
  final _repository = const DemoReflectionRepository();
  final _engine = RuleBasedReflectionEngine();
  final _controller = TextEditingController();

  ReflectionSessionState _session = const ReflectionSessionState();

  List<DemoReflectionEvent> get _events => _repository.listEvents();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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

  void _keep() {
    if (!_session.hasPreview) {
      return;
    }
    setState(() {
      _session = _session.copyWith(isKept: true);
    });
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

    return Scaffold(
      appBar: AppBar(title: const Text('HeartTalk Daily Reflection Demo')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'A local-only daily reflection demo for ending the day gently.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
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
                  'Kept in this session only.',
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
    );
  }
}

class _InfoPanel extends StatelessWidget {
  const _InfoPanel({required this.title, required this.children});

  final String title;
  final List<String> children;

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
          ],
        ),
      ),
    );
  }
}
