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

    expect(find.text('HeartTalk 하루 회고'), findsOneWidget);
    expect(find.text('사생활을 지키는 회고'), findsOneWidget);
    expect(find.text('안전한 데모 예시'), findsOneWidget);
    expect(find.text('회의와 정리'), findsOneWidget);
    await _scrollTo(tester, find.byKey(const Key('emptyState')));
    expect(find.text('아직 회고를 만들지 않았어요.'), findsOneWidget);
    expect(find.text('아직 내일 시작 메모가 없어요.'), findsOneWidget);
    expect(find.text('내일 시작 메모'), findsNothing);
  });

  testWidgets('generates manual preview before tomorrow note is kept', (
    tester,
  ) async {
    await _pumpScreen(tester);

    await tester.enterText(
      find.byKey(const Key('reflectionNoteField')),
      '오늘은 회의를 정리하고 내일 확인할 작은 일을 하나 남겼다.',
    );
    await _scrollTo(tester, find.byKey(const Key('generateButton')));
    await tester.tap(
      find.byKey(const Key('generateButton')),
      warnIfMissed: false,
    );
    await tester.pumpAndSettle();

    expect(find.text('회고 미리보기'), findsOneWidget);
    expect(find.text('입력 방식: 직접 입력'), findsOneWidget);
    expect(find.text('내일 시작 메모'), findsNothing);
    await _scrollTo(
      tester,
      find.byKey(const Key('morningBriefingLockedMessage')),
    );
    expect(find.text('이 회고를 남기면 내일 시작 메모가 함께 보여요.'), findsOneWidget);
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
    expect(find.textContaining('한 문장 이상 적어주세요'), findsOneWidget);
  });

  testWidgets('shows kept confirmation and tomorrow note after keep', (
    tester,
  ) async {
    await _pumpScreen(tester);

    await _scrollTo(tester, find.text('회의와 정리'));
    await tester.tap(find.text('회의와 정리'), warnIfMissed: false);
    await tester.pump();

    await _scrollTo(tester, find.text('회고 미리보기'));
    expect(find.text('회고 미리보기'), findsOneWidget);
    expect(find.text('내일 시작 메모'), findsNothing);
    await _scrollTo(
      tester,
      find.byKey(const Key('morningBriefingLockedMessage')),
    );
    expect(find.text('이 회고를 남기면 내일 시작 메모가 함께 보여요.'), findsOneWidget);
    await _scrollTo(tester, find.byKey(const Key('keepButton')));
    await tester.tap(find.byKey(const Key('keepButton')), warnIfMissed: false);
    await tester.pumpAndSettle();

    await _scrollTo(tester, find.byKey(const Key('keptMessage')));
    expect(find.byKey(const Key('keptMessage')), findsOneWidget);
    expect(find.text('내일 시작 메모'), findsOneWidget);
    expect(find.textContaining('가장 먼저 할 일:'), findsOneWidget);
    expect(find.byKey(const Key('morningBriefingLockedMessage')), findsNothing);
  });

  testWidgets('new preview clears kept state and hides tomorrow note', (
    tester,
  ) async {
    await _pumpScreen(tester);

    await _scrollTo(tester, find.text('회의와 정리'));
    await tester.tap(find.text('회의와 정리'), warnIfMissed: false);
    await tester.pump();
    await _scrollTo(tester, find.byKey(const Key('keepButton')));
    await tester.tap(find.byKey(const Key('keepButton')), warnIfMissed: false);
    await tester.pumpAndSettle();
    await _scrollTo(tester, find.byKey(const Key('keptMessage')));
    expect(find.byKey(const Key('keptMessage')), findsOneWidget);
    expect(find.text('내일 시작 메모'), findsOneWidget);

    await _scrollTo(
      tester,
      find.byKey(const Key('reflectionNoteField')),
      delta: -240,
    );
    await tester.enterText(
      find.byKey(const Key('reflectionNoteField')),
      '가족과 나눈 짧은 대화가 오늘을 조금 더 차분하게 만들었다.',
    );
    await _scrollTo(tester, find.byKey(const Key('generateButton')));
    await tester.tap(
      find.byKey(const Key('generateButton')),
      warnIfMissed: false,
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('keptMessage')), findsNothing);
    expect(find.text('내일 시작 메모'), findsNothing);
    await _scrollTo(
      tester,
      find.byKey(const Key('morningBriefingLockedMessage')),
    );
    expect(find.text('이 회고를 남기면 내일 시작 메모가 함께 보여요.'), findsOneWidget);
  });

  testWidgets(
    'reset clears preview kept state and tomorrow note to safe empty state',
    (tester) async {
      await _pumpScreen(tester);

      await _scrollTo(tester, find.text('회의와 정리'));
      await tester.tap(find.text('회의와 정리'), warnIfMissed: false);
      await tester.pump();
      await _scrollTo(tester, find.byKey(const Key('keepButton')));
      await tester.tap(
        find.byKey(const Key('keepButton')),
        warnIfMissed: false,
      );
      await tester.pumpAndSettle();
      expect(find.text('내일 시작 메모'), findsOneWidget);
      await _scrollTo(tester, find.byKey(const Key('keptMessage')));
      expect(find.byKey(const Key('keptMessage')), findsOneWidget);

      await _scrollTo(tester, find.byKey(const Key('resetButton')));
      await tester.tap(find.byKey(const Key('resetButton')));
      await tester.pump();

      expect(find.text('아직 회고를 만들지 않았어요.'), findsOneWidget);
      expect(find.text('아직 내일 시작 메모가 없어요.'), findsOneWidget);
      expect(find.text('회고 미리보기'), findsNothing);
      expect(find.byKey(const Key('keptMessage')), findsNothing);
      expect(find.text('내일 시작 메모'), findsNothing);
    },
  );

  testWidgets('shows consent role selection memory area and reset control', (
    tester,
  ) async {
    await _pumpScreen(tester);

    await _scrollTo(tester, find.text('기기 안에 기억하기'));
    expect(find.text('기기 안에 기억하기'), findsOneWidget);
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
    expect(find.text('저장된 기억 모두 지우기'), findsOneWidget);
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
      '문서 먼저 정리',
    );
    await tester.enterText(
      find.byKey(const Key('personMemoryField')),
      '동료: 마음이 남는 대화',
    );
    await _scrollTo(tester, find.byKey(const Key('saveMemoryButton')));
    await tester.tap(find.byKey(const Key('saveMemoryButton')));
    await tester.pumpAndSettle();

    await tester.pumpWidget(const SizedBox.shrink());
    await _pumpScreen(tester);

    expect(find.text('대화 역할: 코치'), findsOneWidget);
    expect(find.text('내 소개: 나'), findsOneWidget);
    expect(find.textContaining('문서 먼저 정리'), findsOneWidget);
    expect(find.textContaining('함께 알아가는 단계:'), findsOneWidget);
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
    expect(find.text('내 소개: 나'), findsOneWidget);

    await _scrollTo(tester, find.byKey(const Key('clearAllMemoryButton')));
    await tester.tap(find.byKey(const Key('clearAllMemoryButton')));
    await tester.pumpAndSettle();

    expect(find.text('내 소개: 나'), findsNothing);
    expect(find.text('내 소개: -'), findsOneWidget);
  });

  testWidgets('shows local insight fallback and todo-based tiny mission', (
    tester,
  ) async {
    await _pumpScreen(tester);

    await _scrollTo(tester, find.text('오늘의 인사이트'));
    expect(find.text('오늘의 인사이트'), findsOneWidget);
    expect(find.textContaining('아직 알아가는 중이에요'), findsOneWidget);

    await _scrollTo(tester, find.byKey(const Key('localMemoryConsentSwitch')));
    await tester.tap(find.byKey(const Key('localMemoryConsentSwitch')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('todoMemoryField')),
      '내일 쉬운 일 먼저 정리',
    );
    await _scrollTo(tester, find.byKey(const Key('saveMemoryButton')));
    await tester.tap(find.byKey(const Key('saveMemoryButton')));
    await tester.pumpAndSettle();

    await _scrollTo(tester, find.textContaining('작은 미션:'));
    expect(find.textContaining('작은 미션:'), findsOneWidget);
    expect(find.textContaining('내일 첫 3분은'), findsOneWidget);
    expect(find.text('오늘의 인사이트'), findsOneWidget);
  });
}
