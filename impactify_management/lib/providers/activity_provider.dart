import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:impactify_management/models/project.dart';
import 'package:impactify_management/models/user.dart';
import 'package:impactify_management/repositories/activity_repository.dart';

class ActivityProvider with ChangeNotifier {
  final ActivityRepository _activityRepository = ActivityRepository();
  final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;

  bool _isLoading = false;
  List<Project> _projects = [];
  List<Project> _allProjects = [];
  List<User> _attendees = [];
  Project? _project;
  LatLng? _center;
  Marker? _marker;

  bool get isLoading => _isLoading;
  Project? get project => _project;
  List<Project> get projects => _projects;
  List<Project> get allProjects => _allProjects;
  List<User> get attendees => _attendees;
  LatLng? get center => _center;
  Marker? get marker => _marker;

  Future<void> fetchAllProjectsByOrganizer() async {
    _isLoading = true;
    notifyListeners();

    _projects = await _activityRepository
        .fetchAllProjectsByOrganizer(_firebaseAuth.currentUser!.uid);
    _allProjects = _projects;
    _isLoading = false;
    notifyListeners();
  }

  Future<Project?> fetchProjectByID(String projectID) async {
    _isLoading = true;
    notifyListeners();
    try {
      _project = await _activityRepository.fetchProjectByID(projectID);
      
      List<Location> locations = await locationFromAddress(_project!.location);
      _center = LatLng(locations.first.latitude, locations.first.longitude);
      _marker = Marker(
        markerId: MarkerId(_project!.location),
        position: _center!,
        infoWindow: InfoWindow(
          title: _project!.location,
        ),
      );

      _attendees = await _activityRepository.fetchAttendeesByProjectID(projectID);

      _isLoading = false;
      notifyListeners();

      return _project;
    
    } catch (e) {
      print('Error in ProjectProvider: $e');
      throw Exception('Error fetching Project');
    }

    
  }

  void searchActivities(String searchText) {
    if (searchText.isEmpty || searchText == "") {
      _projects = _allProjects;
    } else {
      _projects = _allProjects.where((activity) {
        return activity.title.toLowerCase().contains(searchText.toLowerCase()) ||
               activity.location.toLowerCase().contains(searchText.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }
}
