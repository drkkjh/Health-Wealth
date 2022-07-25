import 'package:health_wealth/common/input_validator.dart';
import 'package:test/test.dart';

void main() {
  group('updateExercise', () {
    group('update sets', () {
      test('Empty input returns null', () {
        final result = InputValidator.validateSetsAndReps('');
        expect(result, null);
      });

      test('Non-numeric input string returns error string', () {
        final result = InputValidator.validateSetsAndReps('string');
        expect(result, 'Enter a positive integer');
      });

      test('Negative numeric input string returns error string', () {
        final result = InputValidator.validateSetsAndReps('-500');
        expect(result, 'Enter a positive integer');
      });

      test('Postive integer returns null', () {
        final result = InputValidator.validateSetsAndReps('500');
        expect(result, null);
      });
    });
    group('update reps', () {
      test('Empty input returns null', () {
        final result = InputValidator.validateSetsAndReps('');
        expect(result, null);
      });

      test('Non-numeric input string returns error string', () {
        final result = InputValidator.validateSetsAndReps('string');
        expect(result, 'Enter a positive integer');
      });

      test('Negative numeric input string returns error string', () {
        final result = InputValidator.validateSetsAndReps('-500');
        expect(result, 'Enter a positive integer');
      });

      test('Postive integer returns null', () {
        final result = InputValidator.validateSetsAndReps('500');
        expect(result, null);
      });
    });
  });
}
