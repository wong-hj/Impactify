
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:impactify_app/theming/custom_themes.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.background,
        //AppColors.background,
        body: Container(
            child: Stack(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.3,
                      color: Color.fromRGBO(168, 234, 186, 100),
                    ),
                  ],
                ),
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                    radius: 30,
                                    backgroundImage: NetworkImage(
                                        'https://tinyurl.com/4whzdz72'), // Replace with your image
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Hello, June!',
                                  style: GoogleFonts.nunito(fontSize: 15),
                                ),
                              ],
                            ),
                            Icon(Icons.calendar_today_rounded,
                                color: AppColors.primary),
                          ],
                        ),
                        SizedBox(height: 10),
                        // My Events Text
                        Text(
                          'My Events',
                          style: GoogleFonts.nunito(fontSize: 20),
                        ),
                        // Pill with Upcoming and Past options
                        Container(
                          padding: EdgeInsets.only(top: 10),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTap: () {},
                                child: Text('Upcoming', style: GoogleFonts.nunito(fontSize: 14, color: AppColors.primary, decoration: TextDecoration.underline,)),
                              ),
                              SizedBox(width: 16),
                              GestureDetector(
                                onTap: () {},
                                child: Text('Past'),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16),
                        // Horizontally scrollable cards
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 300,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 10, // Replace with your item count
                            itemBuilder: (context, index) {
                              return Card(
                                semanticContainer: true,
                                surfaceTintColor: Colors.white,
                                margin: EdgeInsets.only(bottom: 10, right: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 4,
                                child: Container(
                                  width: 200,
                                  height: 300,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Image
                                      Container(
                                        height: 160,
                                        width: 200,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              topRight: Radius.circular(10)),
                                          image: DecorationImage(
                                            image: NetworkImage(
                                                'https://tinyurl.com/4ztj48vp'),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Free Education for Youths',
                                              style: GoogleFonts.nunito(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                              overflow: TextOverflow
                                                  .ellipsis, // Ensure text wraps
                                            ),
                                            Text(
                                              'Taman Bukit Jalil, Putrajaya',
                                              style: GoogleFonts.poppins(
                                                  fontSize: 10,
                                                  color: AppColors.placeholder),
                                              overflow: TextOverflow
                                                  .ellipsis, // Ensure text wraps
                                            ),
                                            SizedBox(height: 17),
                                            //Spacer(), // Pushes the button row to the bottom
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                CircleAvatar(
                                                  radius: 15,
                                                  backgroundImage: NetworkImage(
                                                      'https://via.placeholder.com/40'), // Replace with your image URL
                                                ),
                                                ElevatedButton(
                                                  onPressed: () {},
                                                  child: Text(
                                                    'Enroll !',
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 12),
                                                  ),
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        AppColors.tertiary,
                                                    foregroundColor: Colors
                                                        .black, // Button color
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(10),
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
                            },
                          ),
                        ),
            
            
                        SizedBox(height: 10),
                        // My Events Text
                        Text(
                          'Upcoming Opportunities',
                          style: GoogleFonts.nunito(fontSize: 20),
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


