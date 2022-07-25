import 'package:health_wealth/common/input_validator.dart';
import 'package:test/test.dart';

void main() {
  test('Empty email returns error string', () {
    final result = InputValidator.validateEmail('');
    expect(result, 'Enter your email');
  });

  test('Non-empty email returns null', () {
    final result = InputValidator.validateEmail('email');
    expect(result, null);
  });

  test('Empty password returns error string', () {
    final result = InputValidator.validatePassword('');
    expect(result, 'Enter your password');
  });

  test('Password with less than 6 characters returns error string', () {
    final result = InputValidator.validatePassword('12345');
    expect(result, 'Password must be at least 6 characters');
  });

  test('Password with at least 6 characters returns null', () {
    final result = InputValidator.validatePassword('123456');
    expect(result, null);
  });
}
