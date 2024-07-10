import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String eventID;
  final String title;
  final String organizer;
  final String location;
  final Timestamp hostDate;
  final String description;
  final String image;
  final String sdg;
  final int impointsAdd;
  final Timestamp createdAt;
  final String type;
  final String status;

  Event({
    required this.eventID,
    required this.title,
    required this.organizer,
    required this.location,
    required this.hostDate,
    required this.description,
    required this.image,
    required this.sdg,
    required this.impointsAdd,
    required this.createdAt,
    required this.type,
    required this.status,
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
      image: data['image'],
      sdg: data['sdg'],
      impointsAdd: data['impointsAdd'],
      createdAt: data['createdAt'],
      type: data['type'],
      status: data['status'],
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
      'image': image,
      'sdg': sdg,
      'impointsAdd': impointsAdd,
      'createdAt': createdAt,
      'type': type,
      'status': status,
    };
  }
}