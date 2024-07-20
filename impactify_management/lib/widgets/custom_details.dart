import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:impactify_management/models/user.dart';
import 'package:impactify_management/theming/custom_themes.dart';
import 'package:impactify_management/widgets/custom_text.dart';
import 'package:intl/intl.dart';

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
  final String? eventID;
  final String? eventTitle;
  final String? recordingUrl;
  final List<User> attendees;

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
    required this.attendees,
    this.marker,
    this.center,
    this.sdg,
    this.eventID,
    this.eventTitle,
    this.recordingUrl,
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
                   
                     
                      Text(
                        type.toUpperCase(),
                        style: GoogleFonts.merriweather(
                            fontSize: 12, color: AppColors.primary),
                      ),
                        
                      
                    
                    Text(
                      title,
                      style: GoogleFonts.merriweather(
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
                            style: GoogleFonts.merriweather(
                                fontSize: 12, color: AppColors.placeholder),
                          ),
                          TextSpan(
                            text: hoster,
                            style: GoogleFonts.merriweather(
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
                    SizedBox(height: 8),
                    
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
                    SizedBox(height: 8),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: CustomLargeIconText(
                          icon: Icons.people, text: 'Attendees (${attendees.length})'),
                        ),
                        TextButton(onPressed: () {
                          Navigator.pushNamed(context, '/attendees', arguments: attendees);
                        }, child: Text('View More', style: GoogleFonts.poppins(color: Colors.blue)))
                    ],)
                  ],
                ),
              ),
            ],
          ),
        ),
        
      ],
    );
  }
}