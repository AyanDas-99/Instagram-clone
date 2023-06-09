import 'dart:collection' show MapView;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:instagram_clone/state/constants/firebase_field_names.dart';
import 'package:instagram_clone/state/posts/typedef/post_id.dart';
import 'package:instagram_clone/state/posts/typedef/user_id.dart';

@immutable
class CommentPayload extends MapView<String, dynamic> {
  CommentPayload({
    required UserId userId,
    required PostId postId,
    required String comment,
  }) : super({
          FirebaseFieldName.userId: userId,
          FirebaseFieldName.postId: postId,
          FirebaseFieldName.comment: comment,
          FirebaseFieldName.createdAt: FieldValue.serverTimestamp()
        });
}
