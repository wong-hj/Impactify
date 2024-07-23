import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:impactify_app/providers/post_provider.dart';
import 'package:impactify_app/theming/custom_themes.dart';
import 'package:impactify_app/widgets/custom_loading.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CommunityPost extends StatelessWidget {
  final String postID;
  final String profileImage;
  final String type;
  final String name;
  final String bio;
  final Timestamp date;
  final String postImage;
  final String postTitle;
  final String postDescription;
  final String activity;
  final String activityID;
  final List<String> likes;
  final String userID;
  final bool? edit;

  const CommunityPost({
    required this.postID,
    required this.profileImage,
    required this.type,
    required this.name,
    required this.bio,
    required this.date,
    required this.postImage,
    required this.postTitle,
    required this.postDescription,
    required this.activity,
    required this.activityID,
    required this.likes,
    required this.userID,
    this.edit = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = date.toDate();
    String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);

    final postProvider = Provider.of<PostProvider>(context);
    final bool isLiked = likes.contains(userID);

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
                      style: GoogleFonts.merriweather(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 3),
                      decoration: BoxDecoration(
                        color: type == 'project'
                            ? AppColors.tertiary
                            : Colors.orange,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        type.toUpperCase(),
                        style: GoogleFonts.merriweather(
                          fontSize: 8,
                          color: type == 'project'
                              ? AppColors.primary
                              : Colors.yellow, // Text color
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
            ),
            Spacer(),
            edit!
                ? GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/editPost',
                        arguments: {
                          'postID': postID,
                          'currentTitle': postTitle,
                          'currentDescription': postDescription,
                          'activityID': activityID,
                          'postImage': postImage,
                        },
                      );
                    },
                    child: Icon(
                      Icons.edit,
                      color: Colors.blue,
                      size: 20,
                    ))
                : SizedBox.shrink()
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
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Text(
          postTitle,
          style: GoogleFonts.merriweather(
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        // Post Description
        Text(
          postDescription,
          style: GoogleFonts.poppins(
            fontSize: 13,
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
                onPressed: () {
                  Navigator.pushNamed(context,
                      type == 'project' ? '/eventDetail' : '/speechDetail',
                      arguments: activityID);
                },
                child: Text(
                  activity,
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
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('${likes.length}',
                    style: GoogleFonts.poppins(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 15)),
                InkWell(
                  splashColor: Colors.transparent,
                  child: Icon(
                    isLiked ? Icons.park : Icons.park_outlined,
                    color: isLiked ? AppColors.primary : Colors.grey,
                  ),
                  onTap: () {
                    if (isLiked) {
                      postProvider.unlikePost(postID);
                    } else {
                      postProvider.likePost(postID);
                    }
                  },
                ),
              ],
            )
          ],
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
