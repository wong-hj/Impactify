import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String postID;
  final String postImage;
  final String title;
  final String description;
  final String activityID;
  final String userID;
  final int likes;
  final Timestamp createdAt;

  Post({
    required this.postID,
    required this.postImage,
    required this.title,
    required this.description,
    required this.activityID,
    required this.userID,
    required this.likes,
    required this.createdAt,
  });

  // Factory method to create an instance from Firestore data
  factory Post.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Post(
      postID: doc.id,
      postImage: data['postImage'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      activityID: data['activityID'] ?? '',
      userID: data['userID'] ?? '',
      likes: data['likes'] ?? 0,
      createdAt: data['createdAt'] ?? Timestamp.now(),
    );
  }

  // Method to convert an instance to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'postID': postID,
      'postImage': postImage,
      'title': title,
      'description': description,
      'activityID': activityID,
      'userID': userID,
      'likes': likes,
      'createdAt': createdAt,
    };
  }
}
