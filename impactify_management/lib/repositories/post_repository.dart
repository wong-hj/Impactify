import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:impactify_management/models/activity.dart';
import 'package:impactify_management/models/post.dart';
import 'package:impactify_management/models/project.dart';
import 'package:impactify_management/models/speech.dart';
import 'package:impactify_management/models/user.dart';

class PostRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<List<Post>> fetchAllPostsByOrganizerID(String organizerID) async {
    List<String> activityIDs = [];
    List<Post> posts = [];

    try {
      // Fetch all events organized by the organizer
      QuerySnapshot projectsSnapshot = await _firestore
          .collection('events')
          .where('organizerID', isEqualTo: organizerID)
          .get();

      // Add eventIDs to activityIDs list
      activityIDs.addAll(projectsSnapshot.docs
          .map((doc) => doc['eventID'] as String)
          .toList());

      // Fetch all speeches organized by the organizer
      QuerySnapshot speechesSnapshot = await _firestore
          .collection('speeches')
          .where('organizerID', isEqualTo: organizerID)
          .get();

      // Add speechIDs to activityIDs list
      activityIDs.addAll(speechesSnapshot.docs
          .map((doc) => doc['speechID'] as String)
          .toList());

      // Fetch all posts associated with the collected activityIDs
      for (String activityID in activityIDs) {
        QuerySnapshot snapshot = await _firestore
            .collection('posts')
            .where('activityID', isEqualTo: activityID)
            .get();

        posts.addAll(
            snapshot.docs.map((doc) => Post.fromFirestore(doc)).toList());
      }

      // Fetch and assign user data for each post
      for (Post post in posts) {
        post.user = await fetchUserByID(post.userID);
      }

      return posts;
    } catch (e) {
      print('Error fetching posts: $e');
      throw e;
    }
  }

  Future<User?> fetchUserByID(String userID) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(userID).get();
      return User.fromFirestore(doc);
    } catch (e) {
      print('Error fetching user by ID: $e');
      return null;
    }
  }

  Future<List<Post>> fetchAllPostsByActivityID(String activityID) async {
    
    List<Post> posts = [];

    try {

        QuerySnapshot snapshot = await _firestore
            .collection('posts')
            .where('activityID', isEqualTo: activityID)
            .get();

        posts = 
            snapshot.docs.map((doc) => Post.fromFirestore(doc)).toList();
      

      // Fetch and assign user data for each post
      for (Post post in posts) {
        post.user = await fetchUserByID(post.userID);
      }

      return posts;
    } catch (e) {
      print('Error fetching posts: $e');
      throw e;
    }
  }
}
