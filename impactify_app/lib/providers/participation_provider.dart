import 'package:flutter/material.dart';
import 'package:impactify_app/models/bookmark.dart';
import 'package:impactify_app/models/event.dart';
import 'package:impactify_app/models/participation.dart';
import 'package:impactify_app/models/speech.dart';
import 'package:impactify_app/repositories/auth_repository.dart';
import 'package:impactify_app/repositories/bookmark_repository.dart';
import 'package:impactify_app/repositories/participation_repository.dart';
import 'package:impactify_app/repositories/user_repository.dart';

class ParticipationProvider with ChangeNotifier {
  final ParticipationRepository _participationRepository = ParticipationRepository();
  final AuthRepository _authRepository = AuthRepository();

  List<Participation> _participations = [];
  List<Event> _events = [];
  List<Speech> _speeches = [];
  bool _isLoading = false;

  List<Participation> get participation => _participations;
  List<Event> get events => _events;
  List<Speech> get speeches => _speeches;
  bool get isLoading => _isLoading;

  Future<void> joinActivity(String activityID, String type, int impoints) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _participationRepository.joinActivity(
          _authRepository.currentUser!.uid, activityID, type, impoints);
      //await fetchBookmarksAndProjects(); // Refresh the bookmarks list
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      print('Error in ParticipationProvider: $e');
      throw Exception('Error adding participation');
    }
  }


  Future<void> leaveActivity(String activityID, String type) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _participationRepository.leaveActivity(
          _authRepository.currentUser!.uid, activityID, type);
      //await fetchBookmarksAndProjects();
    } catch (e) {
      print('Error in ParticipationProvider: $e');
      throw Exception('Error removing participation');
    }

    _isLoading = false;
    notifyListeners();
  }

  
  // Future<void> fetchBookmarksAndProjects() async {
  //   _isLoading = true;
  //   notifyListeners();

  //   try {
  //     List<Bookmark> bookmarks = await _bookmarkRepository
  //         .fetchBookmarksByUserID(_authRepository.currentUser!.uid);

  //     // Fetch events using the eventIDs from the bookmarks
  //     List<Event> fetchedEvents = [];
  //     for (var bookmark in bookmarks) {
  //       if (bookmark.eventID != "") {
          
  //         Event event = await _bookmarkRepository.getEventById(bookmark.eventID!);

  //         fetchedEvents.add(event);
  //       }
  //     }

  //     _events = fetchedEvents;
  //   } catch (e) {
  //     print('Error fetching bookmarks and events1: $e');
  //   }

  //   _isLoading = false;
  //   notifyListeners();
  // }

  // Future<bool> isProjectBookmarked(String projectID) async {
  //   return await _bookmarkRepository.isActivityBookmarked(
  //       _authRepository.currentUser!.uid, projectID, 'project');
  // }

  // Future<bool> isSpeechBookmarked(String speechID) async {
  //   return await _bookmarkRepository.isActivityBookmarked(
  //       _authRepository.currentUser!.uid, speechID, 'speech');
  // }
}
