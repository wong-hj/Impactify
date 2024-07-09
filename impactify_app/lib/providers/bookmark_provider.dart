import 'package:flutter/material.dart';
import 'package:impactify_app/models/bookmark.dart';
import 'package:impactify_app/repositories/auth_repository.dart';
import 'package:impactify_app/repositories/bookmark_repository.dart';

class BookmarkProvider with ChangeNotifier {
  final BookmarkRepository _bookmarkRepository = BookmarkRepository();
  final AuthRepository _authRepository = AuthRepository();

  List<Bookmark> _bookmarks = [];
  bool _isLoading = false;

  List<Bookmark> get bookmarks => _bookmarks;
  bool get isLoading => _isLoading;

  Future<void> addBookmark(String eventID) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _bookmarkRepository.addBookmark(_authRepository.currentUser!.uid, eventID);
      await fetchBookmarksByUserID(_authRepository.currentUser!.uid); // Refresh the bookmarks list
    } catch (e) {
      print('Error in BookmarkProvider: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> removeBookmark(String bookmarkID) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _bookmarkRepository.removeBookmark(bookmarkID);
      await fetchBookmarksByUserID(_authRepository.currentUser!.uid); // Refresh the bookmarks list
    } catch (e) {
      print('Error in BookmarkProvider: $e');
    }

    _isLoading = false;
    notifyListeners();
  }


  Future<void> fetchBookmarksByUserID(String userID) async {
    _isLoading = true;
    notifyListeners();

    try {
      _bookmarks = await _bookmarkRepository.fetchBookmarksByUserID(_authRepository.currentUser!.uid);
    } catch (e) {
      _bookmarks = [];
      print('Error in BookmarkProvider: $e');
    }

    _isLoading = false;
    notifyListeners();
  }
}
