class PasswordValidator {
  static String? validate(String? input) {
    return (input == null || input.isEmpty)
        ? 'Enter your password'
        : (input.length < 6)
            ? 'Password must be at least 6 characters'
            : null;
  }
}
