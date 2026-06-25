import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heart_talk/features/daily_reflection/presentation/daily_reflection_screen.dart';

Future<void> _scrollTo(
  WidgetTester tester,
  Finder finder, {
  double delta = 240,
}) async {
  await tester.scrollUntilVisible(
    finder,
    delta,
    scrollable: find.byType(Scrollable).first,
  );
}

void main() {
  testWidgets('shows required daily reflection elements', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: DailyReflectionScreen()));

    expect(find.text('HeartTalk — 오늘 어땠어?'), findsOneWidget);
    expect(find.text('내 개인정보 보호 안내'), findsOneWidget);
    expect(find.text('데모 이야기 조각'), findsOneWidget);
    expect(find.text('회의 뒤 역할 정리'), findsOneWidget);
    expect(find.byKey(const Key('emptyState')), findsOneWidget);
    expect(
      find.byKey(const Key('morningBriefingEmptyMessage')),
      findsOneWidget,
    );
    expect(find.text('내일 아침 브리핑 초안'), findsNothing);
  });

  testWidgets('generates manual preview before morning briefing is kept', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: DailyReflectionScreen()));

    await tester.enterText(
      find.byKey(const Key('reflectionNoteField')),
      '오늘 회의에서 일정을 조율했고 내일 확인할 일이 남았다.',
    );
    await _scrollTo(tester, find.byKey(const Key('generateButton')));
    await tester.tap(
      find.byKey(const Key('generateButton')),
      warnIfMissed: false,
    );
    await tester.pumpAndSettle();

    expect(find.text('오늘의 응답 미리보기'), findsOneWidget);
    expect(find.text('출처: 직접 입력'), findsOneWidget);
    expect(find.text('내일 아침 브리핑 초안'), findsNothing);
    await _scrollTo(
      tester,
      find.byKey(const Key('morningBriefingLockedMessage')),
    );
    expect(
      find.byKey(const Key('morningBriefingLockedMessage')),
      findsOneWidget,
    );
    expect(find.byKey(const Key('keptMessage')), findsNothing);
  });

  testWidgets('shows kept confirmation and morning briefing after keep', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: DailyReflectionScreen()));

    await tester.tap(find.text('회의 뒤 역할 정리'));
    await tester.pump();

    expect(find.text('오늘의 응답 미리보기'), findsOneWidget);
    expect(find.text('내일 아침 브리핑 초안'), findsNothing);
    await _scrollTo(
      tester,
      find.byKey(const Key('morningBriefingLockedMessage')),
    );
    expect(
      find.byKey(const Key('morningBriefingLockedMessage')),
      findsOneWidget,
    );
    await _scrollTo(tester, find.byKey(const Key('keepButton')));
    await tester.tap(find.byKey(const Key('keepButton')), warnIfMissed: false);
    await tester.pumpAndSettle();

    await _scrollTo(tester, find.byKey(const Key('keptMessage')));
    expect(find.byKey(const Key('keptMessage')), findsOneWidget);
    expect(find.text('내일 아침 브리핑 초안'), findsOneWidget);
    expect(find.byKey(const Key('morningBriefingLockedMessage')), findsNothing);
  });

  testWidgets('new preview clears kept state and hides morning briefing', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: DailyReflectionScreen()));

    await tester.tap(find.text('회의 뒤 역할 정리'));
    await tester.pump();
    await _scrollTo(tester, find.byKey(const Key('keepButton')));
    await tester.tap(find.byKey(const Key('keepButton')), warnIfMissed: false);
    await tester.pumpAndSettle();
    await _scrollTo(tester, find.byKey(const Key('keptMessage')));
    expect(find.byKey(const Key('keptMessage')), findsOneWidget);
    expect(find.text('내일 아침 브리핑 초안'), findsOneWidget);

    await _scrollTo(
      tester,
      find.byKey(const Key('reflectionNoteField')),
      delta: -240,
    );
    await tester.enterText(
      find.byKey(const Key('reflectionNoteField')),
      '오늘은 가족과 저녁 이야기를 나눴다.',
    );
    await _scrollTo(tester, find.byKey(const Key('generateButton')));
    await tester.tap(
      find.byKey(const Key('generateButton')),
      warnIfMissed: false,
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('keptMessage')), findsNothing);
    expect(find.text('내일 아침 브리핑 초안'), findsNothing);
    await _scrollTo(
      tester,
      find.byKey(const Key('morningBriefingLockedMessage')),
    );
    expect(
      find.byKey(const Key('morningBriefingLockedMessage')),
      findsOneWidget,
    );
  });

  testWidgets(
    'reset returns preview kept state and briefing to safe empty state',
    (tester) async {
      await tester.pumpWidget(const MaterialApp(home: DailyReflectionScreen()));

      await tester.tap(find.text('회의 뒤 역할 정리'));
      await tester.pump();
      await _scrollTo(tester, find.byKey(const Key('keepButton')));
      await tester.tap(
        find.byKey(const Key('keepButton')),
        warnIfMissed: false,
      );
      await tester.pumpAndSettle();
      expect(find.text('내일 아침 브리핑 초안'), findsOneWidget);
      await _scrollTo(tester, find.byKey(const Key('keptMessage')));
      expect(find.byKey(const Key('keptMessage')), findsOneWidget);

      await _scrollTo(tester, find.byKey(const Key('resetButton')));
      await tester.tap(find.byKey(const Key('resetButton')));
      await tester.pump();

      expect(find.byKey(const Key('emptyState')), findsOneWidget);
      expect(
        find.byKey(const Key('morningBriefingEmptyMessage')),
        findsOneWidget,
      );
      expect(find.text('오늘의 응답 미리보기'), findsNothing);
      expect(find.byKey(const Key('keptMessage')), findsNothing);
      expect(find.text('내일 아침 브리핑 초안'), findsNothing);
    },
  );
}
