import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:impactify_management/models/project.dart';
import 'package:impactify_management/providers/activity_provider.dart';
import 'package:impactify_management/widgets/custom_details.dart';
import 'package:impactify_management/widgets/custom_loading.dart';

import 'package:provider/provider.dart';

class ProjectDetail extends StatefulWidget {
  const ProjectDetail({super.key});

  @override
  State<ProjectDetail> createState() => _ProjectDetailState();
}

class _ProjectDetailState extends State<ProjectDetail> {
  late GoogleMapController mapController;
  //String? bookmarkID; // State variable to store bookmarkID
  bool isSaved = false; // State variable to track if the event is bookmarked
  bool isJoined = false;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    super.initState();
    // final String projectID =
    //     ModalRoute.of(context)!.settings.arguments as String;

    // final activityProvider =
    //     Provider.of<ActivityProvider>(context, listen: false);
    // // Fetch posts when the page is loaded
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   activityProvider.fetchProjectByID(projectID);
    // });
  }

  @override
  Widget build(BuildContext context) {
    final activityProvider = Provider.of<ActivityProvider>(context, listen: false);
    final String projectID =
        ModalRoute.of(context)!.settings.arguments as String;
    

    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: FutureBuilder<Project?>(
            future: activityProvider.fetchProjectByID(projectID),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child: CustomLoading(text: 'Fetching Project Details...'));
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData) {
                return Center(child: Text('Project not found'));
              } else {
                final project = snapshot.data!;
                return CustomDetailScreen(
                  id: project.eventID,
                  image: project.image,
                  type: project.type,
                  title: project.title,
                  hoster: project.organizer,
                  location: project.location,
                  hostDate: project.hostDate,
                  aboutDescription: project.description,
                  impointsAdd: project.impointsAdd,
                  marker: activityProvider.marker,
                  onMapCreated: _onMapCreated,
                  center: activityProvider.center,
                  sdg: project.sdg,
                  attendees: activityProvider.attendees
                );
              }
            }));
  }
}
