import 'package:email_validator/email_validator.dart';
import 'package:zxcvbn/zxcvbn.dart';

/// Reusable, pure form validators.
///
/// Every function returns the error reason as a [String], or `null` when the
/// value is valid. Compose them with the `??` operator so the first failing
/// check wins:
///
/// ```dart
/// final error = Validators.requiredText(name, field: 'Name')
///     ?? Validators.email(email);
/// ```
class Validators {
  Validators._();

  static final Zxcvbn _zxcvbn = Zxcvbn();

  /// Fails when [value] is null/blank.
  static String? requiredText(String? value, {required String field}) =>
      (value == null || value.trim().isEmpty) ? '$field ist erforderlich' : null;

  /// Fails when [value] is not a valid e-mail address.
  static String? email(String? value) => EmailValidator.validate((value ?? '').trim())
      ? null
      : 'Bitte eine gültige E-Mail eingeben';

  /// Fails when [a] and [b] differ (e.g. password confirmation).
  static String? match(String a, String b, {required String message}) =>
      a == b ? null : message;

  /// Fails when the password's zxcvbn score (0..4) is below [minScore].
  static String? passwordStrength(
    String value, {
    int minScore = 2,
    String message = 'Passwort ist zu schwach',
  }) => (_zxcvbn.evaluate(value).score ?? 0) < minScore ? message : null;

  /// Fails when [min] is greater than [max].
  static String? minNotAboveMax(int min, int max, {required String label}) =>
      min > max ? '$label: Min darf nicht über Max liegen.' : null;

  /// Fails when [value] is outside the inclusive [min]..[max] range.
  static String? inRange(
    int value, {
    required int min,
    required int max,
    required String message,
  }) => (value < min || value > max) ? message : null;
}
