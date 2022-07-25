import 'package:health_wealth/common/input_validator.dart';
import 'package:test/test.dart';

void main() {
  group('updateCalLimit', () {
    test('Empty input returns error string', () {
      final result = InputValidator.validateCalories('');
      expect(result, 'Enter your calories limit');
    });

    test('Non-numeric input string returns error string', () {
      final result = InputValidator.validateCalories('string');
      expect(result, 'Enter a positive number');
    });

    test('Negative numeric input string returns error string', () {
      final result = InputValidator.validateCalories('-500');
      expect(result, 'Enter a positive number');
    });

    test('Postive numeric string returns null', () {
      final result = InputValidator.validateCalories('500');
      expect(result, null);
    });
  });
}
