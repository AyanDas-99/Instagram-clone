import 'package:flutter/foundation.dart' show immutable;

@immutable
class Constants {
  static const allowLikesTitle = 'Allow likes';
  static const allowLikesDescription =
      'By allowing likes, users will be able to like this post';
  static const allowLikesStorageKey = 'allow_likes';
  static const allowCommentsTitle = 'Allow Comments';
  static const allowCommentsDescription =
      'By allowing likes, users will be able to like this post';
  static const allowCommentsStorageKey = 'allow_comments';

  const Constants._();
}
