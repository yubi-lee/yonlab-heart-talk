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
  testWidgets('shows title privacy notice presets and empty state', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: DailyReflectionScreen()));

    expect(find.text('HeartTalk Daily Reflection Demo'), findsOneWidget);
    expect(find.text('Privacy-first demo'), findsOneWidget);
    expect(find.text('Safe demo events'), findsOneWidget);
    expect(find.text('Work coordination'), findsOneWidget);
    await _scrollTo(tester, find.byKey(const Key('emptyState')));
    expect(find.byKey(const Key('emptyState')), findsOneWidget);
    expect(
      find.byKey(const Key('morningBriefingEmptyMessage')),
      findsOneWidget,
    );
    expect(find.text('Morning briefing'), findsNothing);
  });

  testWidgets('generates manual preview before morning briefing is kept', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: DailyReflectionScreen()));

    await tester.enterText(
      find.byKey(const Key('reflectionNoteField')),
      'Today I coordinated a meeting and left one small follow-up for tomorrow.',
    );
    await _scrollTo(tester, find.byKey(const Key('generateButton')));
    await tester.tap(
      find.byKey(const Key('generateButton')),
      warnIfMissed: false,
    );
    await tester.pumpAndSettle();

    expect(find.text('Reflection preview'), findsOneWidget);
    expect(find.text('Source: Manual text'), findsOneWidget);
    expect(find.text('Morning briefing'), findsNothing);
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

  testWidgets('shows validation for empty manual input', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: DailyReflectionScreen()));

    await _scrollTo(tester, find.byKey(const Key('generateButton')));
    await tester.tap(
      find.byKey(const Key('generateButton')),
      warnIfMissed: false,
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('validationMessage')), findsOneWidget);
    expect(find.textContaining('Write at least one sentence'), findsOneWidget);
  });

  testWidgets('shows kept confirmation and morning briefing after keep', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: DailyReflectionScreen()));

    await tester.tap(find.text('Work coordination'));
    await tester.pump();

    await _scrollTo(tester, find.text('Reflection preview'));
    expect(find.text('Reflection preview'), findsOneWidget);
    expect(find.text('Morning briefing'), findsNothing);
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
    expect(find.text('Morning briefing'), findsOneWidget);
    expect(find.textContaining('Next action:'), findsOneWidget);
    expect(find.byKey(const Key('morningBriefingLockedMessage')), findsNothing);
  });

  testWidgets('new preview clears kept state and hides morning briefing', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: DailyReflectionScreen()));

    await tester.tap(find.text('Work coordination'));
    await tester.pump();
    await _scrollTo(tester, find.byKey(const Key('keepButton')));
    await tester.tap(find.byKey(const Key('keepButton')), warnIfMissed: false);
    await tester.pumpAndSettle();
    await _scrollTo(tester, find.byKey(const Key('keptMessage')));
    expect(find.byKey(const Key('keptMessage')), findsOneWidget);
    expect(find.text('Morning briefing'), findsOneWidget);

    await _scrollTo(
      tester,
      find.byKey(const Key('reflectionNoteField')),
      delta: -240,
    );
    await tester.enterText(
      find.byKey(const Key('reflectionNoteField')),
      'A family conversation was gentle and I want to remember that.',
    );
    await _scrollTo(tester, find.byKey(const Key('generateButton')));
    await tester.tap(
      find.byKey(const Key('generateButton')),
      warnIfMissed: false,
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('keptMessage')), findsNothing);
    expect(find.text('Morning briefing'), findsNothing);
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
    'reset delete returns preview kept state and briefing to safe empty state',
    (tester) async {
      await tester.pumpWidget(const MaterialApp(home: DailyReflectionScreen()));

      await tester.tap(find.text('Work coordination'));
      await tester.pump();
      await _scrollTo(tester, find.byKey(const Key('keepButton')));
      await tester.tap(
        find.byKey(const Key('keepButton')),
        warnIfMissed: false,
      );
      await tester.pumpAndSettle();
      expect(find.text('Morning briefing'), findsOneWidget);
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
      expect(find.text('Reflection preview'), findsNothing);
      expect(find.byKey(const Key('keptMessage')), findsNothing);
      expect(find.text('Morning briefing'), findsNothing);
    },
  );
}
