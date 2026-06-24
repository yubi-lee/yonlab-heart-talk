import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heart_talk/features/daily_reflection/presentation/daily_reflection_screen.dart';

void main() {
  testWidgets('shows required daily reflection elements', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: DailyReflectionScreen()));

    expect(find.text('HeartTalk — 오늘 어땠어?'), findsOneWidget);
    expect(find.text('내 개인정보 보호 안내'), findsOneWidget);
    expect(find.text('데모 이야기 조각'), findsOneWidget);
    expect(find.text('회의 뒤 역할 정리'), findsOneWidget);
    expect(find.byKey(const Key('emptyState')), findsOneWidget);
  });

  testWidgets('generates preview and morning briefing from manual input', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: DailyReflectionScreen()));

    await tester.enterText(
      find.byKey(const Key('reflectionNoteField')),
      '오늘 회의에서 일정을 조율했고 내일 확인할 일이 남았다.',
    );
    await tester.tap(find.text('오늘 정리하기'));
    await tester.pump();

    expect(find.text('오늘의 응답 미리보기'), findsOneWidget);
    expect(find.text('출처: 직접 입력'), findsOneWidget);
    final scrollable = find.byType(Scrollable).first;
    await tester.scrollUntilVisible(
      find.text('오늘의 정리 카드'),
      240,
      scrollable: scrollable,
    );
    expect(find.text('오늘의 정리 카드'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('내일 아침 브리핑 초안'),
      240,
      scrollable: scrollable,
    );
    expect(find.text('내일 아침 브리핑 초안'), findsOneWidget);
  });

  testWidgets('reset returns to safe empty state', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: DailyReflectionScreen()));

    await tester.tap(find.text('회의 뒤 역할 정리'));
    await tester.pump();
    expect(find.text('오늘의 응답 미리보기'), findsOneWidget);

    final scrollable = find.byType(Scrollable).first;
    await tester.scrollUntilVisible(
      find.text('다시 비우기'),
      240,
      scrollable: scrollable,
    );
    await tester.tap(find.text('다시 비우기'));
    await tester.pump();

    expect(find.byKey(const Key('emptyState')), findsOneWidget);
    expect(find.text('오늘의 응답 미리보기'), findsNothing);
  });
}
