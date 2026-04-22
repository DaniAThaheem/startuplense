import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential> signInWithGoogle() async {
    // Step 1 — triggers the system account picker sheet
    final GoogleSignInAccount googleUser =
    await GoogleSignIn.instance.authenticate();

    // Step 2 — get accessToken via authorizeScopes (mandatory in v7)
    final clientAuth = await googleUser.authorizationClient
        .authorizeScopes(['email', 'profile']);

    // Step 3 — build Firebase credential with BOTH tokens
    final credential = GoogleAuthProvider.credential(
      idToken: googleUser.authentication.idToken,
      accessToken: clientAuth.accessToken,
    );

    // Step 4 — sign into Firebase
    return await _auth.signInWithCredential(credential);
  }


  User? getCurrentUser() {
    return _auth.currentUser;
  }

  //SignUp using email password

  Future<UserCredential> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }


  //Login Using email password

  Future<UserCredential> loginWithEmail({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
}