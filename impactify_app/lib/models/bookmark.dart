import 'package:cloud_firestore/cloud_firestore.dart';

class Bookmark {
  final String bookmarkID;
  final String eventID;
  final String userID;

  Bookmark({
    required this.bookmarkID,
<<<<<<< HEAD
    this.eventID = "",
    this.speechID = "",
=======
    required this.eventID,
>>>>>>> parent of 9f4a7c3 (splitted out speech and event for better filtering)
    required this.userID,
  });

  factory Bookmark.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Bookmark(
      bookmarkID: data['bookmarkID'],
<<<<<<< HEAD
      eventID: data['eventID'] ?? null,
      speechID: data['speechID'] ?? null,
=======
      eventID: data['eventID'],
>>>>>>> parent of 9f4a7c3 (splitted out speech and event for better filtering)
      userID: data['userID'],
    );
  }

  // Method to convert a Bookmark instance to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'bookmarkID': bookmarkID,
      'eventID': eventID,
      'userID': userID,
    };
  }
}
