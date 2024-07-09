import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:impactify_app/models/event.dart';
import 'package:impactify_app/repositories/event_repository.dart';

class EventProvider with ChangeNotifier {
  final EventRepository _eventRepository = EventRepository();
  List<Event> _events = [];
  Event? _event;
  bool _isLoading = false;
  LatLng? _center;
  Marker? _marker;

  List<Event> get events => _events;
  Event? get event => _event;
  bool get isLoading => _isLoading;
  LatLng? get center => _center;
  Marker? get marker => _marker;

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

  Future<Event> getEventByID(String eventID) async {
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
}
