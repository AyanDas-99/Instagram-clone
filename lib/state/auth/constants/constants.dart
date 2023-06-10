import 'package:flutter/foundation.dart' show immutable;

@immutable
class Constants {
  // Static can be accessed without class instances
  static const accountExistsWithDifferentCredentials =
      'account-exists-with-different-credentials';
  static const googleCom = 'google.com';
  static const emailScope = 'email';
  // This is a private constructor
  // Meaning instances of this class cannot be created
  const Constants._();
}
