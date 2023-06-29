import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone/state/constants/firebase_collection_names.dart';
import 'package:instagram_clone/state/constants/firebase_field_names.dart';
import 'package:instagram_clone/state/likes/models/like.dart';
import 'package:instagram_clone/state/likes/models/like_dislike_request.dart';

final likeDislikePostProvider =
    FutureProvider.family.autoDispose<bool, LikeDislikeRequest>((
  ref,
  LikeDislikeRequest request,
) async {
  final query = FirebaseFirestore.instance
      .collection(FirebaseCollectionNames.likes)
      .where(FirebaseFieldName.postId, isEqualTo: request.postId)
      .where(FirebaseFieldName.userId, isEqualTo: request.likedBy)
      .get();

  // First see if the user has already liked this post or not
  final hasLiked = await query.then((snapshot) => snapshot.docs.isNotEmpty);

  if (hasLiked) {
    // delete the like
    try {
      await query.then((snapshot) async {
        for (final doc in snapshot.docs) {
          await doc.reference.delete();
        }
      });
      return true;
    } catch (e) {
      return false;
    }
  } else {
    // post a like object
    final like = Like(
      postId: request.postId,
      likedBy: request.likedBy,
      dateTime: DateTime.now(),
    );

    try {
      await FirebaseFirestore.instance
          .collection(FirebaseCollectionNames.likes)
          .add(like);

      return true;
    } catch (e) {
      return false;
    }
  }
});
