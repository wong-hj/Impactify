import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:impactify_app/constants/sdglogo.dart';
import 'package:impactify_app/theming/custom_themes.dart';
import 'package:impactify_app/widgets/custom_buttons.dart';
import 'package:impactify_app/widgets/custom_text.dart';
import 'package:intl/intl.dart';

class CustomDetailScreen extends StatelessWidget {
  final String imageUrl;
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

  const CustomDetailScreen({
    required this.imageUrl,
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
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime date = hostDate.toDate();
    String formattedDate =
        DateFormat('dd MMMM yyyy, HH:mm').format(date).toUpperCase();

    return SingleChildScrollView(
      child: Column(
        children: [
          // Picture
          Stack(
            children: [
              Container(
                height: 300,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
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
                    Icon(Icons.bookmark_border),
                  ],
                ),
                SizedBox(height: 5),
                Text(
                  title,
                  style: GoogleFonts.nunito(
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
                    text: formattedDate, icon: Icons.calendar_month, size: 12),
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
                          zoom: 11.0,
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
    );
  }
}
