import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:impactify_app/models/activity.dart';
import 'package:impactify_app/models/event.dart';
import 'package:impactify_app/models/speech.dart';
import 'package:impactify_app/models/tag.dart';
import 'package:impactify_app/repositories/auth_repository.dart';
import 'package:impactify_app/repositories/event_repository.dart';

class EventProvider with ChangeNotifier {
  final EventRepository _eventRepository = EventRepository();
  final AuthRepository _authRepository = AuthRepository();
  
  List<Event> _events = [];
  Event? _event;
  List<Activity>? _activities = [];
  List<Activity>? _allActivities = [];
  List<Tag> _tags = [];
  bool _isLoading = false;
  LatLng? _center;
  Marker? _marker;
  List<Speech> _relatedSpeeches = [];

  

  List<Event> get events => _events;
  List<Tag> get tags => _tags;
  Event? get event => _event;
  List<Activity>? get activities => _activities;
  bool get isLoading => _isLoading;
  LatLng? get center => _center;
  Marker? get marker => _marker;
  List<Speech> get relatedSpeeches => _relatedSpeeches;

  Future<void> fetchAllEvents() async {
    _isLoading = true;
    notifyListeners();

    try {
      _events = await _eventRepository.getAllEvents();
    } catch (e) {
      _events = [];
      print('Error in EventProvider: $e');
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchAllTags() async {
    
    notifyListeners();
    try {
      _tags = await _eventRepository.fetchAllTags();
    } catch (e) {
      _tags = [];
      print('Error in EventProvider: $e');
    }
    notifyListeners();
  }

  Future<void> fetchAllActivities() async {
    _isLoading = true;
    notifyListeners();

    try {
      _allActivities  = await _eventRepository.fetchAllActivities();
      _activities = _allActivities;

    } catch (e) {
      _activities = [];
      print('Error in EventProvider: $e');
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchFilteredActivities(String filter, List<String> tagIDs) async {
    _isLoading = true;
    notifyListeners();

    try {
      _activities = await _eventRepository.fetchFilteredActivities(filter, tagIDs);
    } catch (e) {
      _activities = [];
      print('Error in EventProvider: $e');
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<Event> fetchEventByID(String eventID) async {
    _isLoading = true;
    notifyListeners();

    try {
      _event = await _eventRepository.getEventById(eventID);
      List<Location> locations = await locationFromAddress(_event!.location);
      _center = LatLng(locations.first.latitude, locations.first.longitude);
      _marker = Marker(
        markerId: MarkerId(_event!.location),
        position: _center!,
        infoWindow: InfoWindow(
          title: _event!.location,
        ),
      );
      _isLoading = false;
      notifyListeners();
      return _event!;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      print('Error in EventProvider: $e');
      throw Exception('Error fetching event');
    }
  }

  void searchActivities(String searchText) {
    if (searchText.isEmpty || searchText == "") {
      _activities = _allActivities;
    } else {
      _activities = _allActivities!.where((activity) {
        return activity.title.toLowerCase().contains(searchText.toLowerCase()) ||
               activity.location.toLowerCase().contains(searchText.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }

  Future<void> fetchSpeechesByEventID(String eventID) async {
    _relatedSpeeches = await _eventRepository.fetchSpeechesByProjectID(eventID);
    notifyListeners();
  }

  Future<bool> isActivityJoined(String activityID) async {
    return await _eventRepository.isActivityJoined(
        _authRepository.currentUser!.uid, activityID);
  }

  
}
