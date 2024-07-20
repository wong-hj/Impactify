import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:impactify_app/models/activity.dart';
import 'package:impactify_app/models/project.dart';
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
            'likes': [],
            'createdAt': Timestamp.now(),
          },
        );

        // Update the document with the document ID as the bookmarkID
        await docRef.update({
          'postID': docRef.id,
        });
      }
    } catch (e) {
      throw Exception('Error adding post: $e');
    }
  }

  Future<void> editPost(String postID, XFile? image, String title,
      String description, String activityID, String userID) async {
    try {
      Map<String, dynamic> updatedData = {
        'title': title,
        'description': description,
        'activityID': activityID,
      };

      if (image != null) {
        String fileName =
            'posts/$userID/post_${DateTime.now().millisecondsSinceEpoch}.png';
        Reference storageRef = _storage.ref().child(fileName);
        UploadTask uploadTask = storageRef.putFile(File(image.path));
        TaskSnapshot taskSnapshot = await uploadTask;

        // Get download URL
        String downloadUrl = await taskSnapshot.ref.getDownloadURL();
        updatedData['postImage'] = downloadUrl;
      }

      // Update document in the posts collection
      await _firestore.collection('posts').doc(postID).update(updatedData);
      
    } catch (e) {
      throw Exception('Error updating post: $e');
    }
  }

  Future<List<Post>> fetchAllPosts() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('posts').get();
      List<Post> posts =
          snapshot.docs.map((doc) => Post.fromFirestore(doc)).toList();

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

  Future<List<Post>> fetchAllPostsByUserID(String userID) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('posts')
          .where('userID', isEqualTo: userID)
          .get();

      List<Post> posts =
          snapshot.docs.map((doc) => Post.fromFirestore(doc)).toList();

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

  Future<Post> fetchPostByPostID(String postID) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('posts').doc(postID).get();

      Post post = Post.fromFirestore(doc);

      post.user = await fetchUserByID(post.userID);
      post.activity = await fetchActivityByID(post.activityID);

      return post;
    } catch (e) {
      print('Error fetching posts: $e');
      throw e;
    }
  }

  Future<List<Post>> fetchFilteredPosts(String filter, List<String> tagIDs,
      DateTime? startDate, DateTime? endDate) async {
    List<Post> posts = [];
    try {
      Query postQuery = _firestore.collection('posts');

      // Adding the date range filter
      if (startDate != null && endDate != null) {
        postQuery = postQuery
            .where('createdAt',
                isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
            .where('createdAt',
                isLessThanOrEqualTo: Timestamp.fromDate(endDate));
      }

      QuerySnapshot postSnapshot = await postQuery.get();
      posts = postSnapshot.docs.map((doc) => Post.fromFirestore(doc)).toList();
      List<Post> postsToRemove = []; // List to keep track of posts to remove
      for (Post post in posts) {
        post.user = await fetchUserByID(post.userID);

        // Fetch activity and filter by type and tags if provided
        Activity? activity = await fetchActivityByID(post.activityID);
        print(activity);
        print(filter);

        if (activity != null &&
            (filter == 'All' || activity.type == filter.toLowerCase()) &&
            (tagIDs.isEmpty || activity.tags.any(tagIDs.contains))) {
          post.activity = activity;
        } else {
          // Remove posts that don't match the criteria
          postsToRemove.add(post);
        }
      }

      // Remove posts that don't match the criteria
      posts.removeWhere((post) => postsToRemove.contains(post));

      return posts;
    } catch (e) {
      print('Error fetching filtered posts: $e');
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

  Future<Activity?> fetchActivityByID(String activityID) async {
    try {
      // Try fetching from events first
      DocumentSnapshot eventDoc =
          await _firestore.collection('events').doc(activityID).get();
      if (eventDoc.exists) {
        return Event.fromFirestore(eventDoc);
      }

      // If not found, try fetching from speeches
      DocumentSnapshot speechDoc =
          await _firestore.collection('speeches').doc(activityID).get();
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

  Future<void> deletePost(String postID) {
    try {
      return _firestore.collection('posts').doc(postID).delete();
    } catch (e) {
      throw Exception('Error deleting post: $e');
    }
  }
}
