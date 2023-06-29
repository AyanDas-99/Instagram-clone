import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone/state/constants/firebase_collection_names.dart';
import 'package:instagram_clone/state/constants/firebase_field_names.dart';
import 'package:instagram_clone/state/image_upload/extensions/get_collection_name_from_file_type.dart';
import 'package:instagram_clone/state/image_upload/typedefs/is_loading.dart';
import 'package:instagram_clone/state/posts/models/post.dart';
import 'package:instagram_clone/state/posts/typedef/post_id.dart';

class DeletePostStateNotifier extends StateNotifier<IsLoading> {
  DeletePostStateNotifier() : super(false);

  set isLoading(bool value) => state = value;

  Future<bool> deletePost({required Post post}) async {
    isLoading = true;

    try {
      // delete the post's thumbnail
      await FirebaseStorage.instance
          .ref()
          .child(post.userId)
          .child(FirebaseCollectionNames.thumbnails)
          .child(post.thumbnailStorageId)
          .delete();

      // delete post's original file
      await FirebaseStorage.instance
          .ref()
          .child(post.userId)
          .child(post.fileType.collectionName)
          .child(post.originalFileStorageId)
          .delete();

      // delete all comments associated with the post
      await _deleteAllDocuments(
          postId: post.postId, inCollection: FirebaseCollectionNames.comments);

      // delete all likes associated with the post
      await _deleteAllDocuments(
          postId: post.postId, inCollection: FirebaseCollectionNames.likes);

      // finally delete the post itself
      final postInCollection = await FirebaseFirestore.instance
          .collection(FirebaseCollectionNames.posts)
          .where(FieldPath.documentId, isEqualTo: post.postId)
          .limit(1)
          .get();

      for (final doc in postInCollection.docs) {
        await doc.reference.delete();
      }

      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> _deleteAllDocuments(
      {required PostId postId, required String inCollection}) {
    return FirebaseFirestore.instance.runTransaction(
        maxAttempts: 3,
        timeout: const Duration(seconds: 20), (transaction) async {
      final query = await FirebaseFirestore.instance
          .collection(inCollection)
          .where(FirebaseFieldName.postId, isEqualTo: postId)
          .get();

      for (final doc in query.docs) {
        transaction.delete(doc.reference);
      }
    });
  }
}
