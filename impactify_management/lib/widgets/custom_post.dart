import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:impactify_management/theming/custom_themes.dart';
import 'package:impactify_management/widgets/custom_loading.dart';
import 'package:intl/intl.dart';

class CommunityPost extends StatelessWidget {
  final String postID;
  final String profileImage;
  final String name;
  final String bio;
  final Timestamp date;
  final String postImage;
  final String postTitle;
  final String postDescription;
  final List<String> likes;

  const CommunityPost({
    required this.postID,
    required this.profileImage,
    required this.name,
    required this.bio,
    required this.date,
    required this.postImage,
    required this.postTitle,
    required this.postDescription,
    required this.likes,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = date.toDate();
    String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);

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
                      style: GoogleFonts.nunitoSans(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8),
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
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Container(
                child: Text(
                  formattedDate,
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
                child: Image.network(
                  postImage,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    } else {
                      return CustomImageLoading(width: 250);
                    }
                  },
                )),
          ],
        ),
        SizedBox(height: 10),
        Text(
          postTitle,
          style: GoogleFonts.nunitoSans(
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Text(
          postDescription,
          style: GoogleFonts.poppins(
            fontSize: 13,
            color: AppColors.placeholder,
          ),
        ),
        Row(
          children: [
            Spacer(),
            Text('${likes.length} Likes',
                style: GoogleFonts.poppins(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 15)),
            Icon(
              Icons.park,
              color: AppColors.primary,
            ),
          ],
        ),
      ],
    );
  }
}
