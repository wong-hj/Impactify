// import 'package:flutter/material.dart';
// import 'package:impactify_app/models/event.dart';
// import 'package:impactify_app/models/speech.dart';
// import 'package:impactify_app/repositories/event_repository.dart';
// import 'package:impactify_app/repositories/speech_repository.dart';

// class CombinedListProvider with ChangeNotifier {
//   final EventRepository _eventRepository = EventRepository();
//   final SpeechRepository _speechRepository = SpeechRepository();

//   List<dynamic> _combinedLists = [];
//   bool _isLoading = false;

//   List<dynamic> get combinedLists => _combinedLists;
//   bool get isLoading => _isLoading;

//   Future<void> fetchAndCombineItem() async {
//     _isLoading = true;
//     notifyListeners();

//     try {
//       List<Event> events = await _eventRepository.getAllEvents();
//       List<Speech> speeches = await _speechRepository.getAllSpeeches();
//       _combinedLists = [...events, ...speeches];
//     } catch (e) {
//       print('Error combining events and speeches: $e');
//       _combinedLists = [];
//     }

//     _isLoading = false;
//     notifyListeners();
//   }
// }
