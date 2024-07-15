
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:impactify_app/models/event.dart';
import 'package:impactify_app/providers/bookmark_provider.dart';

import 'package:impactify_app/providers/event_provider.dart';

import 'package:impactify_app/widgets/custom_details.dart';
import 'package:impactify_app/widgets/custom_loading.dart';
import 'package:permission_handler/permission_handler.dart';

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
  bool isJoined = false;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _toggleJoinStatus() {
    setState(() {
      isJoined = !isJoined;
    });

    print('toggle called' + isJoined.toString());
  }
  

  @override
  void initState() {
    
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
    _checkIfBookmarkedAndJoined();
    });
    
  }

  Future<void> _checkIfBookmarkedAndJoined() async {
    
    final bookmarkProvider =
        Provider.of<BookmarkProvider>(context, listen: false);
    final String eventID = ModalRoute.of(context)!.settings.arguments as String;
   

    bool saved = await bookmarkProvider.isProjectBookmarked(eventID);

    final eventProvider =
        Provider.of<EventProvider>(context, listen: false);
  

    bool joined = await eventProvider.isActivityJoined(eventID);
    
    setState(() {
      isSaved = saved;
      isJoined = joined;
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
        future: eventProvider.fetchEventByID(eventID),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CustomLoading(text: 'Loading details...'));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('Event not found'));
          } else {
            Event event = snapshot.data!;

            return FutureBuilder<void>(
              future: eventProvider.fetchSpeechesByEventID(event.eventID),
              builder: (context, speechSnapshot) {
                if (speechSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CustomLoading(text: 'Loading speeches...'));
                } else if (speechSnapshot.hasError) {
                  return Center(child: Text('Error: ${speechSnapshot.error}'));
                } else {

                  return CustomDetailScreen(
                    id: event.eventID,
                    image: event.image,
                    type: event.type,
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
                    parentContext: context,
                    relatedSpeeches: eventProvider.relatedSpeeches,
                    isJoined: isJoined,
                    toggleJoinStatus: _toggleJoinStatus,
                  );
                  
                }
              },
            );
          }
        }
      ), 
    );
  }

  Future<void> _saveOrDeleteBookmark(String eventID) async {
    final bookmarkProvider =
        Provider.of<BookmarkProvider>(context, listen: false);

    if (!isSaved) {
      try {
        await bookmarkProvider.addProjectBookmark(eventID);
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
        await bookmarkProvider.removeProjectBookmark(eventID);
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
