import 'package:cloud_firestore/cloud_firestore.dart';

class Bookmark {
  final String bookmarkID;
  final String? eventID;
  final String? speechID;
  final String userID;

  Bookmark({
    required this.bookmarkID,
    this.eventID = "",
    this.speechID = "",
    required this.userID,
  });

  factory Bookmark.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Bookmark(
      bookmarkID: data['bookmarkID'],
      eventID: data['eventID'] ?? null,
      speechID: data['speechID'] ?? null,
      userID: data['userID'],
    );
  }

  // Method to convert a Bookmark instance to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'bookmarkID': bookmarkID,
      'eventID': eventID,
      'speechID': speechID,
      'userID': userID,
    };
  }
}
