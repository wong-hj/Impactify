import 'package:cloud_firestore/cloud_firestore.dart';

class Speech {
  final String speechID;
  final String title;
  final String organizer;
  final String location;
  final Timestamp hostDate;
  final String description;
  final String eventID;
  final Timestamp createdAt;

  Speech({
    required this.speechID,
    required this.title,
    required this.organizer,
    required this.location,
    required this.hostDate,
    required this.description,
    required this.eventID,
    required this.createdAt,
  });

  factory Speech.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Speech(
      speechID: data['speechID'],
      title: data['title'],
      organizer: data['organizer'],
      location: data['location'],
      hostDate: data['hostDate'],
      description: data['description'],
      eventID: data['eventID'],
      createdAt: data['createdAt'],
    );
  }

  // Method to convert a Speech instance to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'speechID': speechID,
      'title': title,
      'organizer': organizer,
      'location': location,
      'hostDate': hostDate,
      'description': description,
      'eventID': eventID,
      'createdAt': createdAt,
    };
  }
}