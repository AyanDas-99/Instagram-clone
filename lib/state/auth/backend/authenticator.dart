import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:instagram_clone/state/auth/constants/constants.dart';
import 'package:instagram_clone/state/auth/models/auth_results.dart';
import 'package:instagram_clone/state/posts/typedef/user_id.dart';

class Authenticator {
  const Authenticator();
  UserId? get userId => FirebaseAuth.instance.currentUser?.uid;

  bool get isAlreadyLoggedIn => userId != null;

  String get displayName =>
      FirebaseAuth.instance.currentUser?.displayName ?? '';

  String? get email => FirebaseAuth.instance.currentUser?.email;

  Future<void> logOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
  }

  // Future<AuthResult> loginWithFacebook() async {
  //   final loginResult = await FacebookAuth.instance.login();
  //   final token = loginResult.accessToken?.token;
  //   if (token == null) {
  //     return AuthResult.aborted;
  //   }
  //   final oauthCredentials = FacebookAuthProvider.credential(token);
  //   try {
  //     await FirebaseAuth.instance.signInWithCredential(oauthCredentials);
  //     return AuthResult.success;
  //   } on FirebaseAuthException catch (e) {
  //     final email = e.email;
  //     final credential = e.credential;
  //     if (e.code == Constants.accountExistsWithDifferentCredentials &&
  //         email != null &&
  //         credential != null) {
  //       final providers =
  //           await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
  //       if (providers.contains(Constants.googleCom)) {
  //         await loginWithGoogle();
  //         FirebaseAuth.instance.currentUser?.linkWithCredential(credential);
  //         return AuthResult.success;
  //       }
  //     }

  //     return AuthResult.failure;
  //   }
  // }

  Future<AuthResult> loginWithGoogle() async {
    final GoogleSignIn googleSignIn =
        GoogleSignIn(scopes: [Constants.emailScope]);
    final signInAccount = await googleSignIn.signIn();
    if (signInAccount == null) {
      return AuthResult.aborted;
    }
    final googleAuth = await signInAccount.authentication;
    final oAuthCredential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken, accessToken: googleAuth.idToken);
    try {
      await FirebaseAuth.instance.signInWithCredential(oAuthCredential);
      return AuthResult.success;
    } catch (e) {
      return AuthResult.failure;
    }
  }
}
