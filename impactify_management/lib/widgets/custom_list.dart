import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:impactify_management/models/project.dart';
import 'package:impactify_management/models/speech.dart';
import 'package:impactify_management/models/user.dart';
import 'package:impactify_management/theming/custom_themes.dart';
import 'package:impactify_management/widgets/custom_loading.dart';
import 'package:impactify_management/widgets/custom_text.dart';
import 'package:intl/intl.dart';

class CustomProjectList extends StatelessWidget {
  final String? projectID;
  final Project project;
  final Function(String projectID) deleteFunction;

  const CustomProjectList({
    this.projectID,
    required this.deleteFunction,
    required this.project,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime date = project.hostDate.toDate();
    String formattedDate =
        DateFormat('dd MMMM yyyy, HH:mm').format(date).toUpperCase();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Slidable(
            key: Key(project.title),
            startActionPane: ActionPane(
              extentRatio: 0.3,
              motion: ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) {
                    Navigator.pushNamed(
                      context,
                      '/editProject',
                      arguments: {
                        'projectID': project.eventID,
                        'title': project.title,
                        'location': project.location,
                        'description': project.description,
                        'hostDate': project.hostDate.toDate(),
                        'tags': project.tags,
                        'sdg': project.sdg,
                        'impoints': project.impointsAdd.toString(),
                        'image': project.image,
                      },
                    );
                  },
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
                Navigator.pushNamed(context, '/projectDetail',
                    arguments: projectID);
              },
              child: Stack(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.network(
                        project.image,
                        width: 100,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          } else {
                            return CustomImageLoading(width: 100);
                          }
                        },
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              project.title,
                              style: GoogleFonts.nunitoSans(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            CustomIconText(
                                text: project.location,
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

class CustomSpeechList extends StatelessWidget {
  final String? speechID;
  final bool? hasRecording;
  final Speech speech;
  final Function(String speechID) deleteFunction;

  const CustomSpeechList({
    this.speechID,
    required this.deleteFunction,
    required this.speech,
    this.hasRecording = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime date = speech.hostDate.toDate();
    String formattedDate =
        DateFormat('dd MMMM yyyy, HH:mm').format(date).toUpperCase();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Slidable(
            key: Key(speech.title),
            startActionPane: ActionPane(
              extentRatio: 0.3,
              motion: ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) {
                    Navigator.pushNamed(
                      context,
                      '/editSpeech',
                      arguments: {
                        'speechID': speech.speechID,
                        'title': speech.title,
                        'location': speech.location,
                        'projectID': speech.eventID,
                        'description': speech.description,
                        'hostDate': speech.hostDate.toDate(),
                        'tags': speech.tags,
                        'image': speech.image,
                      },
                    );
                  },
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
                    if (speechID != null) {
                      deleteFunction(speechID!);
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
                Navigator.pushNamed(
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
                        speech.image,
                        width: 100,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          } else {
                            return CustomImageLoading(width: 100);
                          }
                        },
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              speech.title,
                              style: GoogleFonts.nunitoSans(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            CustomIconText(
                                text: speech.location,
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
                      speech.hostDate.compareTo(Timestamp.now()) < 0)
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
  final bool isSelectMode;
  final bool isSelected;
  final ValueChanged<bool?> onSelectChanged;

  const CustomAttendeesList({
    required this.user,
    required this.isSelectMode,
    required this.isSelected,
    required this.onSelectChanged,
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
                  radius: 25,
                  backgroundImage: 
                  NetworkImage(user.profileImage),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.fullName,
                      style: GoogleFonts.nunitoSans(
                        fontSize: 15,
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
              if (isSelectMode)
                Checkbox(
                  value: isSelected,
                  onChanged: onSelectChanged,
                  activeColor: Colors.green,
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
