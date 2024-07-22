import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:impactify_management/models/activity.dart';
import 'package:impactify_management/models/project.dart';
import 'package:impactify_management/models/speech.dart';
import 'package:impactify_management/models/tag.dart';
import 'package:impactify_management/models/user.dart';
import 'package:impactify_management/providers/user_provider.dart';
import 'package:impactify_management/repositories/activity_repository.dart';

class ActivityProvider with ChangeNotifier {
  final ActivityRepository _activityRepository = ActivityRepository();
  final UserProvider _userProvider = UserProvider();
  final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;

  bool _isLoading = false;
  bool _isUploadLoading = false;
  List<Project> _projects = [];
  List<Project> _allProjects = [];
  List<Speech> _speeches = [];
  List<Speech> _allSpeeches = [];
  List<User> _attendees = [];
  List<Activity> _activities = [];
  List<Tag> _tags = [];
  Project? _project;
  Speech? _speech;
  LatLng? _center;
  Marker? _marker;
  String? _errorLocation;

  bool get isLoading => _isLoading;
  bool get isUploadLoading => _isUploadLoading;
  Project? get project => _project;
  Speech? get speech => _speech;
  List<Project> get projects => _projects;
  List<Project> get allProjects => _allProjects;
  List<Speech> get speeches => _speeches;
  List<Speech> get allSpeeches => _allSpeeches;
  List<User> get attendees => _attendees;
  List<Activity> get activities => _activities;
  List<Tag> get tags => _tags;
  LatLng? get center => _center;
  Marker? get marker => _marker;
  String? get errorLocation => _errorLocation;

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
    _errorLocation = null;
    _project = null; // Reset project details
    _center = null; // Reset center
    _marker = null; // Reset marker
    _attendees = []; // Reset attendees list
    

    try {
      _project = await _activityRepository.fetchProjectByID(projectID);

      try {
        List<Location> locations =
            await locationFromAddress(_project!.location);
        _center = LatLng(locations.first.latitude, locations.first.longitude);
        _marker = Marker(
          markerId: MarkerId(_project!.location),
          position: _center!,
          infoWindow: InfoWindow(
            title: _project!.location,
          ),
        );
      } catch (e) {
        // Handle address lookup failure
        _errorLocation = 'Could not find any result for the given address.';
      }

      _attendees =
          await _activityRepository.fetchAttendeesByProjectID(projectID);


      return _project;
    } catch (e) {
      // _isLoading = false;
      // _errorLocation = 'Error fetching Project';
      // notifyListeners();
      print('Error in ProjectProvider: $e');
      throw Exception('Error fetching Project');
    }
  }

  Future<Speech?> fetchSpeechByID(String speechID) async {
    _isLoading = true;
    _errorLocation = null;
    _project = null; // Reset project details
    _center = null; // Reset center
    _marker = null; // Reset marker
    _attendees = []; // Reset attendees list
    try {
      _speech = await _activityRepository.fetchSpeechByID(speechID);
      try {
        List<Location> locations = await locationFromAddress(_speech!.location);
        _center = LatLng(locations.first.latitude, locations.first.longitude);
        _marker = Marker(
          markerId: MarkerId(_speech!.location),
          position: _center!,
          infoWindow: InfoWindow(
            title: _speech!.location,
          ),
        );
      } catch (e) {
        // Handle address lookup failure
        _errorLocation = 'Could not find any result for the given address.';
      }

      _attendees =
          await _activityRepository.fetchAttendeesByProjectID(speechID);

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
        return activity.title
                .toLowerCase()
                .contains(searchText.toLowerCase()) ||
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
        return activity.title
                .toLowerCase()
                .contains(searchText.toLowerCase()) ||
            activity.location.toLowerCase().contains(searchText.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }

  Future<void> fetchAllActivities() async {
    _isLoading = true;
    notifyListeners();

    try {
      _activities = await _activityRepository
          .fetchAllActivities(_firebaseAuth.currentUser!.uid);
    } catch (e) {
      _activities = [];
      print('Error in ActivityProvider: $e');
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchAllTags() async {
    notifyListeners();
    try {
      _tags = await _activityRepository.fetchAllTags();
    } catch (e) {
      _tags = [];
      print('Error in ActivityProvider: $e');
    }
    notifyListeners();
  }

  

  Future<void> addTag(String tagName) async {
    notifyListeners();
    try {
      await _activityRepository.addTag(tagName);
      await fetchAllTags();
    } catch (e) {
      print('Error in ActivityProvider: $e');
    }
    notifyListeners();
  }

  Future<void> addProject(XFile? imageFile, Map<String, dynamic> data) async {
    await _userProvider.fetchOrganizer();
    final organizer = _userProvider.user!;

    try {
      await _activityRepository.addProject(
          organizer.organizerID, organizer.organizationName, data, imageFile);
      await fetchAllProjectsByOrganizer();
    } catch (e) {
      print('Error in ActivityProvider: $e');
    }

    notifyListeners();
  }

  Future<void> addSpeech(XFile? imageFile, Map<String, dynamic> data) async {
    await _userProvider.fetchOrganizer();
    final organizer = _userProvider.user!;

    try {
      await _activityRepository.addSpeech(
          organizer.organizerID, organizer.organizationName, data, imageFile);
      await fetchAllSpeechesByOrganizer();
    } catch (e) {
      print('Error in ActivityProvider: $e');
    }

    notifyListeners();
  }

  Future<void> updateProject(XFile? imageFile, Map<String, dynamic> data) async {
    

    try {
      await _activityRepository.updateProject(data, imageFile);
      //await fetchAllProjectsByOrganizer();
    } catch (e) {
      print('Error in ActivityProvider: $e');
    }

    notifyListeners();
  }

  Future<void> updateSpeech(XFile? imageFile, Map<String, dynamic> data) async {
    

    try {
      await _activityRepository.updateSpeech(data, imageFile);
      //await fetchAllProjectsByOrganizer();
    } catch (e) {
      print('Error in ActivityProvider: $e');
    }

    notifyListeners();
  }

  Future<void> deleteProject(String projectID) async {

    try {
      await _activityRepository.deleteProject(projectID);
    } catch (e) {
      print('Error in ActivityProvider: $e');
    }
    notifyListeners();
  }

  Future<void> deleteSpeech(String speechID) async {

    try {
      await _activityRepository.deleteSpeech(speechID);
    } catch (e) {
      print('Error in ActivityProvider: $e');
    }
    notifyListeners();
  }
}
