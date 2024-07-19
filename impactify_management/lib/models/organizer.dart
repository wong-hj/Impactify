import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:impactify_management/constants/placeholderURL.dart';

class Organizer {
  final String organizerID;
  final String fullName;
  final String username;
  final String email;
  final String profileImage;
  final String organizationName;
  final String? ssm;
  final String? ssmURL;
  final Timestamp createdAt;

  Organizer({
    required this.organizerID,
    required this.fullName,
    required this.username,
    required this.email,
    required this.profileImage,
    required this.organizationName,
    this.ssm,
    this.ssmURL,
    required this.createdAt,
  });

  factory Organizer.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Organizer(
      organizerID: doc.id,
      fullName: data['fullName'],
      username: data['username'],
      email: data['email'],
      profileImage: data['profileImage'] != "userPlaceholder" ? data['profileImage'] : userPlaceholder,
      organizationName: data['organizationName'],
      ssm: data['ssm'],
      ssmURL: data['ssmURL'],
      createdAt: data['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'organizerID': organizerID,
      'fullName': fullName,
      'username': username,
      'email': email,
      'profileImage': profileImage,
      'organizationName': organizationName,
      'ssm': ssm,
      'ssmURL': ssmURL,
      'createdAt': createdAt,
    };
  }
}
