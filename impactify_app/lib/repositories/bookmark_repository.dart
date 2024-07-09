import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:impactify_app/models/bookmark.dart';


class BookmarkRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> addBookmark(String userID, String eventID) async {
    try {
      DocumentReference docRef = await _firestore.collection('bookmarks').add({
        'userID': userID,
        'eventID': eventID,
      });
      return docRef.id;
    } catch (e) {
      throw Exception('Error adding bookmark: $e');
    }
  }

  Future<void> removeBookmark(String bookmarkID) async {
    try {
      await _firestore.collection('bookmarks').doc(bookmarkID).delete();
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
}
