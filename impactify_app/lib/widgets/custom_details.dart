import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:impactify_app/constants/sdglogo.dart';
import 'package:impactify_app/theming/custom_themes.dart';
import 'package:impactify_app/widgets/custom_buttons.dart';
import 'package:impactify_app/widgets/custom_text.dart';

class CustomDetailScreen extends StatelessWidget {

  final String imageUrl;
  final String type;
  final String title;
  final String hoster;
  final String location;
  final String date;
  final String aboutDescription;
  final String? sdgDescription;
  final Function(GoogleMapController) onMapCreated;
  final LatLng center;

  const CustomDetailScreen({
    required this.imageUrl,
    required this.type,
    required this.title,
    required this.hoster,
    required this.location,
    required this.date,
    required this.aboutDescription,
    required this.onMapCreated,
    required this.center,
    this.sdgDescription,
    Key? key,
  }) : super(key: key);



  @override
  Widget build(BuildContext context) {
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
                          image: NetworkImage(SDG4),
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
                      text: location,
                      icon: Icons.location_on, 
                      size: 12),
                  SizedBox(height: 8),
                  CustomIconText(
                      text: date, icon: Icons.calendar_month, size: 12),
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
                    aboutDescription,
                    textAlign: TextAlign.justify,
                    style: GoogleFonts.poppins(
                        fontSize: 12, color: AppColors.placeholder),
                  ),
                  SizedBox(height: 16),
                  if(sdgDescription != null && sdgDescription!.isNotEmpty) ...[
                    CustomLargeIconText(
                        icon: Icons.flag_outlined,
                        text: 'Sustainable Development Goals'),
                    SizedBox(height: 8),
                    Text(
                      'This event tackles SDG xxx',
                      textAlign: TextAlign.justify,
                      style: GoogleFonts.poppins(
                          fontSize: 12, color: AppColors.placeholder),
                    ),
                    SizedBox(height: 16),
                  ],
                  
                  CustomLargeIconText(
                      icon: Icons.explore_outlined, text: 'Location'),

                  SizedBox(height: 8),
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
                          target: center,
                          zoom: 11.0,
                        ),
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