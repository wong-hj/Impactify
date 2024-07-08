import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String eventID;
  final String title;
  final String organizer;
  final String location;
  final Timestamp hostDate;
  final String description;
  final String eventImage;
  final String sdg;
  final int impointsAdd;
  final Timestamp createdAt;

  Event({
    required this.eventID,
    required this.title,
    required this.organizer,
    required this.location,
    required this.hostDate,
    required this.description,
    required this.eventImage,
    required this.sdg,
    required this.impointsAdd,
    required this.createdAt,
  });

  factory Event.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Event(
      eventID: data['eventID'],
      title: data['title'],
      organizer: data['organizer'],
      location: data['location'],
      hostDate: data['hostDate'],
      description: data['description'],
      eventImage: data['eventImage'],
      sdg: data['sdg'],
      impointsAdd: data['impointsAdd'],
      createdAt: data['createdAt'],
    );
  }

  // Method to convert an Event instance to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'eventID': eventID,
      'title': title,
      'organizer': organizer,
      'location': location,
      'hostDate': hostDate,
      'description': description,
      'eventImage': eventImage,
      'sdg': sdg,
      'impointsAdd': impointsAdd,
      'createdAt': createdAt,
    };
  }
}