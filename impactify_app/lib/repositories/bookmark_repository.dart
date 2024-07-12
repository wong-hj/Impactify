import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:impactify_app/models/bookmark.dart';
import 'package:impactify_app/models/event.dart';
import 'package:impactify_app/models/speech.dart';

class BookmarkRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addBookmark(String userID, String id, String type) async {
    DocumentReference docRef;
    try {
      if (type == 'project') {
        // Create a new document in the bookmarks collection
        docRef = await _firestore.collection('bookmarks').add(
          {
            'userID': userID,
            'eventID': id,
            'speechID': "",
          },
        );
      } else {
        docRef = await _firestore.collection('bookmarks').add(
          {
            'userID': userID,
            'eventID': "",
            'speechID': id,
          },
        );
      }

      // Update the document with the document ID as the bookmarkID
      await docRef.update({
        'bookmarkID': docRef.id,
      });
    } catch (e) {
      throw Exception('Error adding bookmark: $e');
    }
  }

  Future<void> removeBookmark(String userID, String id, String type) async {
    QuerySnapshot snapshot;
    try {
      if (type == 'project') {
        snapshot = await _firestore
            .collection('bookmarks')
            .where('userID', isEqualTo: userID)
            .where('eventID', isEqualTo: id)
            .get();
      } else {
        snapshot = await _firestore
            .collection('bookmarks')
            .where('userID', isEqualTo: userID)
            .where('speechID', isEqualTo: id)
            .get();
      }

      if (snapshot.docs.isNotEmpty) {
        for (var doc in snapshot.docs) {
          await _firestore.collection('bookmarks').doc(doc.id).delete();
        }
      } else {
        throw Exception(
            'No bookmark found for userID: $userID and eventID: $id');
      }
    } catch (e) {
      throw Exception('Error deleting bookmark: $e');
    }
  }

  Future<List<Bookmark>> fetchBookmarksByUserID(String userID) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('bookmarks')
          .where('userID', isEqualTo: userID)
          .get();
      print("TEST:" + snapshot.size.toString());
      return snapshot.docs.map((doc) => Bookmark.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Error fetching bookmarks: $e');
    }
  }

  // Future<Event> getEventById(String eventID) async {
  //   try {
  //     DocumentSnapshot doc = await _firestore.collection('events').doc(eventID).get();
  //     if (doc.exists) {
  //       return Event.fromFirestore(doc);
  //     } else {
  //       throw Exception('Event not found');
  //     }
  //   } catch (e) {
  //     throw Exception('Error fetching event: $e');
  //   }
  // }

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

  Future<bool> isActivityBookmarked(
      String userID, String id, String type) async {
   print("Checking if activity is bookmarked for userID: $userID, id: $id, type: $type");
    QuerySnapshot snapshot;
    try {
      if (type == 'project') {
        snapshot = await _firestore
            .collection('bookmarks')
            .where('userID', isEqualTo: userID)
            .where('eventID', isEqualTo: id)
            .get();
      } else {
        snapshot = await _firestore
            .collection('bookmarks')
            .where('userID', isEqualTo: userID)
            .where('speechID', isEqualTo: id)
            .get();
      }
      bool isBookmarked = snapshot.docs.isNotEmpty;
       print("isActivityBookmarked result: $isBookmarked for id: $id");
       return isBookmarked;
      //return snapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking bookmark: $e');
      return false;
    }
  }
}
