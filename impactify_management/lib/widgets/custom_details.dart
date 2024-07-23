import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:impactify_management/models/user.dart';
import 'package:impactify_management/theming/custom_themes.dart';
import 'package:impactify_management/widgets/custom_loading.dart';
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
  final String? videoName;
  final List<User> attendees;
  final Function? onPickVideo;
  final Function? onUploadVideo;
  final String? errorLocation;

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
    this.videoName,
    this.onPickVideo,
    this.onUploadVideo,
    this.errorLocation,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime date = hostDate.toDate();
    String formattedDate =
        DateFormat('dd MMMM yyyy, HH:mm').format(date).toUpperCase();

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
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    child: Image.network(
                      image,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        } else {
                          return CustomImageLoading(width: 250);
                        }
                      },
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
                              child: Image.network(
                                "https://sdgs.un.org/sites/default/files/goals/E_SDG_Icons-${sdg}.jpg",
                                fit: BoxFit.cover,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  } else {
                                    return CustomImageLoading(width: 30);
                                  }
                                },
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
                          fontSize: 14, color: AppColors.primary),
                    ),
                    SizedBox(height: 10),
                    Text(
                      title,
                      style: GoogleFonts.merriweather(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Hosted by ',
                            style: GoogleFonts.merriweather(
                                fontSize: 14, color: AppColors.placeholder),
                          ),
                          TextSpan(
                            text: hoster,
                            style: GoogleFonts.merriweather(
                                fontSize: 14,
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    CustomIconText(
                        text: location, icon: Icons.location_on, size: 14),
                    SizedBox(height: 8),
                    CustomIconText(
                        text: formattedDate,
                        icon: Icons.calendar_month,
                        size: 14),
                    SizedBox(height: 20),
                    CustomLargeIconText(
                        icon: Icons.info_outlined, text: 'About this Event'),
                    SizedBox(height: 8),
                    Text(
                      "${aboutDescription} ${type == "project" ? "\n\n**Participation adds ${impointsAdd ?? 0} Impoints!" : ""}",
                      textAlign: TextAlign.justify,
                      style: GoogleFonts.poppins(
                          fontSize: 14, color: AppColors.placeholder),
                    ),
                    SizedBox(height: 20),
                    if (type != "speech") ...[
                      CustomLargeIconText(
                          icon: Icons.flag_outlined,
                          text: 'Sustainable Development Goals'),
                      SizedBox(height: 8),
                      Text(
                        'This event tackles SDG ${sdg}',
                        textAlign: TextAlign.justify,
                        style: GoogleFonts.poppins(
                            fontSize: 14, color: AppColors.placeholder),
                      ),
                      SizedBox(height: 20),
                    ] else ...[
                      CustomLargeIconText(
                          icon: Icons.videocam_outlined,
                          text: 'Recording',
                          color: recordingUrl!.isEmpty
                              ? Colors.red
                              : Colors.black),
                      SizedBox(height: 8),
                      if (recordingUrl!.isEmpty &&
                          hostDate.compareTo(Timestamp.now()) < 0) ...[
                        Text(
                          "Add recording of the speech for users' reference!",
                          style: GoogleFonts.poppins(
                              fontSize: 14, color: AppColors.placeholder),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () => onPickVideo!(),
                                  child: Text(
                                    videoName == ''
                                        ? 'Upload Recording'
                                        : 'Recording - ${videoName}',
                                    style: GoogleFonts.poppins(
                                        fontSize: 14, color: AppColors.primary),
                                    overflow: TextOverflow
                                        .ellipsis, // Add ellipsis to handle overflow
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () => onUploadVideo!(),
                              icon: Icon(
                                Icons.upload,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        )
                      ] else if (recordingUrl!.isNotEmpty) ...[
                        TextButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                '/recording',
                                arguments: recordingUrl,
                              );
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              'View Recording >',
                              style: GoogleFonts.poppins(
                                  fontSize: 14, color: AppColors.primary),
                            )),
                      ] else ...[
                        Text(
                          "Remember to add recording when the speech ends for user references!",
                          style: GoogleFonts.poppins(
                              fontSize: 14, color: AppColors.placeholder),
                        ),
                      ]
                    ],
                    SizedBox(height: 20),
                    CustomLargeIconText(
                        icon: Icons.explore_outlined, text: 'Location'),
                    if (errorLocation == null) ...[
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
                    ] else ...[
                      Text(
                        errorLocation!,
                        style: GoogleFonts.poppins(
                            fontSize: 14, color: AppColors.placeholder),
                      )
                    ],
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: CustomLargeIconText(
                              icon: Icons.people,
                              text: 'Attendees (${attendees.length})'),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/attendees',
                                  arguments: {
                                    'attendees': attendees,
                                    'title': title,
                                    'organizer': hoster,
                                    'location': location,
                                    'hostDate': hostDate
                                  });
                            },
                            child: Text('View More',
                                style: GoogleFonts.poppins(color: Colors.blue)))
                      ],
                    )
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
