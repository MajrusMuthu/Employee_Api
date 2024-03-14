// ignore_for_file: use_rethrow_when_possible

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  // Google sign-in
  Future<UserCredential> signInWithGoogle() async {
    try {
      // Begin the Google Sign-In interactive process
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

      // Obtain Auth details from the request
      final GoogleSignInAuthentication gAuth = await gUser!.authentication;

      // Create a new credential for the user
      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      // Finally, let's sign in
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      // Handle specific error cases
      if (e is FirebaseAuthException) {
        if (e.code == 'invalid-credential') {
          // Show a specific error message for invalid credential
          throw FirebaseAuthException(
            code: 'invalid-credential',
            message: 'Invalid Google credentials. Please try again.',
          );
        }
      }
      // Re-throw other exceptions
      throw e;
    }
  }
}
