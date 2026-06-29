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

Future<void> _enableMemoryAndSeedBasicInputs(WidgetTester tester) async {
  await _scrollTo(tester, find.byKey(const Key('localMemoryConsentSwitch')));
  await tester.tap(find.byKey(const Key('localMemoryConsentSwitch')));
  await tester.pumpAndSettle();

  await tester.tap(find.byKey(const Key('roleChip-coach')));
  await tester.pumpAndSettle();

  await tester.enterText(find.byKey(const Key('profileNameField')), '테스트친구');
  await tester.enterText(
    find.byKey(const Key('todoMemoryField')),
    '문서 정리부터 시작하기',
  );
  await tester.enterText(
    find.byKey(const Key('personMemoryField')),
    '동료 A: 회의 뒤에 다시 이야기하기',
  );

  await _scrollTo(tester, find.byKey(const Key('saveMemoryButton')));
  await tester.tap(find.byKey(const Key('saveMemoryButton')));
  await tester.pumpAndSettle();
}

Future<void> _createAndKeepReflection(WidgetTester tester) async {
  await tester.enterText(
    find.byKey(const Key('reflectionNoteField')),
    '오늘은 회의가 많아서 조금 피곤했지만, 해야 할 일을 하나 끝냈다.',
  );
  await _scrollTo(tester, find.byKey(const Key('generateButton')));
  await tester.tap(
    find.byKey(const Key('generateButton')),
    warnIfMissed: false,
  );
  await tester.pumpAndSettle();
  await _scrollTo(tester, find.byKey(const Key('keepButton')));
  await tester.tap(find.byKey(const Key('keepButton')), warnIfMissed: false);
  await tester.pumpAndSettle();
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('shows core UI and safe empty state', (tester) async {
    await _pumpScreen(tester);

    expect(find.text('HeartTalk 하루 대화'), findsOneWidget);
    expect(find.text('사생활을 지키는 대화'), findsOneWidget);
    expect(find.byKey(const Key('reflectionNoteField')), findsOneWidget);
    expect(find.byKey(const Key('generateButton')), findsOneWidget);
    await _scrollTo(tester, find.byKey(const Key('emptyState')));
    expect(find.byKey(const Key('emptyState')), findsOneWidget);
    expect(find.byKey(const Key('morningBriefTitle')), findsOneWidget);
    expect(find.text('내 기억 관리'), findsOneWidget);
  });

  testWidgets('generates preview and unlocks tomorrow note only after keep', (
    tester,
  ) async {
    await _pumpScreen(tester);

    await tester.enterText(
      find.byKey(const Key('reflectionNoteField')),
      '오늘은 회의를 정리하고, 내일 다시 볼 문서를 하나 남겼다.',
    );
    await _scrollTo(tester, find.byKey(const Key('generateButton')));
    await tester.tap(
      find.byKey(const Key('generateButton')),
      warnIfMissed: false,
    );
    await tester.pumpAndSettle();

    expect(find.text('대화 미리보기'), findsOneWidget);
    expect(find.text('내일 시작 메모'), findsNothing);
    expect(
      find.byKey(const Key('morningBriefingLockedMessage')),
      findsOneWidget,
    );

    await _scrollTo(tester, find.byKey(const Key('keepButton')));
    await tester.tap(find.byKey(const Key('keepButton')), warnIfMissed: false);
    await tester.pumpAndSettle();

    expect(find.text('내일 시작 메모'), findsOneWidget);
    expect(find.byKey(const Key('keptMessage')), findsOneWidget);
  });

  testWidgets('reset clears preview and returns to empty state', (
    tester,
  ) async {
    await _pumpScreen(tester);

    await tester.enterText(
      find.byKey(const Key('reflectionNoteField')),
      '오늘은 천천히 하루를 정리했다.',
    );
    await _scrollTo(tester, find.byKey(const Key('generateButton')));
    await tester.tap(
      find.byKey(const Key('generateButton')),
      warnIfMissed: false,
    );
    await tester.pumpAndSettle();

    await _scrollTo(tester, find.byKey(const Key('resetButton')));
    await tester.tap(find.byKey(const Key('resetButton')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('emptyState')), findsOneWidget);
    expect(
      find.byKey(const Key('morningBriefingEmptyMessage')),
      findsOneWidget,
    );
    expect(find.text('대화 미리보기'), findsNothing);
  });

  testWidgets('shows consent role selection and reset controls', (
    tester,
  ) async {
    await _pumpScreen(tester);

    await _scrollTo(tester, find.text('기기 안에 기억하기'));
    expect(find.byKey(const Key('localMemoryConsentSwitch')), findsOneWidget);
    expect(find.byKey(const Key('roleChip-coach')), findsOneWidget);
    expect(find.byKey(const Key('saveMemoryButton')), findsOneWidget);
    expect(find.byKey(const Key('clearAllMemoryButton')), findsOneWidget);
    expect(find.text('내 기억 관리'), findsOneWidget);
  });

  testWidgets('persists consent role profile and todo after restart', (
    tester,
  ) async {
    await _pumpScreen(tester);
    await _enableMemoryAndSeedBasicInputs(tester);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
    await _pumpScreen(tester);

    expect(find.textContaining('대화 역할:'), findsOneWidget);
    expect(find.textContaining('테스트친구'), findsWidgets);
    expect(find.textContaining('문서 정리부터 시작하기'), findsWidgets);
    expect(find.textContaining('함께 알아가는 단계:'), findsOneWidget);
  });

  testWidgets('clear all memory removes stored summary data', (tester) async {
    await _pumpScreen(tester);
    await _enableMemoryAndSeedBasicInputs(tester);

    expect(find.textContaining('테스트친구'), findsWidgets);

    await _scrollTo(tester, find.byKey(const Key('clearAllMemoryButton')));
    await tester.tap(find.byKey(const Key('clearAllMemoryButton')));
    await tester.pumpAndSettle();

    expect(find.text('내 소개: -'), findsOneWidget);
    expect(find.byKey(const Key('memoryConsentOffMessage')), findsOneWidget);
  });

  testWidgets('consent off hides personal memory management categories', (
    tester,
  ) async {
    await _pumpScreen(tester);
    await _enableMemoryAndSeedBasicInputs(tester);

    await _scrollTo(tester, find.byKey(const Key('localMemoryConsentSwitch')));
    await tester.tap(find.byKey(const Key('localMemoryConsentSwitch')));
    await tester.pumpAndSettle();

    await _scrollTo(tester, find.byKey(const Key('memoryManagementTitle')));
    expect(find.byKey(const Key('memoryConsentOffMessage')), findsOneWidget);
    expect(find.text('내 소개 (1)'), findsNothing);
    expect(find.text('기억할 사람 (1)'), findsNothing);
    expect(find.text('내일 할 일 (1)'), findsNothing);
  });

  testWidgets('memory management supports category counts edit and delete', (
    tester,
  ) async {
    await _pumpScreen(tester);
    await _enableMemoryAndSeedBasicInputs(tester);
    await _createAndKeepReflection(tester);

    await _scrollTo(tester, find.byKey(const Key('memoryManagementTitle')));
    expect(find.text('내 소개 (1)'), findsOneWidget);
    expect(find.text('기억할 사람 (1)'), findsOneWidget);
    expect(find.text('내일 할 일 (1)'), findsOneWidget);
    expect(find.text('하루 기록 (1)'), findsOneWidget);

    await tester.tap(find.byKey(const Key('editTodoButton-0')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('editTodoTitleField')),
      '아침에 가장 쉬운 문서부터 정리하기',
    );
    await tester.tap(find.byKey(const Key('confirmEditTodoButton')));
    await tester.pumpAndSettle();
    expect(find.textContaining('아침에 가장 쉬운 문서부터 정리하기'), findsWidgets);

    await _scrollTo(tester, find.byKey(const Key('deletePersonButton-0')));
    await tester.tap(
      find.byKey(const Key('deletePersonButton-0')),
      warnIfMissed: false,
    );
    await tester.pumpAndSettle();
    expect(find.text('기억할 사람 (0)'), findsOneWidget);

    await _scrollTo(tester, find.byKey(const Key('deleteReflectionButton-0')));
    await tester.tap(
      find.byKey(const Key('deleteReflectionButton-0')),
      warnIfMissed: false,
    );
    await tester.pumpAndSettle();
    expect(find.text('하루 기록 (0)'), findsOneWidget);
  });
}
