import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:impactify_app/models/activity.dart';
import 'package:impactify_app/models/project.dart';
import 'package:impactify_app/models/speech.dart';
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

  Future<String> fetchPostCount(String userID) async {
    String postCount = '0';

    try {
      QuerySnapshot postSnapshot = await _firestore
          .collection('posts')
          .where('userID', isEqualTo: userID)
          .get();

      postCount = postSnapshot.size.toString();

    } catch(e) {

      print('Error fetching postCount: $e');

    }


    return postCount;
  }

  Future<String> fetchLikeCount(String userID) async {
    String likeCount = '0';
    int likeCounts = 0;

    try {
      QuerySnapshot postSnapshot = await _firestore
          .collection('posts')
          .where('userID', isEqualTo: userID)
          .get();

      for (var doc in postSnapshot.docs) {
      List<dynamic> likes = doc['likes'];
      likeCounts += likes.length;
      likeCount = likeCounts.toString();
    }

    } catch(e) {

      print('Error fetching postCount: $e');

    }


    return likeCount;
  }

  Future<String> fetchParticipationCount(String userID) async {
    String participationCount = '0';

    try {
      QuerySnapshot participationSnapshot = await _firestore
          .collection('participation')
          .where('userID', isEqualTo: userID)
          .get();
      participationCount = participationSnapshot.size.toString();

    } catch(e) {

      print('Error fetching postCount: $e');
      
    }


    return participationCount;
  }


  Future<List<Activity>> fetchUserHistory(String userID) async {
    List<Activity> history = [];
    try {
      QuerySnapshot participationSnapshot = await _firestore
          .collection('participation')
          .where('userID', isEqualTo: userID)
          .get();

      // Extract activity IDs from participations
      List<String> activityIDs = participationSnapshot.docs
          .map((doc) => doc['activityID'] as String)
          .toList();

      if (activityIDs.isEmpty) {
        return history;
      }

      // Fetch events matching the activity IDs and filter them
      QuerySnapshot eventSnapshot = await _firestore
          .collection('events')
          .where('eventID', whereIn: activityIDs)
          .where('hostDate', isLessThan: Timestamp.now())
          .get();

      history.addAll(
          eventSnapshot.docs.map((doc) => Event.fromFirestore(doc)).toList());

      // Fetch speeches matching the activity IDs and filter them
      QuerySnapshot speechSnapshot = await _firestore
          .collection('speeches')
          .where('speechID', whereIn: activityIDs)
          .where('hostDate', isLessThan: Timestamp.now())
          .get();

      history.addAll(
          speechSnapshot.docs.map((doc) => Speech.fromFirestore(doc)).toList());
          
      return history;
    } catch (e) {
      print('Error fetching activities: $e');
      throw e;
    }
  }

  

}
