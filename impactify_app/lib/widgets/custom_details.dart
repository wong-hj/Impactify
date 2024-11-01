import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:impactify_app/constants/sdglogo.dart';
import 'package:impactify_app/providers/bookmark_provider.dart';
import 'package:impactify_app/theming/custom_themes.dart';
import 'package:impactify_app/widgets/custom_buttons.dart';
import 'package:impactify_app/widgets/custom_text.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CustomDetailScreen extends StatelessWidget {
  final String eventID;
  final String image;
  final String type;
  final String title;
  final String hoster;
  final String location;
  final Timestamp hostDate;
  final String aboutDescription;
  final int impointsAdd;
  final String? sdg;
  final Marker? marker;
  final Function(GoogleMapController) onMapCreated;
  final LatLng? center;
  final bool onSaved;
  final VoidCallback onBookmarkToggle;
  final String? projectID;
  final String? projectTitle;

  const CustomDetailScreen({
    required this.eventID,
    required this.image,
    required this.type,
    required this.title,
    required this.hoster,
    required this.location,
    required this.hostDate,
    required this.aboutDescription,
    required this.impointsAdd,
    required this.onMapCreated,
    this.marker,
    this.center,
    this.sdg,
    required this.onSaved,
    required this.onBookmarkToggle,
    this.projectID,
    this.projectTitle,

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
                  Positioned(
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
                  ),
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
                          type,
                          style: GoogleFonts.nunito(
                              fontSize: 12, color: AppColors.primary),
                        ),
                        Spacer(),
                        IconButton(
                          
                          icon: Icon(onSaved ? Icons.bookmark : Icons.bookmark_border),
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
                    type == "SPEECH" ?
                    Container(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/eventDetail',
                            arguments: projectID ?? "",
                          );
                        },
                        child: Text(
                          projectTitle ?? "",
                          style: GoogleFonts.poppins(
                            fontSize: 12,
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
                      "${aboutDescription}\n\n**Participation adds ${impointsAdd} Impoints!",
                      textAlign: TextAlign.justify,
                      style: GoogleFonts.poppins(
                          fontSize: 12, color: AppColors.placeholder),
                    ),
                    SizedBox(height: 16),
                    if (type != "SPEECH") ...[
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
                    CustomPrimaryButton(onPressed: () {}, text: "I'm In!"),
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
              child: Center(
                child: Text(
                  'The event has over\nthank you for your support!',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
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

