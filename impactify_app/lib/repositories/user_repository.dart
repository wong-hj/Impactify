import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:impactify_app/models/user.dart';

class UserRepository {
  final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Get the current user
  auth.User? get currentUser => _firebaseAuth.currentUser;

  // Fetch user data from Firestore
  Future<User?> getUserData(String uid) async {
    try {
      final DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        print('fetching user data: ' + doc.toString());
        return User.fromFirestore(doc);
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching user data: $e');
      return null;
    }
  }

  // Fetch user data from Firestore
  Future<void> updateUserData(String uid, Map<String, dynamic> data, XFile? imageFile) async {
    try {
      if (imageFile != null) {
        String fileName = 'users/$uid/profile_${DateTime.now().millisecondsSinceEpoch}.png';
        Reference storageRef = _storage.ref().child(fileName);
        UploadTask uploadTask = storageRef.putFile(File(imageFile.path));
        TaskSnapshot taskSnapshot = await uploadTask;

        // Get download URL
        String downloadUrl = await taskSnapshot.ref.getDownloadURL();

        // Update the data map with the image URL
        data['profileImage'] = downloadUrl;
      }
      await _firestore.collection('users').doc(uid).update(data);
    } catch (e) {
      print('Error updating user data: $e');
      throw e;
    }
  }

}
