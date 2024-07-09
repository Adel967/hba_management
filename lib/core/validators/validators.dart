class Validators {
  static final RegExp _emailRegExp =
      RegExp(r'^(\w[\.?\w]+)@[a-zA-Z\-]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$');

  static final RegExp _passwordRegExp = RegExp(
    r'^.{6,26}$',
  );

  static bool isValidPassword(String password) =>
      _passwordRegExp.hasMatch(password);

  static bool isValidEmail(String email) => _emailRegExp.hasMatch(email);

  static bool isNotEmptyString(String string) => string.trim() != '';
}
