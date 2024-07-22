import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:impactify_management/models/user.dart';
import 'package:impactify_management/theming/custom_themes.dart';
import 'package:impactify_management/widgets/custom_text.dart';
import 'package:intl/intl.dart';

class CustomList extends StatelessWidget {
  final String? projectID;
  final String? speechID;
  final String title;
  final Timestamp date1;
  final String image;
  final String location;
  final bool? hasRecording;
  final Function(String projectID) deleteFunction;

  const CustomList({
    this.projectID,
    this.speechID,
    required this.title,
    required this.date1,
    required this.image,
    required this.location,
    required this.deleteFunction,
    this.hasRecording = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime date = date1.toDate();
    String formattedDate =
        DateFormat('dd MMMM yyyy, HH:mm').format(date).toUpperCase();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Slidable(
            key: Key(title),
            startActionPane: ActionPane(
              extentRatio: 0.3,
              motion: ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) {},
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  icon: Icons.edit_square,
                  label: 'Edit',
                ),
              ],
            ),
            endActionPane: ActionPane(
              extentRatio: 0.3,
              motion: ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) {
                    if (projectID != null) {
                      deleteFunction(projectID!);
                    }
                  },
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'Delete',
                ),
              ],
            ),
            child: GestureDetector(
              onTap: () {
                projectID != null
                    ? Navigator.pushNamed(
                        context,
                        '/projectDetail',
                        arguments: projectID,
                      )
                    : Navigator.pushNamed(
                        context,
                        '/speechDetail',
                        arguments: speechID,
                      );
              },
              child: Stack(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.network(
                        image,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: GoogleFonts.merriweather(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            CustomIconText(
                                text: location,
                                icon: Icons.pin_drop_outlined,
                                size: 12,
                                color: AppColors.primary),
                            SizedBox(height: 2),
                            CustomIconText(
                                text: formattedDate,
                                icon: Icons.calendar_month,
                                size: 12,
                                color: AppColors.primary),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if ((speechID != null) &&
                      !hasRecording! &&
                      date1.compareTo(Timestamp.now()) < 0)
                    Positioned(
                      bottom: 1,
                      right: 1,
                      child: Tooltip(
                        message: 'Add Recording for this Speech!',
                        child:
                            Icon(Icons.videocam_outlined, color: Colors.blue),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        Divider(
          color: Colors.grey,
          thickness: 1,
        ),
      ],
    );
  }
}

class CustomAttendeesList extends StatelessWidget {
  final User user;

  const CustomAttendeesList({
    required this.user,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(2.0), // Border width
                decoration: BoxDecoration(
                  color: AppColors.primary, // Border color
                  shape: BoxShape.circle,
                ),
                child: CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(user.profileImage),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.fullName,
                      style: GoogleFonts.merriweather(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      user.email,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Divider(
          color: Colors.grey,
          thickness: 1,
        ),
      ],
    );
  }
}
