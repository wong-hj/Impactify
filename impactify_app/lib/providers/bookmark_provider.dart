import 'package:flutter/material.dart';
import 'package:impactify_app/models/bookmark.dart';
import 'package:impactify_app/models/project.dart';
import 'package:impactify_app/models/speech.dart';
import 'package:impactify_app/repositories/auth_repository.dart';
import 'package:impactify_app/repositories/bookmark_repository.dart';

class BookmarkProvider with ChangeNotifier {
  final BookmarkRepository _bookmarkRepository = BookmarkRepository();
  final AuthRepository _authRepository = AuthRepository();

  List<Bookmark> _bookmarks = [];
  List<Event> _events = [];
  List<Speech> _speeches = [];
  bool _isLoading = false;
  bool _isRemoveDone = false;

  List<Bookmark> get bookmarks => _bookmarks;
  List<Event> get events => _events;
  List<Speech> get speeches => _speeches;
  bool get isLoading => _isLoading;
  bool get isRemoveDone => _isRemoveDone;

  Future<void> addProjectBookmark(String projectID) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _bookmarkRepository.addBookmark(
          _authRepository.currentUser!.uid, projectID, 'project');
      await fetchBookmarksAndProjects(); // Refresh the bookmarks list
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      print('Error in BookmarkProvider: $e');
      throw Exception('Error adding bookmark');
    }
  }

  Future<void> addSpeechBookmark(String speechID) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _bookmarkRepository.addBookmark(
          _authRepository.currentUser!.uid, speechID, 'speech');
      await fetchBookmarksAndSpeeches(); // Refresh the bookmarks list
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      print('Error in BookmarkProvider: $e');
      throw Exception('Error adding bookmark');
    }
  }

  Future<void> removeProjectBookmark(String projectID) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _bookmarkRepository.removeBookmark(
          _authRepository.currentUser!.uid, projectID, 'project');
      await fetchBookmarksAndProjects();
    } catch (e) {
      print('Error in BookmarkProvider: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> removeSpeechBookmark(String speechID) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _bookmarkRepository.removeBookmark(
          _authRepository.currentUser!.uid, speechID, 'speech');
      await fetchBookmarksAndSpeeches();
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

  Future<void> fetchBookmarksAndProjects() async {
    _isLoading = true;
    notifyListeners();

    try {
      List<Bookmark> bookmarks = await _bookmarkRepository
          .fetchBookmarksByUserID(_authRepository.currentUser!.uid);

      // Fetch events using the eventIDs from the bookmarks
      List<Event> fetchedEvents = [];
      for (var bookmark in bookmarks) {
        if (bookmark.eventID != "") {
          
          Event event = await _bookmarkRepository.getEventById(bookmark.eventID!);

          fetchedEvents.add(event);
        }
      }

      _events = fetchedEvents;
    } catch (e) {
      print('Error fetching bookmarks and events1: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchBookmarksAndSpeeches() async {
    _isLoading = true;
    notifyListeners();

    try {
      List<Bookmark> bookmarks = await _bookmarkRepository
          .fetchBookmarksByUserID(_authRepository.currentUser!.uid);

      // Fetch events using the eventIDs from the bookmarks
      List<Speech> fetchedSpeeches = [];

      for (var bookmark in bookmarks) {
        if (bookmark.speechID != "") {
          Speech speech =
              await _bookmarkRepository.getSpeechById(bookmark.speechID!);
          fetchedSpeeches.add(speech);
        }
      }

      _speeches = fetchedSpeeches;
    } catch (e) {
      print('Error fetching bookmarks and events2: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> isProjectBookmarked(String projectID) async {
    return await _bookmarkRepository.isActivityBookmarked(
        _authRepository.currentUser!.uid, projectID, 'project');
  }

  Future<bool> isSpeechBookmarked(String speechID) async {
    return await _bookmarkRepository.isActivityBookmarked(
        _authRepository.currentUser!.uid, speechID, 'speech');
  }
}
