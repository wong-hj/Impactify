import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:impactify_management/constants/placeholderURL.dart';
import 'package:impactify_management/theming/custom_themes.dart';
import 'package:impactify_management/widgets/custom_list.dart';

class ManageProject extends StatefulWidget {
  const ManageProject({super.key});

  @override
  State<ManageProject> createState() => _ManageProjectState();
}

class _ManageProjectState extends State<ManageProject> {
  String searchText = '';
  void _searchActivities(String text) {
    setState(() {
      searchText = text;
    });
    //Provider.of<EventProvider>(context, listen: false).searchActivities(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.background,
        body: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, 
                children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Manage\nProjects',
                    style: GoogleFonts.merriweather(
                        fontSize: 24, color: Colors.black),
                  ),
                  SizedBox(width: 7),
                  Expanded(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight:
                            40, // Adjust this value to set the desired height
                      ),
                      child: TextField(
                        onChanged: (text) {
                          _searchActivities(text);
                        },
                        onTapOutside: ((event) {
                          FocusScope.of(context).unfocus();
                        }),
                        decoration: InputDecoration(
                          hintText: 'Search',
                          hintStyle: GoogleFonts.poppins(
                              fontSize: 12), // Smaller font size
                          suffixIcon:
                              Icon(Icons.search, size: 20), // Smaller icon size
                          filled: true,
                          isDense: true,
                          fillColor: Colors.white,
                          focusColor: AppColors.tertiary,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 10.0,
                              vertical: 8.0), // Reduced padding
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.primary),
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                    itemCount: 3,
                    //bookmarkProvider.events.length,
                    itemBuilder: (context, index) {
                      //final bookmark = bookmarkProvider.events[index];
                      // DateTime date = bookmark.hostDate.toDate();
                      // String formattedDate = DateFormat('dd MMMM yyyy, HH:mm')
                      //     .format(date)
                      //     .toUpperCase();
                      return CustomList(
                        eventID: 'bookmark.eventID',
                        title: 'bookmark.title',
                        date: 'formattedDate',
                        image: userPlaceholder,
                        location: 'location',
                        onPressed: (context) async {
                          try {
                            //await bookmarkProvider.removeProjectBookmark(bookmark.eventID);
                          } catch (e) {
                            print('Error removing bookmark: $e');
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Failed to remove bookmark'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                      );
                    }),
              )
            ],),),);
  }
}
