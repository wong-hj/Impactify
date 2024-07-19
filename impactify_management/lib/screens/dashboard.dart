import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:impactify_management/theming/custom_themes.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'My\nDashboard',
              style:
                  GoogleFonts.merriweather(fontSize: 24, color: Colors.black),
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
                child: 
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Project Organized",
                            style: GoogleFonts.merriweather(fontSize: 23)),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '12 ',
                                style: GoogleFonts.poppins(fontSize: 27),
                              ),
                              TextSpan(
                                text: 'Ongoing',
                                style: GoogleFonts.poppins(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '12 ',
                                style: GoogleFonts.poppins(fontSize: 27),
                              ),
                              TextSpan(
                                text: 'Completed',
                                style: GoogleFonts.poppins(fontSize: 16),
                              ),
                            ],
                          ),
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
                child: 
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset('assets/speech.png',
                        width: 100, fit: BoxFit.cover),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          
                          Text("Speeches Given",
                              style: GoogleFonts.merriweather(fontSize: 22)),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Ongoing ',
                                  style: GoogleFonts.poppins(fontSize: 12),
                                ),
                                TextSpan(
                                  text: '12',
                                  style: GoogleFonts.poppins(fontSize: 27),
                                ),
                                
                              ],
                            ),
                          ),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Completed ',
                                  style: GoogleFonts.poppins(fontSize: 16),
                                ),
                                TextSpan(
                                  text: '12',
                                  style: GoogleFonts.poppins(fontSize: 27),
                                ),
                                
                              ],
                            ),
                          )
                        ],
                      ),
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
                child: 
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Users Engaged",
                            style: GoogleFonts.merriweather(fontSize: 23, color: Colors.white)),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '12 ',
                                style: GoogleFonts.poppins(fontSize: 27, color: Colors.white),
                              ),
                              TextSpan(
                                text: 'Users Reached',
                                style: GoogleFonts.poppins(fontSize: 12, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        
                      ],
                    ),
                    Image.asset('assets/community.png',
                        width: 100, fit: BoxFit.cover)
                  ],
                ),
              ),
            ),
            
            // Text(
            //   'My Ongoing Activities',
            //   style:
            //       GoogleFonts.merriweather(fontSize: 24, color: Colors.black),
            // ),
            // SizedBox(height: 16),
            // ActivityCard(
            //   imageUrl: 'https://via.placeholder.com/150',
            //   title: 'Trees Planting: Healing the Earth',
            //   location: 'Taman Saujana Hijau, Putrajaya',
            //   dateTime: '18 July 2024, 10:30 AM - 16:30 PM',
            //   additionalInfo: 'And 3 More !',
            // ),
          ],
        ),
      ),
    );
  }
}

class ActivityCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String location;
  final String dateTime;
  final String additionalInfo;

  const ActivityCard({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.location,
    required this.dateTime,
    required this.additionalInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6.0,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: Image.network(
              imageUrl,
              height: 80,
              width: 80,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8),
                Text(
                  location,
                  style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
                ),
                SizedBox(height: 4),
                Text(
                  dateTime,
                  style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
                ),
                SizedBox(height: 8),
                Text(
                  additionalInfo,
                  style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
