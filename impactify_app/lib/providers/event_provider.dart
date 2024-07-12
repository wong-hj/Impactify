import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:impactify_app/models/activity.dart';
import 'package:impactify_app/models/event.dart';
import 'package:impactify_app/providers/bookmark_provider.dart';
import 'package:impactify_app/repositories/event_repository.dart';


final eventProvider = StateNotifierProvider<EventNotifier, EventState>((ref) {
  return EventNotifier();
});

final eventDetailProvider = FutureProvider.family<Event, String>((ref, eventID) async {
  final eventNotifier = ref.read(eventProvider.notifier);
  return await eventNotifier.fetchEventByID(eventID);
});

final isEventBookmarkedProvider = FutureProvider.family<bool, String>((ref, eventID) async {
  
  final bookmarkNotifier = ref.read(bookmarkProvider.notifier);
  print("AWAIT" +  bookmarkNotifier.isProjectBookmarked(eventID).toString());
  return await bookmarkNotifier.isProjectBookmarked(eventID);
});


class EventState {
  final List<Event> events;
  final Event? event;
  final List<Activity> activities;
  final bool isLoading;
  final LatLng? center;
  final Marker? marker;

  EventState({
    this.events = const [],
    this.event,
    this.activities = const [],
    this.isLoading = false,
    this.center,
    this.marker,
  });

  EventState copyWith({
    List<Event>? events,
    Event? event,
    List<Activity>? activities,
    bool? isLoading,
    LatLng? center,
    Marker? marker,
  }) {
    return EventState(
      events: events ?? this.events,
      event: event ?? this.event,
      activities: activities ?? this.activities,
      isLoading: isLoading ?? this.isLoading,
      center: center ?? this.center,
      marker: marker ?? this.marker,
    );
  }
}

class EventNotifier extends StateNotifier<EventState> {
  final EventRepository _eventRepository = EventRepository();

  EventNotifier() : super(EventState());

  Future<void> fetchAllEvents() async {
    state = state.copyWith(isLoading: true);

    try {
      final events = await _eventRepository.getAllEvents();
      state = state.copyWith(events: events, isLoading: false);
    } catch (e) {
      state = state.copyWith(events: [], isLoading: false);
      print('Error in EventProvider: $e');
    }
  }

  Future<void> fetchAllActivities() async {
    state = state.copyWith(isLoading: true);

    try {
      
      final activities = await _eventRepository.fetchAllActivities();
      
      state = state.copyWith(activities: activities, isLoading: false);
    } catch (e) {
      state = state.copyWith(activities: [], isLoading: false);
      print('Error in EventProvider: $e');
    }
  }

  Future<Event> fetchEventByID(String eventID) async {
    try {
      final event = await _eventRepository.getEventById(eventID);
      return event;
    } catch (e) {
      print('Error in EventProvider: $e');
      throw Exception('Error fetching event');
    }
  }

  Future<void> setEventDetails(Event event) async {
    try {
      final locations = await locationFromAddress(event.location);
      final center = LatLng(locations.first.latitude, locations.first.longitude);
      final marker = Marker(
        markerId: MarkerId(event.location),
        position: center,
        infoWindow: InfoWindow(
          title: event.location,
        ),
      );
      state = state.copyWith(
        event: event,
        center: center,
        marker: marker,
        isLoading: false,
      );
    } catch (e) {
      print('Error setting event details: $e');
      throw Exception('Error setting event details');
    }
  }
}
