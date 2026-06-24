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
      appBar: AppBar(title: const Text('HeartTalk — 오늘 어땠어?')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _InfoPanel(
              title: '내 개인정보 보호 안내',
              children: const [
                '통화, SMS, 메신저, 알림, 음성, PPG를 자동으로 읽지 않아요.',
                '직접 적은 문장과 선택한 데모 이야기만 사용해요.',
                '이 MVP는 cloud AI, 네트워크, 저장소, 권한 요청 없이 화면 안에서만 동작해요.',
              ],
            ),
            const SizedBox(height: 16),
            Text('데모 이야기 조각', style: Theme.of(context).textTheme.titleMedium),
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
                labelText: '오늘 남기고 싶은 말',
                hintText: '오늘 있었던 일을 한두 문장으로 적어 주세요.',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            FilledButton(
              key: const Key('generateButton'),
              onPressed: _generateFromManualText,
              child: const Text('오늘 정리하기'),
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
                title: '오늘의 응답 미리보기',
                children: [summary.preview, '출처: ${summary.sourceLabel}'],
              ),
              const SizedBox(height: 12),
              _InfoPanel(
                title: '오늘의 정리 카드',
                children: [
                  '오늘의 흐름: ${summary.todayFlow}',
                  '마음 단서: ${summary.observedCue}',
                  '남겨둘 일: ${summary.leftForTomorrow}',
                  '내일의 한 문장: ${summary.tomorrowLine}',
                ],
              ),
              const SizedBox(height: 12),
              if (showMorningBriefing)
                _InfoPanel(
                  title: '내일 아침 브리핑 초안',
                  children: [
                    '오늘의 시작 문장: ${morningDraft.startLine}',
                    '먼저 볼 일: ${morningDraft.firstThing}',
                    '말투 힌트: ${morningDraft.toneHint}',
                  ],
                )
              else
                const Text(
                  '내일 아침 브리핑 초안은 남기기 후에만 보여드려요.',
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
                    child: const Text('남기기'),
                  ),
                  OutlinedButton(
                    key: const Key('resetButton'),
                    onPressed: _reset,
                    child: const Text('다시 비우기'),
                  ),
                ],
              ),
              if (_session.isKept) ...[
                const SizedBox(height: 8),
                const Text('이번 화면 안에서만 남겨두었어요.', key: Key('keptMessage')),
              ],
            ] else ...[
              const SizedBox(height: 16),
              const Text('아직 정리한 내용이 없어요.', key: Key('emptyState')),
              const SizedBox(height: 4),
              const Text(
                '아직 남겨둔 정리가 없어요.',
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
