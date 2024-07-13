import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:impactify_app/models/activity.dart';

class Speech implements Activity {
  final String speechID;
  final String image;
  final String title;
  final String organizer;
  final String location;
  final Timestamp hostDate;
  final String description;
  final String type;
  final String eventID;
  final Timestamp createdAt;
  final String status;
  final List<String> tags; 

  Speech({
    required this.speechID,
    required this.image,
    required this.title,
    required this.organizer,
    required this.location,
    required this.hostDate,
    required this.description,
    required this.type,
    required this.eventID,
    required this.createdAt,
    required this.status,
    required this.tags,

  });

  @override
  String get id => speechID;

  @override
  String toString() {
    return 'Speech: {type: $type, speechID: $speechID, title: $title, organizer: $organizer, location: $location, hostDate: $hostDate, description: $description, eventID: $eventID, createdAt: $createdAt, status: $status}';
  }

  factory Speech.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Speech(
      speechID: data['speechID'],
      image: data['image'],
      title: data['title'],
      organizer: data['organizer'],
      location: data['location'],
      hostDate: data['hostDate'],
      description: data['description'],
      type: data['type'],
      eventID: data['eventID'],
      createdAt: data['createdAt'],
      status: data['status'],
      tags: List<String>.from(data['tags'] ?? []),
    );
  }

  // Method to convert a Speech instance to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'speechID': speechID,
      'image': image,
      'title': title,
      'organizer': organizer,
      'location': location,
      'hostDate': hostDate,
      'description': description,
      'type': type,
      'eventID': eventID,
      'createdAt': createdAt,
      'status': status,
      'tags': tags,
    };
  }
}
