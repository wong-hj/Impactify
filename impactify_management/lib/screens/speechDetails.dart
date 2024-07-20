
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// import 'package:provider/provider.dart';

// class EventDetail extends StatefulWidget {
//   const EventDetail({super.key});

//   @override
//   State<EventDetail> createState() => _EventDetailState();
// }

// class _EventDetailState extends State<EventDetail> {
//   late GoogleMapController mapController;
//   //String? bookmarkID; // State variable to store bookmarkID
//   bool isSaved = false; // State variable to track if the event is bookmarked
//   bool isJoined = false;

//   void _onMapCreated(GoogleMapController controller) {
//     mapController = controller;
//   }

  
//   @override
//   void initState() {
    
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {

//     });
    
//   }

//   @override
//   Widget build(BuildContext context) {
    
//     final String eventID = ModalRoute.of(context)!.settings.arguments as String;
//     final eventProvider = Provider.of<EventProvider>(context, listen: false);

//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//       ),
//       body: 

//                   CustomDetailScreen(
//                     id: event.eventID,
//                     image: event.image,
//                     type: event.type,
//                     title: event.title,
//                     hoster: event.organizer,
//                     location: event.location,
//                     hostDate: event.hostDate,
//                     aboutDescription: event.description,
//                     impointsAdd: event.impointsAdd,
//                     marker: eventProvider.marker,
//                     onMapCreated: _onMapCreated,
//                     center: eventProvider.center,
//                     sdg: event.sdg,
//                     onSaved: isSaved,
//                     onBookmarkToggle: () => _saveOrDeleteBookmark(eventID),
//                     parentContext: context,
//                     relatedSpeeches: eventProvider.relatedSpeeches,
//                     isJoined: isJoined,
//                     toggleJoinStatus: _toggleJoinStatus,
//                   )
//     );
//   }
                  
              
              
            

  

// }