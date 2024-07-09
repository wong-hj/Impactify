import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:impactify_app/constants/sdglogo.dart';
import 'package:impactify_app/models/event.dart';
import 'package:impactify_app/providers/bookmark_provider.dart';
import 'package:impactify_app/providers/event_provider.dart';
import 'package:impactify_app/theming/custom_themes.dart';
import 'package:impactify_app/widgets/custom_buttons.dart';
import 'package:impactify_app/widgets/custom_details.dart';
import 'package:impactify_app/widgets/custom_loading.dart';
import 'package:impactify_app/widgets/custom_text.dart';
import 'package:provider/provider.dart';

class EventDetail extends StatefulWidget {
  const EventDetail({super.key});

  @override
  State<EventDetail> createState() => _EventDetailState();
}

class _EventDetailState extends State<EventDetail> {
  late GoogleMapController mapController;
  // LatLng? _center;
  // Marker? _marker;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
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
      body: FutureBuilder<Event>(
        future: eventProvider.getEventByID(eventID),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CustomLoading(text: 'Loading...'));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('Event not found'));
          } else {
            Event event = eventProvider.event!;
          
            return CustomDetailScreen(
              eventID: event.eventID,
              imageUrl: event.eventImage,
              type: 'EVENT',
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
              initialOnSaved: false,
            );
          }
        },
      ),
    );

    
  }
  
}
