import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:impactify_management/models/organizer.dart';

class AuthRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<User?> signInWithEmail(String email, String password) async {
    try {
      final UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print('Error signing in with email: $e');
      return null;
    }
  }


  // Sign up with email and password and save user info in Firestore
  Future<User?> signUpWithEmail(
      String email,
      String password,
      String fullName,
      String username,
      String organizationName,
      String? ssmNumber,
      XFile? ssmFile) async {
    try {
      final UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final User? user = userCredential.user;

      if (user != null) {
        String? ssmUrl;

        if (ssmNumber != null && ssmFile != null) {
          try {
            String fileName =
                'ssm/${user.uid}_${DateTime.now().millisecondsSinceEpoch}.pdf';
            Reference storageRef =
                FirebaseStorage.instance.ref().child(fileName);
            UploadTask uploadTask = storageRef.putFile(File(ssmFile.path));
            TaskSnapshot taskSnapshot = await uploadTask;
            ssmUrl = await taskSnapshot.ref.getDownloadURL();
          } catch (e) {
            print('Error uploading SSM PDF: $e');
          }
        }

        Organizer newUser = Organizer(
          organizerID: user.uid,
          fullName: fullName,
          username: username,
          email: email,
          profileImage: "userPlaceholder",
          organizationName: organizationName,
          ssm: ssmNumber,
          ssmURL: ssmUrl,
          createdAt: Timestamp.now(),
        );

        await _firestore
            .collection('organizers')
            .doc(user.uid)
            .set(newUser.toJson());

        return user;
      }
    } catch (e) {
      print('Error signing up with email: $e');
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
}
