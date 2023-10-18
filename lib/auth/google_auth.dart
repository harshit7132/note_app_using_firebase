import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthServices {
//* Google Sign Sign
  signupWithGoogle() async {
//* Begin sign in process
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

//* Obtain auth Request
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

//* Create Credential for user

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

//*Finally Logged in

    var checkAuth =
        await FirebaseAuth.instance.signInWithCredential(credential);

    return checkAuth.user!.uid;
  }
}
