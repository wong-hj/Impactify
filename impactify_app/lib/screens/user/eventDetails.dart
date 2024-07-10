import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:impactify_app/models/event.dart';
import 'package:impactify_app/providers/bookmark_provider.dart';

import 'package:impactify_app/providers/event_provider.dart';

import 'package:impactify_app/widgets/custom_details.dart';
import 'package:impactify_app/widgets/custom_loading.dart';

import 'package:provider/provider.dart';

class EventDetail extends StatefulWidget {
  const EventDetail({super.key});

  @override
  State<EventDetail> createState() => _EventDetailState();
}

class _EventDetailState extends State<EventDetail> {
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
    final String eventID = ModalRoute.of(context)!.settings.arguments as String;
   

    bool saved = await bookmarkProvider.isEventBookmarked(eventID);
    
    setState(() {
      isSaved = saved;
    });
  }
  

  @override
  Widget build(BuildContext context) {
    
    final String eventID = ModalRoute.of(context)!.settings.arguments as String;
    final eventProvider = Provider.of<EventProvider>(context, listen: false);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: 

      FutureBuilder<Event>(
        future: eventProvider.getEventByID(eventID),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CustomLoading(text: 'Loading details...'));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('Event not found'));
          } else {
            Event event = snapshot.data!;

            if (event.type == 'speech') {
              return FutureBuilder<Map<String, String>>(
                future: eventProvider.fetchProjectIDAndName(event.projectID),
                builder: (context, projectSnapshot) {
                  if (projectSnapshot.connectionState == ConnectionState.waiting) {
                    return SizedBox.shrink();
                  } else if (projectSnapshot.hasError) {
                    return Center(child: Text('Error: ${projectSnapshot.error}'));
                  } else if (!projectSnapshot.hasData) {
                    return Center(child: Text('Project not found'));
                  } else {
                    Map<String, String> project = projectSnapshot.data!;
                    return CustomDetailScreen(
                      eventID: event.eventID,
                      image: event.image,
                      type: event.type.toUpperCase(),
                      title: event.title,
                      hoster: event.organizer,
                      location: event.location,
                      hostDate: event.hostDate,
                      aboutDescription: event.description,
                      impointsAdd: event.impointsAdd,
                      marker: eventProvider.marker,
                      onMapCreated: _onMapCreated,
                      center: eventProvider.center,
                      sdg: event.sdg,
                      onSaved: isSaved,
                      onBookmarkToggle: () => _saveOrDeleteBookmark(eventID),
                      projectID: project['projectID'],
                      projectTitle: project['title'],
                    );
                  }
                },
            
            );
            } else {
              return CustomDetailScreen(
                      eventID: event.eventID,
                      image: event.image,
                      type: event.type.toUpperCase(),
                      title: event.title,
                      hoster: event.organizer,
                      location: event.location,
                      hostDate: event.hostDate,
                      aboutDescription: event.description,
                      impointsAdd: event.impointsAdd,
                      marker: eventProvider.marker,
                      onMapCreated: _onMapCreated,
                      center: eventProvider.center,
                      sdg: event.sdg,
                      onSaved: isSaved,
                      onBookmarkToggle: () => _saveOrDeleteBookmark(eventID),
                    );
            }
            
          }
        },
      ),
    );
  }

  Future<void> _saveOrDeleteBookmark(String eventID) async {
    final bookmarkProvider =
        Provider.of<BookmarkProvider>(context, listen: false);

    if (!isSaved) {
      try {
        await bookmarkProvider.addBookmark(eventID);
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
        await bookmarkProvider.removeBookmark(eventID);
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
