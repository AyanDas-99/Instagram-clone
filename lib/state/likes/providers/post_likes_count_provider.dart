import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone/state/constants/firebase_collection_names.dart';
import 'package:instagram_clone/state/constants/firebase_field_names.dart';
import 'package:instagram_clone/state/posts/typedef/post_id.dart';

final postLikesCountProvider = StreamProvider.family.autoDispose<int, PostId>((
  ref,
  PostId postId,
) {
  final controller = StreamController<int>.broadcast();

  controller.onListen = () {
    controller.sink.add(0);
  };

  final sub = FirebaseFirestore.instance
      .collection(FirebaseCollectionNames.likes)
      .where(FirebaseFieldName.postId, isEqualTo: postId)
      .snapshots()
      .listen((snapshot) {
    controller.sink.add(snapshot.docs.length);
  });

  ref.onDispose(() {
    controller.close();
    sub.cancel();
  });

  return controller.stream;
});
