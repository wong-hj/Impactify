import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:impactify_app/models/project.dart';
import 'package:impactify_app/models/speech.dart';
import 'package:impactify_app/repositories/speech_repository.dart';

class SpeechProvider with ChangeNotifier {
  final SpeechRepository _speechRepository = SpeechRepository();
  List<Speech> _speeches = [];
  Speech? _speech;
  bool _isLoading = false;
  LatLng? _center;
  Marker? _marker;

  List<Speech> get speeches => _speeches;
  Speech? get speech => _speech;
  bool get isLoading => _isLoading;
  LatLng? get center => _center;
  Marker? get marker => _marker;

  Future<void> fetchAllSpeeches() async {
    _isLoading = true;
    notifyListeners();

    try {
      _speeches = await _speechRepository.getAllSpeeches();
    } catch (e) {
      _speeches = [];
      print('Error in SpeechProvider: $e');
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<Speech?> getSpeechByID(String speechID) async {
    

    try {
      _speech = await _speechRepository.getSpeechById(speechID);
      List<Location> locations = await locationFromAddress(_speech!.location);
      _center = LatLng(locations.first.latitude, locations.first.longitude);
      _marker = Marker(
        markerId: MarkerId(_speech!.location),
        position: _center!,
        infoWindow: InfoWindow(
          title: _speech!.location,
        ),
      );
      return _speech;

    } catch (e) {

      print('Error in SpeechProvider: $e');
      throw Exception('Error fetching speech');

    }
  }

  Future<Map<String, String>> fetchProjectIDAndName(String projectID) async {
    

    try {
      Event event = await _speechRepository.getProjectById(projectID);
      return {
        'projectID': event.eventID,
        'title': event.title,
      };
    } catch (e) {
      throw Exception('Error fetching project details: $e');
    }
  }
}
