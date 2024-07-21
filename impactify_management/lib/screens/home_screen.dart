import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:impactify_management/constants/placeholderURL.dart';
import 'package:impactify_management/providers/auth_provider.dart';
import 'package:impactify_management/providers/user_provider.dart';
import 'package:impactify_management/screens/dashboard.dart';
import 'package:impactify_management/screens/manage_project.dart';
import 'package:impactify_management/screens/manage_speech.dart';
import 'package:impactify_management/screens/profile.dart';
import 'package:impactify_management/screens/view_post.dart';
import 'package:impactify_management/theming/custom_themes.dart';
import 'package:impactify_management/widgets/custom_loading.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedPageIndex = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Fetch events when the widget is built

    WidgetsBinding.instance.addPostFrameCallback((_) {
      
      Provider.of<UserProvider>(context, listen: false).fetchOrganizer();
    });
  }
  

  void _onDrawerItemTapped(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
    _pageController.jumpToPage(index);
    Navigator.pop(context); // Close the drawer
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Impactify Management Center',
            style: GoogleFonts.merriweather(fontSize: 17)),
        backgroundColor: AppColors.tertiary,
      ),
      drawer: Drawer(
        child: 
        userProvider.isLoading ?
        CustomLoading(text: 'Fetching Data...')
        :
        ListView(
          padding: const EdgeInsets.all(0),
          children: <Widget>[
            DrawerHeader(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                decoration: BoxDecoration(
                  color: AppColors.tertiary,
                ), //BoxDecoration
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(2.0), // Border width
                      decoration: BoxDecoration(
                        color: AppColors.primary, // Border color
                        shape: BoxShape.circle,
                      ),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(userProvider.user?.profileImage ?? userPlaceholder),
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      userProvider.user?.fullName ?? "",
                      style: GoogleFonts.merriweather(fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '${userProvider.user?.organizationName} ${userProvider.user?.ssm ?? ''}',
                      style: GoogleFonts.poppins(fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    Text(
                      userProvider.user?.email ?? "",
                      style: GoogleFonts.poppins(fontSize: 12),
                    ),
                  ],
                )
                //circleAvatar
                ), //UserAccountDrawerHeader

            ListTile(
              leading: Icon(Icons.dashboard_outlined),
              title: Text('Dashboard',
                  style: GoogleFonts.poppins(
                      fontWeight:
                          _selectedPageIndex == 0 ? FontWeight.bold : null)),
              onTap: () => _onDrawerItemTapped(0),
              iconColor:
                  _selectedPageIndex == 0 ? AppColors.primary : Colors.black,
              textColor:
                  _selectedPageIndex == 0 ? AppColors.primary : Colors.black,
            ),
            ListTile(
              leading: Icon(Icons.volunteer_activism_outlined),
              title: Text('Manage Projects',
                  style: GoogleFonts.poppins(
                      fontWeight:
                          _selectedPageIndex == 1 ? FontWeight.bold : null)),
              onTap: () => _onDrawerItemTapped(1),
              iconColor:
                  _selectedPageIndex == 1 ? AppColors.primary : Colors.black,
              textColor:
                  _selectedPageIndex == 1 ? AppColors.primary : Colors.black,
            ),
            ListTile(
              leading: Icon(Icons.campaign_outlined),
              title: Text('Manage Speeches',
                  style: GoogleFonts.poppins(
                      fontWeight:
                          _selectedPageIndex == 2 ? FontWeight.bold : null)),
              onTap: () => _onDrawerItemTapped(2),
              iconColor:
                  _selectedPageIndex == 2 ? AppColors.primary : Colors.black,
              textColor:
                  _selectedPageIndex == 2 ? AppColors.primary : Colors.black,
            ),
            ListTile(
              leading: Icon(Icons.groups_2_outlined),
              title: Text('Community Posts',
                  style: GoogleFonts.poppins(
                      fontWeight:
                          _selectedPageIndex == 3 ? FontWeight.bold : null)),
              onTap: () => _onDrawerItemTapped(3),
              iconColor:
                  _selectedPageIndex == 3 ? AppColors.primary : Colors.black,
              textColor:
                  _selectedPageIndex == 3 ? AppColors.primary : Colors.black,
            ),
            ListTile(
              leading: Icon(Icons.person_outline),
              title: Text('My Profile',
                  style: GoogleFonts.poppins(
                      fontWeight:
                          _selectedPageIndex == 4 ? FontWeight.bold : null)),
              onTap: () => _onDrawerItemTapped(4),
              iconColor:
                  _selectedPageIndex == 4 ? AppColors.primary : Colors.black,
              textColor:
                  _selectedPageIndex == 4 ? AppColors.primary : Colors.black,
            ),
            ListTile(
              leading: Icon(Icons.logout_outlined),
              title: Text('Logout', style: GoogleFonts.poppins()),
              onTap: () async {
                await authProvider.signOut();

                if (authProvider.firebaseUser == null) {
                  Navigator.pushReplacementNamed(context, '/login');
                }
              },
              iconColor: Colors.red,
              textColor: Colors.red,
            ),
          ],
        ),
      ),
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedPageIndex = index;
          });
        },
        children: <Widget>[
          Dashboard(),
          ManageProject(),
          ManageSpeech(),
          ViewPost(),
          Profile(),
        ],
      ),
    );
  }
}
