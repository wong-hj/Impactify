import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:impactify_app/models/event.dart';
import 'package:impactify_app/providers/bookmark_provider.dart';
import 'package:impactify_app/providers/event_provider.dart';
import 'package:impactify_app/widgets/custom_details.dart';
import 'package:impactify_app/widgets/custom_loading.dart';

class EventDetail extends ConsumerStatefulWidget {
  EventDetail({super.key});

  @override
  _EventDetailState createState() => _EventDetailState();
}

class _EventDetailState extends ConsumerState<EventDetail> {
  late GoogleMapController mapController;
  bool isSaved = false;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkIfBookmarked();
      final String eventID = ModalRoute.of(context)!.settings.arguments as String;
      ref.invalidate(eventDetailProvider(eventID));
    });
    
  }

  Future<void> _checkIfBookmarked() async {
    final bookmarkNotifier = ref.read(bookmarkProvider.notifier);
    final String eventID = ModalRoute.of(context)!.settings.arguments as String;
    bool saved = await bookmarkNotifier.isProjectBookmarked(eventID);
    setState(() {
      isSaved = saved;
    });
  }

  @override
  Widget build(BuildContext context) {
    final String eventID = ModalRoute.of(context)!.settings.arguments as String;
    final eventDetail = ref.watch(eventDetailProvider(eventID));
    final eventState = ref.watch(eventProvider);
    final isBookmarked = ref.watch(isEventBookmarkedProvider(eventID));

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
<<<<<<< HEAD
      body: eventDetail.when(
        data: (event) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ref.read(eventProvider.notifier).setEventDetails(event);
          });
          return isBookmarked.when(
            data: (saved) {
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
                marker: eventState.marker,
                onMapCreated: _onMapCreated,
                center: eventState.center,
                sdg: event.sdg,
                onSaved: saved,
                onBookmarkToggle: () => _saveOrDeleteBookmark(eventID, saved),
              );
            },
            loading: () => Center(child: CustomLoading(text: 'Loading bookmark status...')),
            error: (error, stack) => Center(child: Text('Error: $error')),
          );
=======
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
>>>>>>> parent of 9f4a7c3 (splitted out speech and event for better filtering)
        },
        loading: () => Center(child: CustomLoading(text: 'Loading details...')),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Future<void> _saveOrDeleteBookmark(String eventID, bool isSaved) async {
    final bookmarkNotifier = ref.read(bookmarkProvider.notifier);

    if (!isSaved) {
      try {
        await bookmarkNotifier.addProjectBookmark(eventID);
        ref.invalidate(isEventBookmarkedProvider(eventID));
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
        await bookmarkNotifier.removeProjectBookmark(eventID);
        ref.invalidate(isEventBookmarkedProvider(eventID));
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


