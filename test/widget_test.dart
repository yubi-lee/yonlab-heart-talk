import 'package:flutter_test/flutter_test.dart';
import 'package:heart_talk/main.dart';

void main() {
  testWidgets('HeartTalk daily reflection app pumps', (tester) async {
    await tester.pumpWidget(const HeartTalkApp());

    expect(find.text('HeartTalk Daily Reflection Demo'), findsOneWidget);
    expect(find.text('Privacy-first demo'), findsOneWidget);
  });
}
