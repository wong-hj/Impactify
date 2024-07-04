import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:impactify_app/constants/sdglogo.dart';
import 'package:impactify_app/theming/custom_themes.dart';
import 'package:impactify_app/widgets/custom_buttons.dart';
import 'package:impactify_app/widgets/custom_details.dart';
import 'package:impactify_app/widgets/custom_text.dart';

class EventDetail extends StatefulWidget {
  const EventDetail({super.key});

  @override
  State<EventDetail> createState() => _EventDetailState();
}

class _EventDetailState extends State<EventDetail> {
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: 
      CustomDetailScreen(imageUrl: 'https://tinyurl.com/4ztj48vp', 
      type: 'SPEECH', 
      title: 'Free Education for Youths', 
      hoster: 'Living Plus Initiative', 
      location: 'Taman Bukit Jalil, Putrajaya', 
      date: '2024-08-11', 
      aboutDescription: 
      'Event details in placeholder. Event details in placeholder. Event details in placeholder.', 
      onMapCreated: _onMapCreated, 
      center: _center)
      
    );
  }
}
