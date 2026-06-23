import 'package:flutter_test/flutter_test.dart';
import 'package:heart_talk/features/daily_reflection/data/demo_reflection_repository.dart';

void main() {
  group('DemoReflectionRepository', () {
    const repository = DemoReflectionRepository();

    test('returns at least five demo events with text', () {
      final events = repository.listEvents();

      expect(events.length, greaterThanOrEqualTo(5));
      for (final event in events) {
        expect(event.text.trim(), isNotEmpty);
        expect(event.title.trim(), isNotEmpty);
      }
    });

    test('does not include obvious phone numbers or email addresses', () {
      final events = repository.listEvents();
      final emailPattern = RegExp(
        r'[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}',
      );
      final phonePattern = RegExp(r'\d{2,3}[- ]\d{3,4}[- ]\d{4}');

      for (final event in events) {
        expect(emailPattern.hasMatch(event.text), isFalse, reason: event.id);
        expect(phonePattern.hasMatch(event.text), isFalse, reason: event.id);
      }
    });
  });
}
