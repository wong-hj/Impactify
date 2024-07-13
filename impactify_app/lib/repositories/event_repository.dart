import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:impactify_app/models/activity.dart';
import 'package:impactify_app/models/event.dart';
import 'package:impactify_app/models/speech.dart';
import 'package:impactify_app/models/tag.dart';

class EventRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  Future<List<Event>> getAllEvents() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('events')
          .where('status', isEqualTo: 'active')
          .get();

      List<Event> events = snapshot.docs.map((doc) {
        //Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        //print("Fetched data: $data");
        return Event.fromFirestore(doc);
      }).toList();
      return events;
    } catch (e) {
      print('Error fetching events: $e');
      throw e;
    }
  }

  Future<List<Tag>> fetchAllTags() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('tags').get();

      return snapshot.docs.map((doc) => Tag.fromFirestore(doc)).toList();

    } catch (e) {
      print('Error fetching events: $e');
      throw e;
    }
  }

  Future<List<Activity>> fetchAllActivities() async {
    
    //await Future.delayed(Duration(seconds: 1));
    List<Activity> activities = [];
    try {
      QuerySnapshot eventSnapshot = await _firestore
          .collection('events')
          .where('status', isEqualTo: 'active')
          .where('hostDate', isGreaterThan: Timestamp.now())
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

  Future<List<Activity>> fetchFilteredActivities(String filter, List<String> tagIDs) async {
    List<Activity> activities = [];
    try {
      if (filter == 'All' || filter == 'Project') {
        Query eventQuery = _firestore.collection('events').where('status', isEqualTo: 'active');
        if (tagIDs.isNotEmpty) {
          eventQuery = eventQuery.where('tags', arrayContainsAny: tagIDs);
        }
        QuerySnapshot eventSnapshot = await eventQuery.where('hostDate', isGreaterThan: Timestamp.now()).get();
        activities.addAll(
            eventSnapshot.docs.map((doc) => Event.fromFirestore(doc)).toList());
      }

      if (filter == 'All' || filter == 'Speech') {
        Query speechQuery = _firestore.collection('speeches').where('status', isEqualTo: 'active');
        if (tagIDs.isNotEmpty) {
          speechQuery = speechQuery.where('tags', arrayContainsAny: tagIDs);
        }
        QuerySnapshot speechSnapshot = await speechQuery.get();
        activities.addAll(
            speechSnapshot.docs.map((doc) => Speech.fromFirestore(doc)).toList());
      }

      return activities;
    } catch (e) {
      print('Error fetching filtered activities: $e');
      throw e;
    }
  }

  Future<Event> getEventById(String eventID) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('events').doc(eventID).get();

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

  Future<List<Speech>> fetchSpeechesByProjectID(String eventID) async {
    List<Speech> speeches = [];
    try {
      QuerySnapshot speechSnapshot = await _firestore
          .collection('speeches')
          .where('eventID', isEqualTo: eventID)
          .get();
      speeches = speechSnapshot.docs.map((doc) => Speech.fromFirestore(doc)).toList();
      return speeches;
    } catch (e) {
      print('Error fetching speeches: $e');
      throw e;
    }
  }

  
}
