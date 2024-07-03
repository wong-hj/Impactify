import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:impactify_app/theming/custom_themes.dart';

class CommunityPost extends StatelessWidget {
  final String profileImage;
  final String type;
  final String name;
  final String bio;
  final String date;
  final String postImage;
  final String postTitle;
  final String postDescription;
  final String event;
  final String points;

  const CommunityPost({
    required this.profileImage,
    required this.type,
    required this.name,
    required this.bio,
    required this.date,
    required this.postImage,
    required this.postTitle,
    required this.postDescription,
    required this.event,
    required this.points,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(2.0), // Border width
              decoration: BoxDecoration(
                color: AppColors.primary, // Border color
                shape: BoxShape.circle,
              ),
              child: CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(profileImage),
              ),
            ),
            SizedBox(width: 5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.nunito(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8), 
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 3),
                      decoration: BoxDecoration(
                        color:
                            AppColors.tertiary, 
                        borderRadius: BorderRadius.circular(8),
                        
                      ),
                      child: Text(
                        type,
                        style: GoogleFonts.nunito(
                          fontSize: 10,
                          color: AppColors.primary, // Text color
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  bio,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppColors.placeholder,
                  ),
                ),
              ],
            )
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Container(
                child: Text(
                  date,
                  style: GoogleFonts.poppins(
                    fontSize: 9,
                    color: AppColors.placeholder,
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: 250,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(postImage),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Text(
          postTitle,
          style: GoogleFonts.nunito(
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        // Post Description
        Text(
          postDescription,
          style: GoogleFonts.poppins(
            fontSize: 11,
            color: AppColors.placeholder,
          ),
        ),
        SizedBox(height: 20),
        // Actions Row
        Row(
          children: [
            Container(
              width: 250,
              child: ElevatedButton(
                onPressed: () {},
                child: Text(
                  event,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: Size(100, 30),
                ),
              ),
            ),
            Spacer(),
            Icon(Icons.park_outlined, color: AppColors.primary),
            SizedBox(width: 3),
            Text(
              points,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
