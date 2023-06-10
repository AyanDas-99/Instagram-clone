import 'dart:collection' show MapView;
import 'package:flutter/foundation.dart' show immutable;
import 'package:instagram_clone/state/auth/posts/typedef/user_id.dart';
import 'package:instagram_clone/state/constants/firebase_field_names.dart';

// This class automatically converts the data into a map which can then be easily serialized into json

@immutable
class UserInfoPayload extends MapView<String, String> {
  UserInfoPayload(
      {required UserId userId,
      required String? displayName,
      required String? email})
      : super({
          FirebaseFieldName.userId: userId,
          FirebaseFieldName.displayName: displayName ?? '',
          FirebaseFieldName.email: email ?? '',
        });
}
