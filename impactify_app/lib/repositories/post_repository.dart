import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:impactify_app/models/activity.dart';
import 'package:impactify_app/models/event.dart';
import 'package:impactify_app/models/post.dart';
import 'package:impactify_app/models/speech.dart';
import 'package:impactify_app/models/user.dart';

class PostRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> addPost(String userID, XFile? image, String title,
      String description, String activityID) async {
    DocumentReference docRef;
    try {
      if (image != null) {
        String fileName =
            'posts/$userID/post_${DateTime.now().millisecondsSinceEpoch}.png';
        Reference storageRef = _storage.ref().child(fileName);
        UploadTask uploadTask = storageRef.putFile(File(image.path));
        TaskSnapshot taskSnapshot = await uploadTask;

        // Get download URL
        String downloadUrl = await taskSnapshot.ref.getDownloadURL();

        // Create a new document in the posts collection
        docRef = await _firestore.collection('posts').add(
          {
            'postImage': downloadUrl,
            'userID': userID,
            'title': title,
            'description': description,
            'activityID': activityID,
            'likes': 0,
            'createdAt': Timestamp.now(),
          },
        );

        // Update the document with the document ID as the bookmarkID
        await docRef.update({
          'postID': docRef.id,
        });
      }
    } catch (e) {
      throw Exception('Error adding bookmark: $e');
    }
  }

  Future<List<Post>> fetchAllPosts() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('posts').get();
      List<Post> posts = snapshot.docs.map((doc) => Post.fromFirestore(doc)).toList();

      for (Post post in posts) {
        post.user = await fetchUserByID(post.userID);
        post.activity = await fetchActivityByID(post.activityID);
      }

      return posts;
    } catch (e) {
      print('Error fetching posts: $e');
      throw e;
    }
  }

  Future<User?> fetchUserByID(String userID) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(userID).get();
      return User.fromFirestore(doc);
    } catch (e) {
      print('Error fetching user by ID: $e');
      return null;
    }
  }

  Future<Activity?> fetchActivityByID(String activityID) async {
    try {
      // Try fetching from events first
      DocumentSnapshot eventDoc = await _firestore.collection('events').doc(activityID).get();
      if (eventDoc.exists) {
        return Event.fromFirestore(eventDoc);
      }

      // If not found, try fetching from speeches
      DocumentSnapshot speechDoc = await _firestore.collection('speeches').doc(activityID).get();
      if (speechDoc.exists) {
        return Speech.fromFirestore(speechDoc);
      }

      return null;
    } catch (e) {
      print('Error fetching activity by ID: $e');
      return null;
    }
  }

  Future<void> likePost(String postID, String userID) async {
    DocumentReference postRef = _firestore.collection('posts').doc(postID);
    await postRef.update({
      'likes': FieldValue.arrayUnion([userID]),
    });
  }

  Future<void> unlikePost(String postID, String userID) async {
    DocumentReference postRef = _firestore.collection('posts').doc(postID);
    await postRef.update({
      'likes': FieldValue.arrayRemove([userID]),
    });
  }
}
