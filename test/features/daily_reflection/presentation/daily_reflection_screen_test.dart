import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heart_talk/features/daily_reflection/presentation/daily_reflection_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> _scrollTo(
  WidgetTester tester,
  Finder finder, {
  double delta = 240,
}) async {
  final target = finder.evaluate().length > 1 ? finder.first : finder;
  await tester.scrollUntilVisible(
    target,
    delta,
    scrollable: find.byType(Scrollable).first,
  );
}

Future<void> _pumpScreen(WidgetTester tester) async {
  await tester.pumpWidget(const MaterialApp(home: DailyReflectionScreen()));
  await tester.pumpAndSettle();
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('shows title privacy notice presets and empty state', (
    tester,
  ) async {
    await _pumpScreen(tester);

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
    await _pumpScreen(tester);

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
    await _pumpScreen(tester);

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
    await _pumpScreen(tester);

    await _scrollTo(tester, find.text('Work coordination'));
    await tester.tap(find.text('Work coordination'), warnIfMissed: false);
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
    await _pumpScreen(tester);

    await _scrollTo(tester, find.text('Work coordination'));
    await tester.tap(find.text('Work coordination'), warnIfMissed: false);
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
      await _pumpScreen(tester);

      await _scrollTo(tester, find.text('Work coordination'));
      await tester.tap(find.text('Work coordination'), warnIfMissed: false);
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

  testWidgets('shows consent role selection memory area and reset control', (
    tester,
  ) async {
    await _pumpScreen(tester);

    await _scrollTo(tester, find.text('Local memory consent'));
    expect(find.text('Local memory consent'), findsOneWidget);
    expect(find.byKey(const Key('localMemoryConsentSwitch')), findsOneWidget);
    expect(find.text('친구'), findsOneWidget);
    expect(find.text('연인'), findsOneWidget);
    expect(find.text('가족'), findsOneWidget);
    expect(find.text('부모'), findsOneWidget);
    expect(find.text('코치'), findsOneWidget);
    expect(find.text('선생님'), findsOneWidget);
    expect(find.text('경청자'), findsOneWidget);
    expect(find.text('사용자 지정'), findsOneWidget);
    expect(find.text('내 기억'), findsOneWidget);
    expect(find.byKey(const Key('clearAllMemoryButton')), findsOneWidget);
  });

  testWidgets('persists consent role profile todo and growth after restart', (
    tester,
  ) async {
    await _pumpScreen(tester);

    await _scrollTo(tester, find.byKey(const Key('localMemoryConsentSwitch')));
    await tester.tap(find.byKey(const Key('localMemoryConsentSwitch')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('코치'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('profileNameField')), '나');
    await tester.enterText(
      find.byKey(const Key('todoMemoryField')),
      '문서 첫 부분 확인',
    );
    await tester.enterText(
      find.byKey(const Key('personMemoryField')),
      '가족: 짧은 안부를 좋아함',
    );
    await _scrollTo(tester, find.byKey(const Key('saveMemoryButton')));
    await tester.tap(find.byKey(const Key('saveMemoryButton')));
    await tester.pumpAndSettle();

    await tester.pumpWidget(const SizedBox.shrink());
    await _pumpScreen(tester);

    expect(find.text('Role: 코치'), findsOneWidget);
    expect(find.text('Profile: 나'), findsOneWidget);
    expect(find.textContaining('문서 첫 부분 확인'), findsOneWidget);
    expect(find.textContaining('Growth level:'), findsOneWidget);
  });

  testWidgets('clear all memory removes stored local memory', (tester) async {
    await _pumpScreen(tester);

    await _scrollTo(tester, find.byKey(const Key('localMemoryConsentSwitch')));
    await tester.tap(find.byKey(const Key('localMemoryConsentSwitch')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('profileNameField')), '나');
    await _scrollTo(tester, find.byKey(const Key('saveMemoryButton')));
    await tester.tap(find.byKey(const Key('saveMemoryButton')));
    await tester.pumpAndSettle();
    expect(find.text('Profile: 나'), findsOneWidget);

    await _scrollTo(tester, find.byKey(const Key('clearAllMemoryButton')));
    await tester.tap(find.byKey(const Key('clearAllMemoryButton')));
    await tester.pumpAndSettle();

    expect(find.text('Profile: 나'), findsNothing);
    expect(find.text('Profile: -'), findsOneWidget);
  });
}
