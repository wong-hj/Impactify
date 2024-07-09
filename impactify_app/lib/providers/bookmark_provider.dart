import 'package:flutter/material.dart';
import 'package:impactify_app/models/bookmark.dart';
import 'package:impactify_app/models/event.dart';
import 'package:impactify_app/repositories/auth_repository.dart';
import 'package:impactify_app/repositories/bookmark_repository.dart';

class BookmarkProvider with ChangeNotifier {
  final BookmarkRepository _bookmarkRepository = BookmarkRepository();
  final AuthRepository _authRepository = AuthRepository();

  List<Bookmark> _bookmarks = [];
  List<Event> _events = [];
  bool _isLoading = false;

  List<Bookmark> get bookmarks => _bookmarks;
  List<Event> get events => _events;
  bool get isLoading => _isLoading;

  Future<void> addBookmark(String eventID) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _bookmarkRepository.addBookmark(
          _authRepository.currentUser!.uid, eventID);
      await fetchBookmarksAndEvents(); // Refresh the bookmarks list
      _isLoading = false;
      notifyListeners();
      
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      print('Error in BookmarkProvider: $e');
      throw Exception('Error adding bookmark');
    }
  }

  Future<void> removeBookmark(String eventID) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _bookmarkRepository.removeBookmark( _authRepository.currentUser!.uid, eventID);
      await fetchBookmarksAndEvents();
    } catch (e) {
      print('Error in BookmarkProvider: $e');
    }


    _isLoading = false;
    notifyListeners();
  }

  // Future<void> fetchBookmarksByUserID() async {
  //   _isLoading = true;
  //   notifyListeners();

  //   try {
  //     _bookmarks = await _bookmarkRepository
  //         .fetchBookmarksByUserID(_authRepository.currentUser!.uid);
  //   } catch (e) {
  //     _bookmarks = [];
  //     print('Error in BookmarkProvider: $e');
  //   }

  //   _isLoading = false;
  //   notifyListeners();
  // }

  Future<void> fetchBookmarksAndEvents() async {
    _isLoading = true;
    notifyListeners();

    try {
      List<Bookmark> bookmarks = await _bookmarkRepository.fetchBookmarksByUserID(_authRepository.currentUser!.uid);
      print("ERROR BM" + bookmarks.toList().toString());
      // Fetch events using the eventIDs from the bookmarks
      List<Event> fetchedEvents = [];
      for (var bookmark in bookmarks) {
        Event event = await _bookmarkRepository.getEventById(bookmark.eventID);
        fetchedEvents.add(event);
      }

      _events = fetchedEvents;
    } catch (e) {
      print('Error fetching bookmarks and events: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> isEventBookmarked(String eventID) async {
    return await _bookmarkRepository.isEventBookmarked(_authRepository.currentUser!.uid, eventID);
  }
}
