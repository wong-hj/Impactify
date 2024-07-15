import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:impactify_app/models/bookmark.dart';
import 'package:impactify_app/models/event.dart';
import 'package:impactify_app/models/participation.dart';
import 'package:impactify_app/models/speech.dart';

class ParticipationRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> joinActivity(
      String userID, String id, String type, int impoints) async {
    DocumentReference docRef;
    try {
      // Create a new document in the bookmarks collection
      docRef = await _firestore.collection('participation').add(
        {
          'userID': userID,
          'activityID': id,
          'type': type,
        },
      );

      // Update the document with the document ID as the bookmarkID
      await docRef.update({
        'participationID': docRef.id,
      });

      if (type == 'project') {
        try {
          DocumentReference userDocRef =
              _firestore.collection('users').doc(userID);

          // Fetch the current points
          DocumentSnapshot userDoc = await userDocRef.get();
          if (!userDoc.exists) {
            throw Exception("User not found");
          }

          int currentPoints = userDoc['impoints'] ?? 0;
          int updatedPoints = currentPoints + impoints;

          // Update the points field
          await userDocRef.update({'impoints': updatedPoints});

          print('Points updated successfully');
        } catch (e) {
          print('Error updating points: $e');
          throw e;
        }
      }
    } catch (e) {
      throw Exception('Error adding participation: $e');
    }
  }

  Future<void> leaveActivity(String userID, String id, String type, int impoints) async {
    QuerySnapshot snapshot;
    try {
      snapshot = await _firestore
          .collection('participation')
          .where('userID', isEqualTo: userID)
          .where('activityID', isEqualTo: id)
          .get();

      if (snapshot.docs.isNotEmpty) {
        for (var doc in snapshot.docs) {
          await _firestore.collection('participation').doc(doc.id).delete();
        }
      } else {
        throw Exception(
            'No participation found for userID: $userID and activityID: $id');
      }

      if (type == 'project') {
        try {
          DocumentReference userDocRef =
              _firestore.collection('users').doc(userID);

          // Fetch the current points
          DocumentSnapshot userDoc = await userDocRef.get();
          if (!userDoc.exists) {
            throw Exception("User not found");
          }

          int currentPoints = userDoc['impoints'] ?? 0;
          int updatedPoints = currentPoints - impoints;

          // Update the points field
          await userDocRef.update({'impoints': updatedPoints});

          print('Points updated successfully');
        } catch (e) {
          print('Error updating points: $e');
          throw e;
        }
      }
    } catch (e) {
      throw Exception('Error deleting participation: $e');
    }
  }

  Future<List<Participation>> fetchParticipationByUserID(String userID) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('participation')
          .where('userID', isEqualTo: userID)
          .get();

      return snapshot.docs
          .map((doc) => Participation.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Error fetching participation: $e');
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
      throw Exception('Error fetching event: $e');
    }
  }

  Future<Speech> getSpeechById(String speechID) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('speeches').doc(speechID).get();
      if (doc.exists) {
        return Speech.fromFirestore(doc);
      } else {
        throw Exception('Speech not found');
      }
    } catch (e) {
      throw Exception('Error fetching speech: $e');
    }
  }
}
