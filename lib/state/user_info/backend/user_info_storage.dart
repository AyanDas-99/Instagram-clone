import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:instagram_clone/state/auth/posts/typedef/user_id.dart';
import 'package:instagram_clone/state/constants/firebase_collection_names.dart';
import 'package:instagram_clone/state/constants/firebase_field_names.dart';
import 'package:instagram_clone/state/user_info/models/user_info_payload.dart';

@immutable
class UserInfoStorage {
  const UserInfoStorage();

  /* 
  If user exists:
      Get the user and update the displayName and email with the one provided
  If user doesn't exist:
     Create a user payload and store it in the users collection
  */
  Future<bool> saveUserInfo(
      {required UserId userId,
      required String displayName,
      required String? email}) async {
    try {
      //  Check if user exists
      final userInfo = await FirebaseFirestore.instance
          .collection(FirebaseCollectionNames.users)
          .where(FirebaseFieldName.userId, isEqualTo: userId)
          .limit(1)
          .get();

      if (userInfo.docs.isNotEmpty) {
        // we already have this user's info
        // update with the new displayName and email
        await userInfo.docs.first.reference.update({
          FirebaseFieldName.displayName: displayName,
          FirebaseFieldName.email: email
        });
        return true;
      }
      // we don't have this user
      // create new user
      final payload = UserInfoPayload(
          userId: userId, displayName: displayName, email: email);
      await FirebaseFirestore.instance
          .collection(FirebaseCollectionNames.users)
          .add(payload);
      return true;
    } catch (e) {
      return false;
    }
  }
}
