import 'package:flutter/material.dart';
import 'package:impactify_app/models/project.dart';
import 'package:impactify_app/models/participation.dart';
import 'package:impactify_app/models/speech.dart';
import 'package:impactify_app/repositories/auth_repository.dart';
import 'package:impactify_app/repositories/participation_repository.dart';

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


  Future<void> leaveActivity(String activityID, String type, int impoints) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _participationRepository.leaveActivity(
          _authRepository.currentUser!.uid, activityID, type, impoints);
      //await fetchBookmarksAndProjects();
    } catch (e) {
      print('Error in ParticipationProvider: $e');
      throw Exception('Error removing participation');
    }

    _isLoading = false;
    notifyListeners();
  }

}
