import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:impactify_app/models/user.dart';


class AuthRepository {
  final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Get the current user
  auth.User? get currentUser => _firebaseAuth.currentUser;
  

  // Sign up with email and password and save user info in Firestore
  Future<auth.User?> signUpWithEmail(String email, String password, String fullName, String username) async {
    try {
      final auth.UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final auth.User? user = userCredential.user;

      if (user != null) {
        User newUser = User(
          userID: user.uid,
          fullName: fullName,
          username: username,
          email: email,
          profileImage: "userPlaceholder", 
          impoints: 0,
          createdAt: Timestamp.now(),
        );

        await _firestore.collection('users').doc(user.uid).set(newUser.toJson());
      }

      return user;
    } catch (e) {
      print('Error signing up with email: $e');
      return null;
    }
  }


  // Sign in with email and password
  Future<auth.User?> signInWithEmail(String email, String password) async {
    try {
      final auth.UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print('Error signing in with email: $e');
      return null;
    }
  }

  // Sign in with Google
  Future<auth.User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final auth.AuthCredential credential = auth.GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        final auth.UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
        final auth.User? _user = userCredential.user;
        return _user;
      }
    } catch (e) {
      print('Error signing in with Google: $e');
      return null;
    }
    return null;
  }

  // Sign out
  Future<void> logout() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  // Get currently signed-in user
  auth.User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

}