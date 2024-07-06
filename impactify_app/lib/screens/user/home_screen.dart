import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:impactify_app/screens/user/bookmark.dart';
import 'package:impactify_app/screens/user/community.dart';
import 'package:impactify_app/screens/user/home.dart';
import 'package:impactify_app/screens/user/profile.dart';
import 'package:impactify_app/theming/custom_themes.dart';
import 'events.dart'; 

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _page = 0;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  PageController _pageController = PageController();

  final List<Widget> _pages = [
    //Home(onMoreClicked: () => _onMoreClicked()),
    Home(),
    Events(),
    Bookmark(),
    Community(),
    Profile(),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: _pages,
        onPageChanged: (index) {
          setState(() {
            _page = index;
          });
        },
      ),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: _page,
        height: 60.0,
        items: <Widget>[
          Icon(Icons.home, size: 30, color: AppColors.primary),
          Icon(Icons.grid_view, size: 30, color: AppColors.primary),
          Icon(Icons.bookmark_outline, size: 30, color: AppColors.primary),
          Icon(Icons.groups, size: 30, color: AppColors.primary),
          Icon(Icons.person, size: 30, color: AppColors.primary),
        ],
        color: Color.fromARGB(150, 152, 251, 152),
        //AppColors.tertiary,
        backgroundColor: AppColors.background,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 600),
        onTap: (index) {
          _pageController.jumpToPage(index);
        },
      ),
    );
  }
}
