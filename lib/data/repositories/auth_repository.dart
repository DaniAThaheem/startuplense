import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/services/auth_services.dart';

class AuthRepository {
  final AuthService _authService = AuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  Future<void> signInWithGoogle() async {
    try {
      final credential = await _authService.signInWithGoogle();
      final user = credential.user;

      if (user == null) {
        throw Exception("Google login failed");
      }

      final userDoc =
      await _firestore.collection('users').doc(user.uid).get();

      // 🔥 KEY LOGIC: check if user exists
      if (!userDoc.exists) {
        // New user → create Firestore document
        await _firestore.collection('users').doc(user.uid).set({
          "profile": {
            "name": user.displayName ?? "",
            "email": user.email ?? "",
            "photoURL": user.photoURL ?? "",
            "university": "",
          },
          "settings": {
            "notificationEnabled": false,
          },
          "stats": {
            "averageScore": 0,
            "bestScore": 0,
            "ideasAnalyzed": 0,
            "totalIdeas": 0,
          },
          "timestamps": {
            "createdAt": FieldValue.serverTimestamp(),
            "lastLogin": FieldValue.serverTimestamp(),
          }
        });
      } else {
        // Existing user → just update last login
        await _firestore.collection('users').doc(user.uid).update({
          "timestamps.lastLogin": FieldValue.serverTimestamp(),
        });
      }

    } catch (e) {
      print("Google Sign-In Error: $e");
      rethrow;
    }
  }


  Future<void> logout() async {
    try {
      await _authService.logout();
    } catch (e) {
      throw "Logout failed";
    }
  }


  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      // Step 1: Firebase Auth login
      UserCredential credential = await _authService.loginWithEmail(
        email: email,
        password: password,
      );

      final user = credential.user;

      if (user == null) {
        throw Exception("Login failed");
      }

      // Step 2: Update lastLogin (important for tracking)
      await _firestore.collection('users').doc(user.uid).update({
        "timestamps.lastLogin": FieldValue.serverTimestamp(),
      });

    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? "Login failed");
    } catch (e) {
      throw Exception("Something went wrong");
    }
  }

  Future<void> signup({
    required String name,
    required String email,
    required String password,
    required String university,
  }) async {
    try {
      // Step 1: Create user in Firebase Auth
      UserCredential credential = await _authService.signUpWithEmail(
        email: email,
        password: password,
      );

      final user = credential.user;

      if (user == null) {
        throw Exception("User creation failed");
      }

      final userId = user.uid;

      // Step 2: Create Firestore document
      await _firestore.collection('users').doc(userId).set({
        "profile": {
          "name": name,
          "email": email,
          "photoURL": "",
          "university": university,
        },
        "settings": {
          "notificationEnabled": false,
        },
        "stats": {
          "averageScore": 0,
          "bestScore": 0,
          "ideasAnalyzed": 0,
          "totalIdeas": 0,
        },
        "timestamps": {
          "createdAt": FieldValue.serverTimestamp(),
          "lastLogin": FieldValue.serverTimestamp(),
        }
      });
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? "Signup failed");
    } catch (e) {
      throw Exception("Something went wrong");
    }
  }
}