import 'package:cloud_firestore/cloud_firestore.dart';

class Bookmark {
  final String bookmarkID;
  final String eventID;
  final String userID;

  Bookmark({
    required this.bookmarkID,
    required this.eventID,
    required this.userID,
  });

  factory Bookmark.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Bookmark(
      bookmarkID: data['bookmarkID'],
      eventID: data['eventID'],
      userID: data['userID'],
    );
  }

  // Method to convert a Speech instance to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'bookmarkID': bookmarkID,
      'eventID': eventID,
      'userID': userID,
    };
  }
}
