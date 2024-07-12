import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:impactify_app/models/bookmark.dart';
import 'package:impactify_app/models/event.dart';
import 'package:impactify_app/models/speech.dart';
import 'package:impactify_app/repositories/auth_repository.dart';
import 'package:impactify_app/repositories/bookmark_repository.dart';

final bookmarkProvider =
    StateNotifierProvider<BookmarkNotifier, BookmarkState>((ref) {
  return BookmarkNotifier();
});

class BookmarkState {
  final List<Bookmark> bookmarks;
  final List<Event> events;
  final List<Speech> speeches;
  final bool isLoading;
  final bool isRemoveDone;

  BookmarkState({
    this.bookmarks = const [],
    this.events = const [],
    this.speeches = const [],
    this.isLoading = false,
    this.isRemoveDone = false,
  });

  BookmarkState copyWith({
    List<Bookmark>? bookmarks,
    List<Event>? events,
    List<Speech>? speeches,
    bool? isLoading,
    bool? isRemoveDone,
  }) {
    return BookmarkState(
      bookmarks: bookmarks ?? this.bookmarks,
      events: events ?? this.events,
      speeches: speeches ?? this.speeches,
      isLoading: isLoading ?? this.isLoading,
      isRemoveDone: isRemoveDone ?? this.isRemoveDone,
    );
  }
}

class BookmarkNotifier extends StateNotifier<BookmarkState> {
  final BookmarkRepository _bookmarkRepository = BookmarkRepository();
  final AuthRepository _authRepository = AuthRepository();

  BookmarkNotifier() : super(BookmarkState());

  Future<void> addProjectBookmark(String projectID) async {
    state = state.copyWith(isLoading: true);

    try {
      await _bookmarkRepository.addBookmark(
          _authRepository.currentUser!.uid, projectID, 'project');
      await fetchBookmarksAndProjects(); // Refresh the bookmarks list
    } catch (e) {
      print('Error in BookmarkProvider: $e');
      throw Exception('Error adding bookmark');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> addSpeechBookmark(String speechID) async {
    state = state.copyWith(isLoading: true);

    try {
      await _bookmarkRepository.addBookmark(
          _authRepository.currentUser!.uid, speechID, 'speech');
      await fetchBookmarksAndSpeeches(); // Refresh the bookmarks list
    } catch (e) {
      print('Error in BookmarkProvider: $e');
      throw Exception('Error adding bookmark');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> removeProjectBookmark(String eventID) async {
    state = state.copyWith(isLoading: true);

    try {
      await _bookmarkRepository.removeBookmark(
          _authRepository.currentUser!.uid, eventID, 'project');
      await fetchBookmarksAndEvents();
    } catch (e) {
      print('Error in BookmarkProvider: $e');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> removeSpeechBookmark(String speechID) async {
    state = state.copyWith(isLoading: true);

    try {
      await _bookmarkRepository.removeBookmark(
          _authRepository.currentUser!.uid, speechID, 'speech');
      await fetchBookmarksAndSpeeches();
    } catch (e) {
      print('Error in BookmarkProvider: $e');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> fetchBookmarksAndProjects() async {
    state = state.copyWith(isLoading: true);

    try {
      List<Bookmark> bookmarks = await _bookmarkRepository
          .fetchBookmarksByUserID(_authRepository.currentUser!.uid);
      print(bookmarks.toList());
      // Fetch events using the eventIDs from the bookmarks
      List<Event> fetchedEvents = [];
      for (var bookmark in bookmarks) {
        if (bookmark.eventID != null) {
          try {
            Event event =
                await _bookmarkRepository.getEventById(bookmark.eventID!);
            fetchedEvents.add(event);
          } catch (e) {
            print('Error fetching event: $e');
          }
        }
      }
      print(fetchedEvents.toList());
      state = state.copyWith(bookmarks: bookmarks, events: fetchedEvents);
      print("test" + state.events.toList().toString());
    } catch (e) {
      print('Error fetching bookmarks and events: $e');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> fetchBookmarksAndSpeeches() async {
    state = state.copyWith(isLoading: true);

    try {
      List<Bookmark> bookmarks = await _bookmarkRepository
          .fetchBookmarksByUserID(_authRepository.currentUser!.uid);

      // Fetch events using the eventIDs from the bookmarks
      List<Speech> fetchedSpeeches = [];
      for (var bookmark in bookmarks) {
        if (bookmark.speechID != null) {
          try {
            Speech speech =
                await _bookmarkRepository.getSpeechById(bookmark.speechID!);
            fetchedSpeeches.add(speech);
          } catch (e) {
            print('Error fetching event: $e');
          }
        }
      }
      print(fetchedSpeeches.toList());
      state = state.copyWith(bookmarks: bookmarks, speeches: fetchedSpeeches);
      print("test" + state.speeches.toList().toString());
    } catch (e) {
      print('Error fetching bookmarks and speeches: $e');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  // Future<void> fetchBookmarksAndEvents() async {
  //   state = state.copyWith(isLoading: true);

  //   try {
  //     List<Bookmark> bookmarks = await _bookmarkRepository.fetchBookmarksByUserID(_authRepository.currentUser!.uid);

  //     // Fetch events using the eventIDs from the bookmarks
  //     List<Event> fetchedEvents = [];
  //     for (var bookmark in bookmarks) {
  //       Event event = await _bookmarkRepository.getEventById(bookmark.speechID);
  //       fetchedEvents.add(event);
  //     }

  //     state = state.copyWith(bookmarks: bookmarks, events: fetchedEvents);
  //   } catch (e) {
  //     print('Error fetching bookmarks and events: $e');
  //   } finally {
  //     state = state.copyWith(isLoading: false);
  //   }
  // }

//   Future<void> fetchBookmarksAndEvents() async {
//   state = state.copyWith(isLoading: true);

//   try {
//     List<Bookmark> bookmarks = await _bookmarkRepository.fetchBookmarksByUserID(_authRepository.currentUser!.uid);
// print("HERE 4");
//     // Fetch events and speeches using the IDs from the bookmarks
//     List<Event> fetchedEvents = [];
//     List<Speech> fetchedSpeeches = [];
//     for (var bookmark in bookmarks) {
//       print("HERE 1");
//       if (bookmark.eventID != null) {
//         print("HERE 2");
//          try {
//           Event event = await _bookmarkRepository.getEventById(bookmark.eventID!);
//           fetchedEvents.add(event);
//         } catch (e) {
//           print('Error fetching event: $e');
//         }
//       } else if (bookmark.speechID != null) {
//         print("HERE 3");
//         try {
//           Speech speech = await _bookmarkRepository.getSpeechById(bookmark.speechID!);
//           fetchedSpeeches.add(speech);
//         } catch (e) {
//           print('Error fetching speech: $e');
//         }
//       }
//     }

//     state = state.copyWith(
//       bookmarks: bookmarks,
//       events: fetchedEvents,
//       speeches: fetchedSpeeches,
//     );
//   } catch (e) {
//     print('Error fetching bookmarks and events: $e');
//   } finally {
//     state = state.copyWith(isLoading: false);
//   }
// }

  Future<void> fetchBookmarksAndEvents() async {
    state = state.copyWith(isLoading: true);

    try {
      List<Bookmark> bookmarks = await _bookmarkRepository
          .fetchBookmarksByUserID(_authRepository.currentUser!.uid);

      List<Event> fetchedEvents = [];
      List<Speech> fetchedSpeeches = [];

      for (var bookmark in bookmarks) {
        if (bookmark.eventID != null) {
          try {
            Event event =
                await _bookmarkRepository.getEventById(bookmark.eventID!);
            fetchedEvents.add(event);
          } catch (e) {
            print('Error fetching event: $e');
          }
        } else if (bookmark.speechID != null) {
          try {
            Speech speech =
                await _bookmarkRepository.getSpeechById(bookmark.speechID!);
            fetchedSpeeches.add(speech);
          } catch (e) {
            print('Error fetching speech: $e');
          }
        }
      }

      state = state.copyWith(
        bookmarks: bookmarks,
        events: fetchedEvents,
        speeches: fetchedSpeeches,
      );
    } catch (e) {
      print('Error fetching bookmarks and events: $e');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<bool> isProjectBookmarked(String eventID) async {
    return await _bookmarkRepository.isActivityBookmarked(
        _authRepository.currentUser!.uid, eventID, 'project');
  }

  Future<bool> isSpeechBookmarked(String speechID) async {
    return await _bookmarkRepository.isActivityBookmarked(
        _authRepository.currentUser!.uid, speechID, 'speech');
  }
}
