import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:impactify_app/models/event.dart';
import 'package:impactify_app/models/speech.dart';
import 'package:impactify_app/providers/bookmark_provider.dart';

import 'package:impactify_app/providers/event_provider.dart';
import 'package:impactify_app/providers/speech_provider.dart';

import 'package:impactify_app/widgets/custom_details.dart';
import 'package:impactify_app/widgets/custom_loading.dart';

import 'package:provider/provider.dart';

class SpeechDetail extends ConsumerStatefulWidget {
  SpeechDetail({super.key});

  @override
  _SpeechDetailState createState() => _SpeechDetailState();
}

class _SpeechDetailState extends ConsumerState<SpeechDetail> {
  late GoogleMapController mapController;
  //String? bookmarkID; // State variable to store bookmarkID
  bool isSaved = false; // State variable to track if the event is bookmarked

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkIfBookmarked();
    });
  }

  Future<void> _checkIfBookmarked() async {
    final bookmarkNotifier = ref.read(bookmarkProvider.notifier);
    final String speechID =
        ModalRoute.of(context)!.settings.arguments as String;

    bool saved = await bookmarkNotifier.isSpeechBookmarked(speechID);
    print("Initial bookmark check, Saved: $saved");
    print("Saved:" + saved.toString());

    if (isSaved != saved) {
      setState(() {
        isSaved = saved;
      });
    } else {
      print("No change in bookmark status.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final String speechID =
        ModalRoute.of(context)!.settings.arguments as String;
    final speechDetail = ref.watch(speechDetailProvider(speechID));
    //final speechNotifier = ref.read(speechProvider.notifier);
    final speechState = ref.watch(speechProvider);
    final isBookmarked = ref.watch(isSpeechBookmarkedProvider(speechID));

    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: speechDetail.when(
          data: (speech) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ref.read(speechProvider.notifier).setSpeechDetails(speech);
            });
            final projectDetail =
                ref.watch(projectDetailProvider(speech.eventID));
            return isBookmarked.when(
              data: (saved) {
                return projectDetail.when(
                  data: (project) {
                    print(
                        'Rendering CustomDetailScreen with saved status: $saved');
                    return CustomDetailScreen(
                      id: speech.speechID,
                      image: speech.image,
                      type: speech.type,
                      title: speech.title,
                      hoster: speech.organizer,
                      location: speech.location,
                      hostDate: speech.hostDate,
                      aboutDescription: speech.description,
                      marker: speechState.marker,
                      onMapCreated: _onMapCreated,
                      center: speechState.center,
                      onSaved: saved,
                      onBookmarkToggle: () =>
                          _saveOrDeleteBookmark(speechID, saved),
                      eventID: project['projectID']!,
                      eventTitle: project['title']!,
                    );
                  },
                  loading: () => Center(
                      child: CustomLoading(text: 'Loading project details...')),
                  error: (error, stack) => Center(child: Text('Error: $error')),
                );
              },
              loading: () => Center(
                  child: CustomLoading(text: 'Loading bookmark status...')),
              error: (error, stack) => Center(child: Text('Error: $error')),
            );
          },
          loading: () =>
              Center(child: CustomLoading(text: 'Loading details...')),
          error: (error, stack) => Center(child: Text('Error: $error')),
        ));
  }

  Future<void> _saveOrDeleteBookmark(String speechID, bool isSaved) async {
    final bookmarkNotifier = ref.read(bookmarkProvider.notifier);

    if (!isSaved) {
      try {
        await bookmarkNotifier.addSpeechBookmark(speechID);
        // No need to use setState here
        ref.invalidate(isSpeechBookmarkedProvider(speechID));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Saved to Bookmark!'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        print('Error adding bookmark: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add bookmark'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      try {
        await bookmarkNotifier.removeSpeechBookmark(speechID);
        // No need to use setState here
        ref.invalidate(isSpeechBookmarkedProvider(speechID));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Removed Bookmark!'),
            backgroundColor: Colors.red,
          ),
        );
      } catch (e) {
        print('Error removing bookmark: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to remove bookmark'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}


//   FutureBuilder<Speech>(
    //     future: speechDetail.getSpeechByID(speechID),
    //     builder: (context, snapshot) {
    //       if (snapshot.connectionState == ConnectionState.waiting) {
    //         return Center(child: CustomLoading(text: 'Loading details...'));
    //       } else if (snapshot.hasError) {
    //         return Center(child: Text('Error: ${snapshot.error}'));
    //       } else if (!snapshot.hasData) {
    //         return Center(child: Text('Event not found'));
    //       } else {
    //         Speech speech = snapshot.data!;
    //         return FutureBuilder<Map<String, String>>(
    //             future: speechNotifier.fetchProjectIDAndName(speech.eventID),
    //             builder: (context, projectSnapshot) {
    //               if (projectSnapshot.connectionState ==
    //                   ConnectionState.waiting) {
    //                 return SizedBox.shrink();
    //               } else if (projectSnapshot.hasError) {
    //                 return Center(
    //                     child: Text('Error: ${projectSnapshot.error}'));
    //               } else if (!projectSnapshot.hasData) {
    //                 return Center(child: Text('Project not found'));
    //               } else {
    //                 Map<String, String> project = projectSnapshot.data!;
    //                 return CustomDetailScreen(
    //                   id: speech.speechID,
    //                   image: speech.image,
    //                   type: speech.type,
    //                   title: speech.title,
    //                   hoster: speech.organizer,
    //                   location: speech.location,
    //                   hostDate: speech.hostDate,
    //                   aboutDescription: speech.description,
    //                   marker: speechState.marker,
    //                   onMapCreated: _onMapCreated,
    //                   center: speechState.center,
    //                   onSaved: isSaved,
    //                   onBookmarkToggle: () => _saveOrDeleteBookmark(speechID),
    //                   eventID: project['projectID'],
    //                   eventTitle: project['title'],
    //                 );
    //               }

    //               // } else {
    //               // return CustomDetailScreen(
    //               //         eventID: event.eventID,
    //               //         image: event.image,
    //               //         type: event.type.toUpperCase(),
    //               //         title: event.title,
    //               //         hoster: event.organizer,
    //               //         location: event.location,
    //               //         hostDate: event.hostDate,
    //               //         aboutDescription: event.description,
    //               //         impointsAdd: event.impointsAdd,
    //               //         marker: eventProvider.marker,
    //               //         onMapCreated: _onMapCreated,
    //               //         center: eventProvider.center,
    //               //         sdg: event.sdg,
    //               //         onSaved: isSaved,
    //               //         onBookmarkToggle: () => _saveOrDeleteBookmark(eventID),
    //               //       );
    //               //}
    //             });
    //       }
    //     },
    //   ),
    // );
