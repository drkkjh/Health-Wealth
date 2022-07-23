class EmailValidator {
  static String? validate(String? input) {
    return (input == null || input.isEmpty) ? 'Enter your email' : null;
  }
}
