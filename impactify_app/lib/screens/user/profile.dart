
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:impactify_app/constants/placeholderURL.dart';
import 'package:impactify_app/providers/auth_provider.dart';
import 'package:impactify_app/providers/user_provider.dart';
import 'package:impactify_app/screens/user/editProfile.dart';
import 'package:impactify_app/screens/user/home_screen.dart';
import 'package:impactify_app/theming/custom_themes.dart';
import 'package:impactify_app/widgets/custom_text.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
         await context
              .read<AuthProvider>()
              .signOut();
          if (context.read<AuthProvider>().user == null) {
            Navigator.pushReplacementNamed(context, '/login');
          }
        },
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        elevation: 5,
        shape: CircleBorder(),
        child: Icon(Icons.logout_outlined),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
        child: Container(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'You Yourself,',
                        style: GoogleFonts.nunito(fontSize: 17),
                      ),
                      Row(
                        children: [
                          Text(
                            userProvider.userData?.fullName ?? "",
                            style: GoogleFonts.nunito(
                                fontSize: 25, color: AppColors.primary),
                          ),
                          IconButton(
                            highlightColor: Colors.transparent,
                            onPressed: () {
                              Navigator.pushNamed(context, '/editProfile');
                            },
                            icon: Icon(Icons.mode_edit_outlined),
                            iconSize: 25,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(2.0), // Border width
                    decoration: BoxDecoration(
                      color: AppColors.primary, // Border color
                      shape: BoxShape.circle,
                    ),
                    child: CircleAvatar(
                      radius: 30,
                      backgroundImage:
                          NetworkImage(userProvider.userData?.profileImage ?? userPlaceholder),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Card(
                elevation: 7,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                color: AppColors.tertiary,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.park_outlined,
                            color: AppColors.primary,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'My Proudly Stats',
                            style: GoogleFonts.nunito(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          CustomNumberText(number: '${userProvider.userData?.impoints ?? 0}', text: 'Impoints'),
                          CustomNumberText(number: '10', text: 'Posts'),
                          CustomNumberText(number: '6', text: 'Participations'),
                          CustomNumberText(number: '4', text: 'Locations'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                height: 38.0,
                child: TabBar(
                  splashFactory: NoSplash.splashFactory,
                  dividerColor: Colors.transparent,
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.black,
                  labelStyle: GoogleFonts.poppins(),
                  unselectedLabelStyle: GoogleFonts.poppins(),
                  tabs: [
                    Tab(
                      child: Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: Text('Posts'),
                      ),
                    ),
                    Tab(
                      child: Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: Text('History'),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    PostContent(),
                    HistoryContent(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class PostContent extends StatelessWidget {
  final List<String> imageUrls = [
    'https://tinyurl.com/4ztj48vp',
    'https://tinyurl.com/4ztj48vp',
    'https://tinyurl.com/4ztj48vp',
    'https://tinyurl.com/4ztj48vp',
    'https://tinyurl.com/4ztj48vp',
    'https://tinyurl.com/4ztj48vp',
  ];

  PostContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: GridView.builder(
        padding: EdgeInsets.all(4.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // 3 images per row
          crossAxisSpacing: 7.0, // Horizontal spacing between images
          mainAxisSpacing: 7.0, // Vertical spacing between images
        ),
        itemCount: imageUrls.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              // Handle image tap
            },
            child: Ink.image(
              fit: BoxFit.cover,
              image: NetworkImage(imageUrls[index]),
            ),
          );
        },
      ),
    );
  }
}

class HistoryContent extends StatelessWidget {
  const HistoryContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: 200,
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: 3,
          itemBuilder: (context, index) {
            return Card(
              surfaceTintColor: Colors.white,
              margin: EdgeInsets.only(bottom: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 3,
              child: Container(
                height: 80,
                child: Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.2,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        ),
                        image: DecorationImage(
                          image: NetworkImage('https://tinyurl.com/4ztj48vp'),
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
                              'Trees Planting',
                              style: GoogleFonts.nunito(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            Text(
                              '2024-09-11',
                              style: GoogleFonts.poppins(
                                  fontSize: 10, color: AppColors.placeholder),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0, bottom: 10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Text(
                                '+20',
                                style: GoogleFonts.nunito(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.secondary,
                                ),
                              ),
                              SizedBox(width: 2),
                              Icon(
                                Icons.park_rounded,
                                color: AppColors.secondary,
                                size: 16,
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ));
  }
}
