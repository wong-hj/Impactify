import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:impactify_app/theming/custom_themes.dart';
import 'package:impactify_app/widgets/custom_text.dart';
import 'package:intl/intl.dart';

class CustomVerticalCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String location;
  final String date;
  final String circleImageUrl;

  const CustomVerticalCard({
    required this.imageUrl,
    required this.title,
    required this.location,
    required this.date,
    required this.circleImageUrl,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      surfaceTintColor: Colors.white,
      margin: EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 3,
      child: Container(
        height: 100,
        child: Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.nunito(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    CustomIconText(
                        text: location, icon: Icons.location_on, size: 12),
                    CustomIconText(
                        text: date, icon: Icons.calendar_month, size: 12),
                    Spacer(),
                    CircleAvatar(
                      radius: 11,
                      backgroundImage: NetworkImage(circleImageUrl),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomHorizontalCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String location;
  
  const CustomHorizontalCard({
    required this.imageUrl,
    required this.title,
    required this.location,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      child: Card(
        semanticContainer: true,
        surfaceTintColor: Colors.white,
        margin: EdgeInsets.only(bottom: 10, right: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 130, 
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    image: DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.secondary,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      'SEPT\n11',
                      style: GoogleFonts.nunito(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.nunito(
                        fontSize: 14, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis, // Ensure text wraps
                  ),
                  Text(
                    location,
                    style: GoogleFonts.poppins(
                        fontSize: 10, color: AppColors.placeholder),
                    overflow: TextOverflow.ellipsis, // Ensure text wraps
                  ),
                  SizedBox(height: 17),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        radius: 15,
                        backgroundImage:
                            NetworkImage('https://via.placeholder.com/40'),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        child: Text(
                          'Enroll !',
                          style: GoogleFonts.poppins(fontSize: 12),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.tertiary,
                          foregroundColor: Colors.black, // Button color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          minimumSize: Size(100,
                              30), // Ensure the button fits tightly to its child
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomEventCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String location;
  final Timestamp hostDate;
  final String eventID;
  final String type;


  const CustomEventCard({
    required this.imageUrl,
    required this.title,
    required this.location,
    required this.hostDate,
    required this.eventID,
    required this.type,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime date = hostDate.toDate();
    String formattedDate = DateFormat('MMM\nd').format(date).toUpperCase();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(bottom: 10),
      child: Card(
        semanticContainer: true,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Stack(
              children: [
                Container(
                  height: 180, 
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    image: DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.secondary,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      formattedDate,
                      style: GoogleFonts.nunito(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Positioned(
                  left: 15,
                  top: 15,
                  child: 

                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                      decoration: BoxDecoration(
                        color:
                            type == 'project' ? AppColors.tertiary : Colors.orange, 
                        borderRadius: BorderRadius.circular(5),
                        
                      ),
                      child: Text(
                        type.toUpperCase(),
                        style: GoogleFonts.nunito(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: type == 'project' ? AppColors.primary : Colors.yellow, // Text color
                        ),
                      ),
                    ),
                  
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    
                    style: GoogleFonts.nunito(
                        fontSize: 16, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2, // Ensure text wraps
                  ),
                  Text(
                    location,
                    style: GoogleFonts.poppins(
                        fontSize: 12, color: AppColors.placeholder),
                    overflow: TextOverflow.ellipsis, 
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        radius: 15,
                        backgroundImage:
                            NetworkImage('https://via.placeholder.com/40'),
                      ),
                      ElevatedButton(
                        onPressed: () {
<<<<<<< HEAD
                          type == "project" ? 
=======
>>>>>>> parent of 9f4a7c3 (splitted out speech and event for better filtering)
                          Navigator.pushNamed(
                            context,
                            '/eventDetail',
                            arguments: eventID,
<<<<<<< HEAD
                          ) 
                        
                          : Navigator.pushNamed(
                            context,
                            '/speechDetail',
                            arguments: eventID,
                          )
                          ;
=======
                          );
>>>>>>> parent of 9f4a7c3 (splitted out speech and event for better filtering)
                        },
                        child: Text(
                          'View More',
                          style: GoogleFonts.poppins(fontSize: 12),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.tertiary,
                          foregroundColor: Colors.black, // Button color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          minimumSize: Size(100,
                              30), // Ensure the button fits tightly to its child
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}