import 'package:flutter_test/flutter_test.dart';
import 'package:heart_talk/main.dart';

void main() {
  testWidgets('HeartTalk daily reflection app pumps', (tester) async {
    await tester.pumpWidget(const HeartTalkApp());

    expect(find.text('HeartTalk - 오늘 돌아보기'), findsWidgets);
    expect(find.text('Privacy-first 안내'), findsOneWidget);
  });
}
