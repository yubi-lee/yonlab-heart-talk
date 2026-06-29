import 'package:flutter_test/flutter_test.dart';
import 'package:heart_talk/main.dart';

void main() {
  testWidgets('HeartTalk daily reflection app pumps', (tester) async {
    await tester.pumpWidget(const HeartTalkApp());

    expect(find.text('HeartTalk 하루 회고'), findsOneWidget);
    expect(find.text('사생활을 지키는 회고'), findsOneWidget);
  });
}
