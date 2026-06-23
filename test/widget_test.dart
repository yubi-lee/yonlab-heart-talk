import 'package:flutter_test/flutter_test.dart';
import 'package:heart_talk/main.dart';

void main() {
  testWidgets('HeartTalk daily reflection app pumps', (tester) async {
    await tester.pumpWidget(const HeartTalkApp());

    expect(find.text('HeartTalk — 오늘 어땠어?'), findsOneWidget);
    expect(find.text('내 개인정보 보호 안내'), findsOneWidget);
  });
}
