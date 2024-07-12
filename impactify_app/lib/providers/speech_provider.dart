// import 'dart:io';

<<<<<<< HEAD
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:impactify_app/models/event.dart';
import 'package:impactify_app/models/speech.dart';
import 'package:impactify_app/providers/bookmark_provider.dart';
import 'package:impactify_app/repositories/speech_repository.dart';

final speechProvider = StateNotifierProvider<SpeechNotifier, SpeechState>((ref) {
  return SpeechNotifier();
});

final speechDetailProvider = FutureProvider.family<Speech, String>((ref, speechID) async {
  final speechNotifier = ref.read(speechProvider.notifier);
  
  return await speechNotifier.fetchSpeechByID(speechID);
});

final isSpeechBookmarkedProvider = FutureProvider.family<bool, String>((ref, speechID) async {
  print("SPEECH ID HERE IS:" + speechID);
  final bookmarkNotifier = ref.read(bookmarkProvider.notifier);
  bool result = await bookmarkNotifier.isSpeechBookmarked(speechID);
  print("isSpeechBookmarkedProvider result: $result for speechID: $speechID");
  return result;
  //return await bookmarkNotifier.isSpeechBookmarked(speechID);
});

final projectDetailProvider = FutureProvider.family<Map<String, String>, String>((ref, projectID) async {
  final speechNotifier = ref.read(speechProvider.notifier);
  return await speechNotifier.fetchProjectIDAndName(projectID);
});

class SpeechState {
  final List<Speech> speeches;
  final Speech? speech;
  final bool isLoading;
  final LatLng? center;
  final Marker? marker;

  SpeechState({
    required this.speeches,
    required this.speech,
    required this.isLoading,
    required this.center,
    required this.marker,
  });

  SpeechState copyWith({
    List<Speech>? speeches,
    Speech? speech,
    bool? isLoading,
    LatLng? center,
    Marker? marker,
  }) {
    return SpeechState(
      speeches: speeches ?? this.speeches,
      speech: speech ?? this.speech,
      isLoading: isLoading ?? this.isLoading,
      center: center ?? this.center,
      marker: marker ?? this.marker,
    );
  }
  }

class SpeechNotifier extends StateNotifier<SpeechState> {
  final SpeechRepository _speechRepository = SpeechRepository();

  SpeechNotifier()
      : super(SpeechState(
          speeches: [],
          speech: null,
          isLoading: false,
          center: null,
          marker: null,
        ));

  Future<void> fetchAllSpeeches() async {
    state = state.copyWith(isLoading: true);

    try {
      List<Speech> speeches = await _speechRepository.getAllSpeeches();
      state = state.copyWith(speeches: speeches, isLoading: false);
    } catch (e) {
      state = state.copyWith(speeches: [], isLoading: false);
      print('Error in SpeechProvider: $e');
    }
  }

  Future<Speech> getSpeechByID(String speechID) async {
    state = state.copyWith(isLoading: true);

    try {
      Speech speech = await _speechRepository.getSpeechById(speechID);
      List<Location> locations = await locationFromAddress(speech.location);
      LatLng center = LatLng(locations.first.latitude, locations.first.longitude);
      Marker marker = Marker(
        markerId: MarkerId(speech.location),
        position: center,
        infoWindow: InfoWindow(
          title: speech.location,
        ),
      );
      state = state.copyWith(speech: speech, center: center, marker: marker, isLoading: false);
      return speech;
    } catch (e) {
      state = state.copyWith(isLoading: false);
      print('Error in SpeechProvider: $e');
      throw Exception('Error fetching speech');
    }
  }

  Future<Speech> fetchSpeechByID(String speechID) async {
    try {
      final speech = await _speechRepository.getSpeechById(speechID);
      return speech;
    } catch (e) {
      print('Error in EventProvider: $e');
      throw Exception('Error fetching event');
    }
  }

  Future<void> setSpeechDetails(Speech speech) async {
    await Future.delayed(Duration(seconds:1));
    try {
      final locations = await locationFromAddress(speech.location);
      final center = LatLng(locations.first.latitude, locations.first.longitude);
      final marker = Marker(
        markerId: MarkerId(speech.location),
        position: center,
        infoWindow: InfoWindow(
          title: speech.location,
        ),
      );
      state = state.copyWith(
        speech: speech,
        center: center,
        marker: marker,
        isLoading: false,
      );
    } catch (e) {
      print('Error setting event details: $e');
      throw Exception('Error setting event details');
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
=======
// import 'package:flutter/material.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:impactify_app/models/event.dart';
// import 'package:impactify_app/models/speech.dart';
// import 'package:impactify_app/repositories/speech_repository.dart';

// class SpeechProvider with ChangeNotifier {
//   final SpeechRepository _speechRepository = SpeechRepository();
//   List<Speech> _speeches = [];
//   Speech? _speech;
//   bool _isLoading = false;
//   LatLng? _center;
//   Marker? _marker;

//   List<Speech> get speeches => _speeches;
//   Speech? get speech => _speech;
//   bool get isLoading => _isLoading;
//   LatLng? get center => _center;
//   Marker? get marker => _marker;

//   Future<void> fetchAllSpeeches() async {
//     _isLoading = true;
//     notifyListeners();

//     try {
//       _speeches = await _speechRepository.getAllSpeeches();
//     } catch (e) {
//       _speeches = [];
//       print('Error in EventProvider: $e');
//     }
//     _isLoading = false;
//     notifyListeners();
//   }

//   Future<Speech> getSpeechByID(String speechID) async {
//     _isLoading = true;
//     notifyListeners();

//     try {
//       _speech = await _speechRepository.getSpeechById(speechID);
//       List<Location> locations = await locationFromAddress(_speech!.location);
//       _center = LatLng(locations.first.latitude, locations.first.longitude);
//       _marker = Marker(
//         markerId: MarkerId(_speech!.location),
//         position: _center!,
//         infoWindow: InfoWindow(
//           title: _speech!.location,
//         ),
//       );
//       _isLoading = false;
//       notifyListeners();
//       return _speech!;
//     } catch (e) {
//       _isLoading = false;
//       notifyListeners();
//       print('Error in SpeechProvider: $e');
//       throw Exception('Error fetching speech');
//     }
//   }
// }
>>>>>>> parent of 9f4a7c3 (splitted out speech and event for better filtering)
