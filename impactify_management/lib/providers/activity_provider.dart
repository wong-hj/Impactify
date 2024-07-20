import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:impactify_management/models/project.dart';
import 'package:impactify_management/models/speech.dart';
import 'package:impactify_management/models/user.dart';
import 'package:impactify_management/repositories/activity_repository.dart';

class ActivityProvider with ChangeNotifier {
  final ActivityRepository _activityRepository = ActivityRepository();
  final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;

  bool _isLoading = false;
  bool _isUploadLoading = false;
  List<Project> _projects = [];
  List<Project> _allProjects = [];
  List<Speech> _speeches = [];
  List<Speech> _allSpeeches = [];
  List<User> _attendees = [];
  Project? _project;
  Speech? _speech;
  LatLng? _center;
  Marker? _marker;

  bool get isLoading => _isLoading;
  bool get isUploadLoading => _isUploadLoading;
  Project? get project => _project;
  Speech? get speech => _speech;
  List<Project> get projects => _projects;
  List<Project> get allProjects => _allProjects;
  List<Speech> get speeches => _speeches;
  List<Speech> get allSpeeches => _allSpeeches;
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

  Future<void> fetchAllSpeechesByOrganizer() async {
    _isLoading = true;
    notifyListeners();

    _speeches = await _activityRepository
        .fetchAllSpeechesByOrganizer(_firebaseAuth.currentUser!.uid);
    _allSpeeches = _speeches;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> uploadRecording(XFile? video, String speechID) async {
     _isUploadLoading = true;
     notifyListeners();

    await _activityRepository.uploadRecording(video, speechID);
    await fetchSpeechByID(speechID);
    _isUploadLoading = false;
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

  Future<Speech?> fetchSpeechByID(String speechID) async {
    
    try {
      _speech = await _activityRepository.fetchSpeechByID(speechID);
      
      List<Location> locations = await locationFromAddress(_speech!.location);
      _center = LatLng(locations.first.latitude, locations.first.longitude);
      _marker = Marker(
        markerId: MarkerId(_speech!.location),
        position: _center!,
        infoWindow: InfoWindow(
          title: _speech!.location,
        ),
      );

      _attendees = await _activityRepository.fetchAttendeesByProjectID(speechID);


      return _speech;
    
    } catch (e) {
      print('Error in ProjectProvider: $e');
      throw Exception('Error fetching Project');
    }

    
  }

  void searchProjects(String searchText) {
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

  void searchSpeeches(String searchText) {
    if (searchText.isEmpty || searchText == "") {
      _speeches = _allSpeeches;
    } else {
      _speeches = _allSpeeches.where((activity) {
        return activity.title.toLowerCase().contains(searchText.toLowerCase()) ||
               activity.location.toLowerCase().contains(searchText.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }
}
