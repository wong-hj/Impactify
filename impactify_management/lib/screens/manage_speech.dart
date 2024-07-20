import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:impactify_management/constants/placeholderURL.dart';
import 'package:impactify_management/providers/activity_provider.dart';
import 'package:impactify_management/theming/custom_themes.dart';
import 'package:impactify_management/widgets/custom_list.dart';
import 'package:impactify_management/widgets/custom_loading.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ManageSpeech extends StatefulWidget {
  const ManageSpeech({super.key});

  @override
  State<ManageSpeech> createState() => _ManageSpeechState();
}

class _ManageSpeechState extends State<ManageSpeech> {
  @override
  void initState() {
    super.initState();
    final activityProvider =
        Provider.of<ActivityProvider>(context, listen: false);
    // Fetch posts when the page is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      activityProvider.fetchAllSpeechesByOrganizer();
    });
  }

  String searchText = '';
  
  void _searchActivities(String text) {
    setState(() {
      searchText = text;
    });
    Provider.of<ActivityProvider>(context, listen: false).searchSpeeches(text);
  }

  @override
  Widget build(BuildContext context) {
    final activityProvider = Provider.of<ActivityProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: FloatingActionButton(
        onPressed: () {

        },
        backgroundColor: AppColors.tertiary,
        foregroundColor: Colors.black,
        elevation: 10,
        shape: CircleBorder(),
        child: Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
        child: 
        activityProvider.isLoading ?
        CustomLoading(text: 'Fetching Speeches...')
        :
        Column(crossAxisAlignment: CrossAxisAlignment.start, 
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Manage\nSpeeches',
                style:
                    GoogleFonts.merriweather(fontSize: 24, color: Colors.black),
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
                          horizontal: 10.0, vertical: 8.0), // Reduced padding
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
            child: activityProvider.speeches.isEmpty
                ? Center(
                    child: Text(
                      'No Speeches Found.',
                      style: GoogleFonts.poppins(
                          color: AppColors.primary, fontSize: 18),
                    ),
                  )
                : ListView.builder(
                    itemCount: activityProvider.speeches.length,
                    itemBuilder: (context, index) {
                      final speech = activityProvider.speeches[index];
                      
                      return CustomList(
                        speechID: speech.speechID,
                        title: speech.title,
                        date1: speech.hostDate,
                        image: speech.image,
                        location: speech.location,
                        hasRecording: speech.recording!.isEmpty ? false : true,
                      );
                    }),
          )
        ]),
      ),
    );
  }
}
