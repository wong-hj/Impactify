import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:impactify_app/theming/custom_themes.dart';
import 'package:impactify_app/widgets/custom_text.dart';

class CustomVerticalCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String location;
  final String date;
  final String circleImageUrl;

  const CustomVerticalCard({
    required this.imageUrl,
    required this.title,
    required this.location,
    required this.date,
    required this.circleImageUrl,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      surfaceTintColor: Colors.white,
      margin: EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 3,
      child: Container(
        height: 100,
        child: Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.nunito(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    CustomIconText(text: location, icon: Icons.location_on),
                    CustomIconText(text: date, icon: Icons.calendar_month),
                    Spacer(),
                    CircleAvatar(
                      radius: 11,
                      backgroundImage: NetworkImage(circleImageUrl),
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

class CustomHorizontalCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String location;
  //final String date;
  //final String circleImageUrl;

  const CustomHorizontalCard({
    required this.imageUrl,
    required this.title,
    required this.location,
    //required this.date,
    //required this.circleImageUrl,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Container(
              height: 130,
              width: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.nunito(
                        fontSize: 14, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis, // Ensure text wraps
                  ),
                  Text(
                    location,
                    style: GoogleFonts.poppins(
                        fontSize: 10, color: AppColors.placeholder),
                    overflow: TextOverflow.ellipsis, // Ensure text wraps
                  ),
                  SizedBox(height: 17),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        radius: 15,
                        backgroundImage: NetworkImage(
                            'https://via.placeholder.com/40'),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        child: Text(
                          'Enroll !',
                          style: GoogleFonts.poppins(fontSize: 12),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.tertiary,
                          foregroundColor: Colors.black, // Button color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
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
  }
}
