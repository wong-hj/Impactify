import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:impactify_app/theming/custom_themes.dart';
import 'package:impactify_app/widgets/custom_cards.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body:  Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Container(
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
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
                    child: Positioned.fill(
                      child:  Column(
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
                                            'https://tinyurl.com/4whzdz72'),
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Hello, June!',
                                      style: GoogleFonts.nunito(fontSize: 15),
                                    ),
                                  ],
                                ),
                                IconButton(onPressed: () {
                                  Navigator.pushNamed(context, '/schedule');
                                }, icon: Icon(Icons.calendar_today_rounded), color: AppColors.primary,),
                                
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
                                    child: Text('Upcoming',
                                        style: GoogleFonts.nunito(
                                          fontSize: 14,
                                          color: AppColors.primary,
                                          decoration: TextDecoration.underline,
                                        )),
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
                              height: 260,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: 10,
                                itemBuilder: (context, index) {
                                  return CustomHorizontalCard(imageUrl: 'https://tinyurl.com/4ztj48vp', title: 'Free Education for Youths',
                                  location: 'Taman Bukit Jalil, Putrajaya'
                                  
                                  );
                                  
                                },
                              ),
                            ),
                              
                            SizedBox(height: 10),
                            // My Events Text
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Upcoming Opportunities',
                                  style: GoogleFonts.nunito(fontSize: 20),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                              
                            Column(
                              children: List.generate(5, (index) {
                                return CustomVerticalCard(
                                  imageUrl: 'https://tinyurl.com/4ztj48vp',
                                  title: 'Free Education for Youths',
                                  location: 'Taman Bukit Jalil, Putrajaya',
                                  date: '2023-06-30',
                                  circleImageUrl: 'https://via.placeholder.com/40',
                                );
                              }),
                            ),
                              
                            SizedBox(height: 20)
                          ],
                        ),
                      
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      
    );
  }
}
