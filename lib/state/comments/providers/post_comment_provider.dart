import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone/state/comments/extensions/comment_sorting_by_request.dart';
import 'package:instagram_clone/state/comments/models/comment.dart';
import 'package:instagram_clone/state/comments/models/post_comment_request.dart';
import 'package:instagram_clone/state/constants/firebase_collection_names.dart';
import 'package:instagram_clone/state/constants/firebase_field_names.dart';

final postCommentProvider = StreamProvider.family
    .autoDispose<Iterable<Comment>, RequestForPostAndComments>(
        (ref, RequestForPostAndComments request) {
  final controller = StreamController<Iterable<Comment>>();
  final sub = FirebaseFirestore.instance
      .collection(FirebaseCollectionNames.comments)
      .where(FirebaseFieldName.postId, isEqualTo: request.postId)
      .snapshots()
      .listen((snapshot) {
    final documents = snapshot.docs;
    final limitedDocs =
        request.limit == null ? documents : documents.take(request.limit!);
    final comments = limitedDocs
        .where((doc) => !doc.metadata.hasPendingWrites)
        .map((document) => Comment(
              document.data(),
              id: document.id,
            ));
    final result = comments.applySortingFrom(request);
    controller.sink.add(result);
  });

  ref.onDispose(() {
    sub.cancel();
    controller.close();
  });
  return controller.stream;
});
