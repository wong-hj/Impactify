import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:impactify_app/models/event.dart';


class EventRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Future<List<Event>> getAllEvents() async {
  //   try {
  //     QuerySnapshot snapshot = await _firestore.collection('events').where('status', isEqualTo: 'active').get();
      
  //     List<Event> events = snapshot.docs.map((doc) {
  //       print(Event.fromFirestore(doc).toJson().toString());
  //       return Event.fromFirestore(doc);
  //     }).toList();
  //     return events;
  //   } catch (e) {
  //     print('Error fetching events: $e');
  //     throw e;
  //   }

  // }

  Future<List<Event>> getAllEvents() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('events').where('status', isEqualTo: 'active').get();
      
      List<Event> events = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        print("Fetched data: $data");
        return Event.fromFirestore(doc);
      }).toList();
      return events;
    } catch (e) {
      print('Error fetching events: $e');
      throw e;
    }
  }
<<<<<<< HEAD

  Future<List<Activity>> fetchAllActivities() async {
    
    await Future.delayed(Duration(seconds: 1));
    List<Activity> activities = [];
    try {
      QuerySnapshot eventSnapshot = await _firestore
          .collection('events')
          .where('status', isEqualTo: 'active')
          .get();

      activities.addAll(
          eventSnapshot.docs.map((doc) => Event.fromFirestore(doc)).toList());

      QuerySnapshot speechSnapshot = await _firestore
          
          .collection('speeches')
          .where('status', isEqualTo: 'active')
          .get();
           
      activities.addAll(
          speechSnapshot.docs.map((doc) => Speech.fromFirestore(doc)).toList());
          
         
           // Print each activity
    activities.forEach((activity) {
      print(activity.toString());
    });
    
      return activities;
    } catch (e) {
      print('Error fetching activities: $e');
      throw e;
    }
  }

=======
  
>>>>>>> parent of 9f4a7c3 (splitted out speech and event for better filtering)
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

  Future<Event> getProjectById(String projectID) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('events').doc(projectID).get();
      if (doc.exists) {
        return Event.fromFirestore(doc);
      } else {
        throw Exception('Event not found');
      }
    } catch (e) {
      throw Exception('Error fetching event: $e');
    }
  }
}