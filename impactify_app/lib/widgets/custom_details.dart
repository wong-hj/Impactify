import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:impactify_app/constants/sdglogo.dart';
import 'package:impactify_app/models/speech.dart';
import 'package:impactify_app/providers/bookmark_provider.dart';
import 'package:impactify_app/providers/participation_provider.dart';
import 'package:impactify_app/theming/custom_themes.dart';
import 'package:impactify_app/widgets/custom_buttons.dart';
import 'package:impactify_app/widgets/custom_text.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CustomDetailScreen extends StatelessWidget {
  final String id;
  final String image;
  final String type;
  final String title;
  final String hoster;
  final String location;
  final Timestamp hostDate;
  final String aboutDescription;
  final int? impointsAdd;
  final String? sdg;
  final Marker? marker;
  final Function(GoogleMapController) onMapCreated;
  final LatLng? center;
  final bool onSaved;
  final VoidCallback onBookmarkToggle;
  final String? eventID;
  final String? eventTitle;
  final String? recordingUrl;
  final BuildContext parentContext;
  final List<Speech>? relatedSpeeches;
  final bool isJoined;
  final VoidCallback toggleJoinStatus;

  const CustomDetailScreen({
    required this.id,
    required this.image,
    required this.type,
    required this.title,
    required this.hoster,
    required this.location,
    required this.hostDate,
    required this.aboutDescription,
    this.impointsAdd,
    required this.onMapCreated,
    this.marker,
    this.center,
    this.sdg,
    required this.onSaved,
    required this.onBookmarkToggle,
    this.eventID,
    this.eventTitle,
    this.recordingUrl,
    required this.parentContext,
    this.relatedSpeeches = const [],
    required this.isJoined,
    required this.toggleJoinStatus,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime date = hostDate.toDate();
    String formattedDate =
        DateFormat('dd MMMM yyyy, HH:mm').format(date).toUpperCase();
    bool isEventOver = date.isBefore(DateTime.now());
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              // Picture
              Stack(
                children: [
                  Container(
                    height: 300,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(image),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  type == "project"
                      ? Positioned(
                          top: 40,
                          right: 30,
                          child: Material(
                            elevation: 10,
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(
                                      "https://sdgs.un.org/sites/default/files/goals/E_SDG_Icons-${sdg}.jpg"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        )
                      : SizedBox.shrink(),
                ],
              ),
              // Content
              Container(
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                padding: EdgeInsets.all(20),
                transform: Matrix4.translationValues(0.0, -30.0, 0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          type.toUpperCase(),
                          style: GoogleFonts.nunito(
                              fontSize: 12, color: AppColors.primary),
                        ),
                        Spacer(),
                        IconButton(
                          icon: Icon(
                              onSaved ? Icons.bookmark : Icons.bookmark_border),
                          color: onSaved ? AppColors.primary : Colors.black,
                          onPressed: onBookmarkToggle,
                        ),
                      ],
                    ),
                    Text(
                      title,
                      style: GoogleFonts.nunito(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    type == "speech"
                        ? Container(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  '/eventDetail',
                                  arguments: eventID ?? "",
                                );
                              },
                              child: Text(
                                eventTitle ?? "",
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.tertiary,
                                foregroundColor: AppColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                minimumSize: Size(100, 30),
                              ),
                            ),
                          )
                        : SizedBox(height: 10),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Hosted by ',
                            style: GoogleFonts.nunito(
                                fontSize: 12, color: AppColors.placeholder),
                          ),
                          TextSpan(
                            text: hoster,
                            style: GoogleFonts.nunito(
                                fontSize: 12,
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                    CustomIconText(
                        text: location, icon: Icons.location_on, size: 12),
                    SizedBox(height: 8),
                    CustomIconText(
                        text: formattedDate,
                        icon: Icons.calendar_month,
                        size: 12),
                    SizedBox(height: 8),
                    CircleAvatar(
                      radius: 15,
                      backgroundImage:
                          NetworkImage('https://via.placeholder.com/40'),
                    ),
                    SizedBox(height: 16),
                    CustomLargeIconText(
                        icon: Icons.info_outlined, text: 'About this Event'),
                    SizedBox(height: 8),
                    Text(
                      "${aboutDescription} ${type == "project" ? "\n\n**Participation adds ${impointsAdd ?? 0} Impoints!" : ""}",
                      textAlign: TextAlign.justify,
                      style: GoogleFonts.poppins(
                          fontSize: 12, color: AppColors.placeholder),
                    ),
                    if (relatedSpeeches!.isNotEmpty) ...[
                      SizedBox(height: 16),
                      CustomLargeIconText(
                          icon: Icons.record_voice_over_outlined,
                          text: 'Upcoming Related Speech / Pitch'),
                      SizedBox(height: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: relatedSpeeches!.map((speech) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  '/speechDetail',
                                  arguments: speech.speechID,
                                );
                              },
                              child: Text(
                                "• ${speech.title}   ${DateFormat('dd MMMM, HH:mm').format(speech.hostDate.toDate())}",
                                textAlign: TextAlign.start,
                                style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: AppColors.placeholder,
                                    decoration: TextDecoration.underline),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                    SizedBox(height: 16),
                    if (type != "speech") ...[
                      CustomLargeIconText(
                          icon: Icons.flag_outlined,
                          text: 'Sustainable Development Goals'),
                      SizedBox(height: 8),
                      Text(
                        'This event tackles SDG ${sdg}',
                        textAlign: TextAlign.justify,
                        style: GoogleFonts.poppins(
                            fontSize: 12, color: AppColors.placeholder),
                      ),
                      SizedBox(height: 16),
                    ],
                    CustomLargeIconText(
                        icon: Icons.explore_outlined, text: 'Location'),
                    SizedBox(height: 8),
                    if (center != null && marker != null)
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: GoogleMap(
                            onMapCreated: onMapCreated,
                            initialCameraPosition: CameraPosition(
                              target: center!,
                              zoom: 13.0,
                            ),
                            markers: {marker!},
                          ),
                        ),
                      ),
                    SizedBox(height: 16),
                    if (!isJoined) ...[
                      CustomPrimaryButton(
                          onPressed: () async {
                            final participationProvider =
                                Provider.of<ParticipationProvider>(context,
                                    listen: false);
                            try {
                              await participationProvider.joinActivity(
                                  id, type, impointsAdd ?? 0);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Successfully joined activity!\nMark your calendar on ${formattedDate}!',
                                    style: GoogleFonts.poppins(fontSize: 16),
                                  ),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              toggleJoinStatus();
                            } catch (e) {
                              print('Error joining project: $e');
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Failed to join project'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                          text: "I'm In!"),
                    ] else ...[
                      Text("*You are joining this activity, to opt out:",
                          style: GoogleFonts.nunito(color: AppColors.primary)),
                      SizedBox(height: 2),
                      CustomOptOutButton(
                          onPressed: () async {
                            await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor: AppColors.background,
                                  title: Text('Confirm Opt Out'),
                                  content: Text(
                                      'Are you sure you want to opt out? You will miss out on a lot of great experiences.'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(false);
                                      },
                                      child: Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        final participationProvider =
                                            Provider.of<ParticipationProvider>(
                                                context,
                                                listen: false);

                                        try {
                                          await participationProvider
                                              .leaveActivity(
                                                  id, type, impointsAdd ?? 0);

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Opt out from activity!',
                                                style: GoogleFonts.poppins(
                                                    fontSize: 16),
                                              ),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                          toggleJoinStatus();
                                        } catch (e) {
                                          print('Error opt out project: $e');
                                        }
                                        Navigator.of(context).pop(true);
                                      },
                                      child: Text('Confirm'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          text: "I wish to Opt Out"),
                    ]
                  ],
                ),
              ),
            ],
          ),
        ),
        if (isEventOver)
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.7),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'The event has over\nthank you for your support!',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (type == 'speech' 
                  || recordingUrl != null)...[
                    SizedBox(height: 5),
                    Text(
                      'To view the recording of the session:',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 15),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/recording',
                          arguments: recordingUrl,
                        );
                      },
                      child: Text(
                        'Click Here!',
                        style: GoogleFonts.poppins(
                            fontSize: 17,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ]
                ],
              ),
            ),
          ),
      ],
    );
  }
}

// Future<void> _saveOrDeleleBookmark(bool onSaved, String eventID) async {
//   final bookmarkProvider = Provider.of<BookmarkProvider>(context, listen: false);

//   if (!onSaved) {
//     String bookmarkID = await bookmarkProvider.addBookmark(eventID);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Saved to Bookmark!'),
//           backgroundColor: Colors.green,
//         ),
//       );
//   } else {
//     await bookmarkProvider.removeBookmark(bookmarkID);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Removed Bookmark!'),
//           backgroundColor: Colors.red,
//         ),
//       );
//   }

// }
