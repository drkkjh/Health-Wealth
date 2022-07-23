class InputValidator {
  static String? validateEmail(String? input) {
    return (input == null || input.isEmpty) ? 'Enter your email' : null;
  }

  static String? validatePassword(String? input) {
    return (input == null || input.isEmpty)
        ? 'Enter your password'
        : (input.length < 6)
            ? 'Password must be at least 6 characters'
            : null;
  }

  static String? validateCalories(String? val) {
    return (val == null || val.isEmpty)
        ? 'Enter your calories limit'
        : (num.tryParse(val) == null || num.parse(val) < 0)
            ? 'Enter a positive number'
            : null;
  }
}
