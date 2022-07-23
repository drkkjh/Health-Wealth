import 'package:health_wealth/screens/authenticate/email_validator.dart';
import 'package:health_wealth/screens/authenticate/password_validator.dart';
import 'package:test/test.dart';

void main() {
  test('Empty email returns error string', () {
    final result = EmailValidator.validate('');
    expect(result, 'Enter your email');
  });

  test('Non-empty email returns null', () {
    final result = EmailValidator.validate('email');
    expect(result, null);
  });

  test('Empty password returns error string', () {
    final result = PasswordValidator.validate('');
    expect(result, 'Enter your password');
  });

  test('Password with less than 6 characters returns error string', () {
    final result = PasswordValidator.validate('12345');
    expect(result, 'Password must be at least 6 characters');
  });

  test('Password with at least 6 characters returns null', () {
    final result = PasswordValidator.validate('123456');
    expect(result, null);
  });
}
