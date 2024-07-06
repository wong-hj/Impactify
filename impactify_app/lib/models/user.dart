import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String userID;
  final String fullName;
  final String username;
  final String email;
  final String? profileImage;
  final int impoints;
  final DateTime createdAt;


  User({
    required this.userID,
    required this.fullName,
    required this.username,
    required this.email,
    this.profileImage = "",
    required this.impoints,
    required this.createdAt,
  });

  factory User.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return User(
      userID: data['userID'],
      fullName: data['fullName'],
      username: data['username'],
      email: data['email'],
      profileImage: data['profileImage'] != "" ? data['profileImage'] : 'Empty Image',
      impoints: data['impoints'],
      createdAt: data['createdAt'],
    );
  }

  // Method to convert a User instance to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'userID': userID,
      'fullName': fullName,
      'username': username,
      'email': email,
      'profileImage': profileImage,
      'impoints': impoints,
      'createdAt': createdAt,
    };
  }
}
