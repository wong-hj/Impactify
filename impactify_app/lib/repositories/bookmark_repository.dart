import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:impactify_app/models/bookmark.dart';
import 'package:impactify_app/models/event.dart';

class BookmarkRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addBookmark(String userID, String eventID) async {
  try {
    // Create a new document in the bookmarks collection
    DocumentReference docRef = await _firestore.collection('bookmarks').add({
      'userID': userID,
      'eventID': eventID,
    });

    // Update the document with the document ID as the bookmarkID
    await docRef.update({
      'bookmarkID': docRef.id,
    });

  } catch (e) {
    throw Exception('Error adding bookmark: $e');
  }
}

  Future<void> removeBookmark(String userID, String eventID) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('bookmarks')
          .where('userID', isEqualTo: userID)
          .where('eventID', isEqualTo: eventID)
          .get();

      if (snapshot.docs.isNotEmpty) {
        for (var doc in snapshot.docs) {
          await _firestore.collection('bookmarks').doc(doc.id).delete();
        }
      } else {
        throw Exception(
            'No bookmark found for userID: $userID and eventID: $eventID');
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
          
      return snapshot.docs.map((doc) => Bookmark.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Error fetching bookmarks: $e');
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
      throw Exception('Error fetching event: $e');
    }
  }

  Future<bool> isEventBookmarked(String userID, String eventID) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('bookmarks')
          .where('userID', isEqualTo: userID)
          .where('eventID', isEqualTo: eventID)
          .get();
      return snapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking bookmark: $e');
      return false;
    }
  }
}
