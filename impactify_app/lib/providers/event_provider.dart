import 'dart:io';

import 'package:flutter/material.dart';
import 'package:impactify_app/models/event.dart';
import 'package:impactify_app/repositories/event_repository.dart';

class EventProvider with ChangeNotifier {
  final EventRepository _eventRepository = EventRepository();
  List<Event> _events = [];
  Event? _event;
  bool _isLoading = false;

  List<Event> get events => _events;
  Event? get event => _event;
  bool get isLoading => _isLoading;

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
