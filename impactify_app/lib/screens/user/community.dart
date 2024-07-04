import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:impactify_app/screens/user/addPost.dart';
import 'package:impactify_app/theming/custom_themes.dart';
import 'package:impactify_app/widgets/custom_posts.dart';

class Community extends StatelessWidget {
  const Community({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/addPost');
        },
        backgroundColor: AppColors.tertiary,
        foregroundColor: Colors.black,
        elevation: 10,
        shape: CircleBorder(),
        child: Icon(Icons.add),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Heading
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'The ',
                      style: GoogleFonts.nunito(fontSize: 24),
                    ),
                    TextSpan(
                      text: 'Community',
                      style: GoogleFonts.nunito(
                          fontSize: 24,
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              // Post Content
              Expanded(
                child: ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return CommunityPost(
                      profileImage: 'https://tinyurl.com/4whzdz72',
                      type: 'Speech',
                      name: 'June',
                      bio: 'Loving the Earth!',
                      date: '2024-09-11',
                      postImage: 'https://tinyurl.com/4ztj48vp',
                      postTitle: 'Spent A Great Weekend with the folks!',
                      postDescription:
                          'I met new friends during the event and learnt a lot from them! Wish I could join more of these events! ',
                      event: 'Trees Planting: Healing the Earth',
                      points: '120',
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
