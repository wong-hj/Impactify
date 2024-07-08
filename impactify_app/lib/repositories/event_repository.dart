import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:impactify_app/models/event.dart';


class EventRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Event>> getAllEvents() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('events').get();
      List<Event> events = snapshot.docs.map((doc) {
        return Event.fromFirestore(doc);
      }).toList();
      return events;
    } catch (e) {
      print('Error fetching events: $e');
      throw e;
    }

  }
  
  Future<Event> getEventById(String eventID) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('events').doc(eventID).get();
      
      if (doc.exists) {
        return Event.fromFirestore(doc);
      } else {
        throw Exception('Event not found');
      }

    } catch (e) {
      print('Error fetching event: $e');
      throw e;
    }
  }
}