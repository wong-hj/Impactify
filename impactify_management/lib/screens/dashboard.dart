import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:impactify_management/providers/activity_provider.dart';
import 'package:impactify_management/theming/custom_themes.dart';
import 'package:impactify_management/widgets/custom_loading.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
    super.initState();
    final activityProvider =
        Provider.of<ActivityProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      activityProvider.fetchAllActivitiesStats();
    });
  }

  @override
  Widget build(BuildContext context) {
    final activityProvider = Provider.of<ActivityProvider>(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: activityProvider.isLoading
          ? CustomLoading(text: 'Fetching Project Stats...')
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My\nDashboard',
                      style: GoogleFonts.nunitoSans(
                          fontSize: 24, color: Colors.black),
                    ),
                    SizedBox(height: 8),
                    Card(
                      elevation: 7,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      color: AppColors.secondary,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Projects Organized",
                                    style:
                                        GoogleFonts.nunitoSans(fontSize: 23)),
                                Row(
                                  children: [
                                    Text(
                                        activityProvider.ongoingProjects
                                            .toString(),
                                        style:
                                            GoogleFonts.poppins(fontSize: 27)),
                                    Text(' Ongoing',
                                        style:
                                            GoogleFonts.poppins(fontSize: 14)),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                        activityProvider.completedProject
                                            .toString(),
                                        style:
                                            GoogleFonts.poppins(fontSize: 27)),
                                    Text(' Completed',
                                        style:
                                            GoogleFonts.poppins(fontSize: 14)),
                                  ],
                                )
                              ],
                            ),
                            Image.asset('assets/project.png',
                                width: 100, fit: BoxFit.cover)
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Card(
                      elevation: 7,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      color: AppColors.tertiary,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset('assets/speech.png',
                                width: 100, fit: BoxFit.cover),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Speeches Given",
                                    style:
                                        GoogleFonts.nunitoSans(fontSize: 22)),
                                Row(
                                  children: [
                                    Text(
                                        activityProvider.ongoingSpeeches
                                            .toString(),
                                        style:
                                            GoogleFonts.poppins(fontSize: 27)),
                                    Text(' Ongoing',
                                        style:
                                            GoogleFonts.poppins(fontSize: 14)),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                        activityProvider.completedSpeeches
                                            .toString(),
                                        style:
                                            GoogleFonts.poppins(fontSize: 27)),
                                    Text(' Completed',
                                        style:
                                            GoogleFonts.poppins(fontSize: 14)),
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Card(
                      elevation: 7,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      color: AppColors.primary,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Users Engaged",
                                    style: GoogleFonts.nunitoSans(
                                        fontSize: 23, color: Colors.white)),
                                Row(
                                  children: [
                                    Text(
                                        activityProvider.usersEngaged
                                            .toString(),
                                        style: GoogleFonts.poppins(
                                            fontSize: 27, color: Colors.white)),
                                    Text(' Users Reached',
                                        style: GoogleFonts.poppins(
                                            fontSize: 14, color: Colors.white)),
                                  ],
                                ),
                              ],
                            ),
                            Image.asset('assets/community.png',
                                width: 100, fit: BoxFit.cover)
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ),
    );
  }
}
