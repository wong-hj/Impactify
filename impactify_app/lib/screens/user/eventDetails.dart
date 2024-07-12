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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkIfBookmarked();
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
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
    final isBookmarked = ref.watch(isEventBookmarkedProvider(eventID));
    print('BookMARK' + isBookmarked.value.toString());
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
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
                marker: ref.read(eventProvider).marker,
                onMapCreated: (controller) {
                  _onMapCreated(controller);
                },
                center: ref.read(eventProvider).center,
                sdg: event.sdg,
                onSaved: saved,
                onBookmarkToggle: () => _saveOrDeleteBookmark(eventID, saved),
              );
            },
            loading: () => Center(child: CustomLoading(text: 'Loading bookmark status...')),
            error: (error, stack) => Center(child: Text('Error: $error')),
          );
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
        await bookmarkNotifier.removeProjectBookmark(eventID);
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


