import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:impactify_app/models/event.dart';
import 'package:impactify_app/models/speech.dart';
import 'package:impactify_app/providers/bookmark_provider.dart';

import 'package:impactify_app/providers/event_provider.dart';
import 'package:impactify_app/providers/speech_provider.dart';

import 'package:impactify_app/widgets/custom_details.dart';
import 'package:impactify_app/widgets/custom_loading.dart';

import 'package:provider/provider.dart';

class SpeechDetail extends StatefulWidget {
  const SpeechDetail({super.key});

  @override
  State<SpeechDetail> createState() => _SpeechDetailState();
}

class _SpeechDetailState extends State<SpeechDetail> {
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
    final bookmarkProvider =
        Provider.of<BookmarkProvider>(context, listen: false);
    final String speechID =
        ModalRoute.of(context)!.settings.arguments as String;

    bool saved = await bookmarkProvider.isSpeechBookmarked(speechID); //

    setState(() {
      isSaved = saved;
    });
  }

  @override
  Widget build(BuildContext context) {
    final String speechID =
        ModalRoute.of(context)!.settings.arguments as String;
    final speechProvider = Provider.of<SpeechProvider>(context, listen: false);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: FutureBuilder<Speech>(
        future: speechProvider.getSpeechByID(speechID),
        builder: (pageContext, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CustomLoading(text: 'Loading details...'));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('Event not found'));
          } else {
            Speech speech = snapshot.data!;
            return FutureBuilder<Map<String, String>>(
                future: speechProvider.fetchProjectIDAndName(speech.eventID),
                builder: (context, projectSnapshot) {
                  if (projectSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return SizedBox.shrink();
                  } else if (projectSnapshot.hasError) {
                    return Center(
                        child: Text('Error: ${projectSnapshot.error}'));
                  } else if (!projectSnapshot.hasData) {
                    return Center(child: Text('Project not found'));
                  } else {
                    Map<String, String> project = projectSnapshot.data!;
                    return CustomDetailScreen(
                      id: speech.speechID,
                      image: speech.image,
                      type: speech.type,
                      title: speech.title,
                      hoster: speech.organizer,
                      location: speech.location,
                      hostDate: speech.hostDate,
                      aboutDescription: speech.description,
                      marker: speechProvider.marker,
                      onMapCreated: _onMapCreated,
                      center: speechProvider.center,
                      onSaved: isSaved,
                      onBookmarkToggle: () => _saveOrDeleteBookmark(speechID),
                      eventID: project['projectID'],
                      eventTitle: project['title'],
                      parentContext: pageContext,
                    );
                  }

                  // } else {
                  // return CustomDetailScreen(
                  //         eventID: event.eventID,
                  //         image: event.image,
                  //         type: event.type.toUpperCase(),
                  //         title: event.title,
                  //         hoster: event.organizer,
                  //         location: event.location,
                  //         hostDate: event.hostDate,
                  //         aboutDescription: event.description,
                  //         impointsAdd: event.impointsAdd,
                  //         marker: eventProvider.marker,
                  //         onMapCreated: _onMapCreated,
                  //         center: eventProvider.center,
                  //         sdg: event.sdg,
                  //         onSaved: isSaved,
                  //         onBookmarkToggle: () => _saveOrDeleteBookmark(eventID),
                  //       );
                  //}
                });
          }
        },
      ),
    );
  }

  Future<void> _saveOrDeleteBookmark(String speechID) async {
    final bookmarkProvider =
        Provider.of<BookmarkProvider>(context, listen: false);

    if (!isSaved) {
      try {
        await bookmarkProvider.addSpeechBookmark(speechID);
        setState(() {
          isSaved = true;
        });
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
        await bookmarkProvider.removeSpeechBookmark(speechID);
        setState(() {
          isSaved = false;
        });
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
