import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heart_talk/main.dart';

void main() {
  testWidgets('HeartTalk daily reflection app pumps', (tester) async {
    await tester.pumpWidget(const HeartTalkApp());
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('reflectionNoteField')), findsOneWidget);
    expect(find.byKey(const Key('generateButton')), findsOneWidget);
    expect(find.byKey(const Key('localMemoryConsentSwitch')), findsOneWidget);
  });
}
