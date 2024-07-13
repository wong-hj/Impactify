import 'package:cloud_firestore/cloud_firestore.dart';

class Participation {
  final String participationID;
  final String userID;
  final String activityID;
  final String type;

  Participation({
    required this.participationID,
    required this.userID,
    required this.activityID,
    required this.type,
  });

  factory Participation.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Participation(
      participationID: data['participationID'],
      userID: data['userID'],
      activityID: data['activityID'],
      type: data['type'],
    );
  }

  // Method to convert a Bookmark instance to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'participationID': participationID,
      'userID': userID,
      'activityID': activityID,
      'type': type,
    };
  }
}
