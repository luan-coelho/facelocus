class FieldsValidator {
  static const String emailRegexPattern =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";

  static bool validateCPF(String cpf) {
    if (cpf.length < 11 || cpf.length > 14) {
      return false;
    }

    List<int> digits = cpf.split('').map((e) => int.parse(e)).toList();

    int sum = 0;
    for (int i = 0; i < 9; i++) {
      sum += digits[i] * (10 - i);
    }
    int remainder = sum % 11;
    int firstVerificationDigit = (remainder < 2) ? 0 : 11 - remainder;

    if (digits[9] != firstVerificationDigit) {
      return false;
    }

    sum = 0;
    for (int i = 0; i < 10; i++) {
      sum += digits[i] * (11 - i);
    }
    remainder = sum % 11;
    int secondVerificationDigit = (remainder < 2) ? 0 : 11 - remainder;

    return digits[10] == secondVerificationDigit;
  }

  static bool validateEmail(String email) {
    RegExp emailRegex = RegExp(emailRegexPattern, caseSensitive: false);
    return emailRegex.hasMatch(email);
  }
}
