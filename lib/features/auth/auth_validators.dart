class AuthValidators {
  AuthValidators._();

  static const minPasswordLength = 8;

  static final _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  static final _usernamePattern = RegExp(r'^[a-zA-Z0-9_]{3,20}$');

  static String? name(String? value) =>
      value == null || value.trim().isEmpty ? 'Enter your name' : null;

  static String? username(String? value) {
    final username = value?.trim() ?? '';
    if (username.isEmpty) return 'Choose a username';
    if (!_usernamePattern.hasMatch(username)) {
      return 'Use 3-20 letters, numbers, or underscores';
    }
    return null;
  }

  static String? email(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return 'Enter your email address';
    if (!_emailPattern.hasMatch(email)) return 'Enter a valid email address';
    return null;
  }

  static String? signInPassword(String? value) =>
      value == null || value.isEmpty ? 'Enter your password' : null;

  static String? newPassword(String? value) {
    if (value == null || value.isEmpty) return 'Enter a password';
    if (value.length < minPasswordLength) {
      return 'Use at least $minPasswordLength characters';
    }
    return null;
  }

  static String? confirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) return 'Confirm your password';
    if (value != password) return 'Passwords do not match';
    return null;
  }
}
