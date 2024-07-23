import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:impactify_app/models/activity.dart';
import 'package:impactify_app/models/project.dart';
import 'package:impactify_app/providers/event_provider.dart';
import 'package:impactify_app/screens/user/filterOption.dart';
import 'package:impactify_app/theming/custom_themes.dart';
import 'package:impactify_app/util/filter.dart';
import 'package:impactify_app/widgets/custom_cards.dart';
import 'package:impactify_app/widgets/custom_empty.dart';
import 'package:impactify_app/widgets/custom_loading.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class Events extends StatefulWidget {
  const Events({super.key});

  @override
  State<Events> createState() => _EventsState();
}

class _EventsState extends State<Events> {
  bool nearMe = false;
  //List<bool> _isSelected = [true, false, false];

  void _toggle() {
    setState(() {
      nearMe = !nearMe;
    });
  }

  @override
  void initState() {
    super.initState();
    // Fetch events when the widget is built
    final eventProvider = Provider.of<EventProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _requestLocationPermission();
      eventProvider.fetchAllActivities();
      

    });
  }

  Future<void> _requestLocationPermission() async {
    var status = await Permission.location.status;
    if (status.isDenied || status.isRestricted || status.isPermanentlyDenied) {
      // We didn't ask for permission yet or the permission has been denied before but not permanently.
      status = await Permission.location.request();
    }
    if (status.isGranted) {
      print('Location permission granted');
      // You can fetch the location-based events here if needed
    } else {
      print('Location permission denied');
      // Handle the situation when the user denies the permission
      // Show a dialog or a message to inform the user
    }
  }

  String selectedFilter = 'All';
  List<String> selectedTags = [];
  List<String> selectedTagIDs = [];
  String searchText = '';
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;

  void _searchActivities(String text) {
    setState(() {
      searchText = text;
    });
    Provider.of<EventProvider>(context, listen: false).searchActivities(text);
  }

  @override
  Widget build(BuildContext context) {
    final eventProvider = Provider.of<EventProvider>(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              backgroundColor: AppColors.background,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                background: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Discover',
                          style: GoogleFonts.merriweather(
                              fontSize: 24,
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          onPressed: () {
                            showFilterOptions(
                              context: context,
                              selectedFilter: selectedFilter,
                              selectedTags: selectedTags,
                              selectedTagIDs: selectedTagIDs,
                              selectedStartDate: selectedStartDate,
                              selectedEndDate: selectedEndDate,
                              onApplyFilters: (String filter,
                                  List<String> tags,
                                  List<String> tagIDs,
                                  DateTime? startDate,
                                  DateTime? endDate) {
                                setState(() {
                                  selectedFilter = filter;
                                  selectedTags = tags;
                                  selectedTagIDs = tagIDs;
                                  selectedStartDate = startDate;
                                  selectedEndDate = endDate;
                                });
                                Provider.of<EventProvider>(context,
                                        listen: false)
                                    .fetchFilteredActivities(
                                        filter, tagIDs, startDate, endDate);
                              },
                            );
                          },
                          icon: Icon(Icons.filter_list),
                          color: AppColors.primary,
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    // Search Bar
                    // TextField(
                    //   onChanged: (text) {
                    //     _searchActivities(text);
                    //   },
                    //   onTapOutside: ((event) {
                    //     FocusScope.of(context).unfocus();
                    //   }),
                    //   decoration: InputDecoration(
                    //     hintText: 'Search',
                    //     prefixIcon: Icon(Icons.search),
                    //     filled: true,
                    //     fillColor: Colors.white,
                    //     focusColor: AppColors.tertiary,
                    //     contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                    //     border: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(30),
                    //     ),
                    //     focusedBorder: OutlineInputBorder(
                    //       borderSide: BorderSide(color: AppColors.primary),
                    //       borderRadius: BorderRadius.circular(30),
                    //     ),
                    //   ),
                    // ),
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
                            suffixIcon: Icon(Icons.search,
                                size: 20), // Smaller icon size
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
              ),
              expandedHeight: 80,
            ),
            if (eventProvider.isLoading)
              SliverFillRemaining(
                child: CustomLoading(text: 'Awesome Stuffs Coming In !'),
              )
            else if (eventProvider.activities!.isEmpty)
              SliverFillRemaining(
                  child: Center(
                      child: EmptyWidget(
                          text:
                              "No Activities after Filtered.\nPlease try again.",
                          image: 'assets/projectEmpty.png')))
            else
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    Activity activity = eventProvider.activities![index];
                    return CustomEventCard(
                        imageUrl: activity.image,
                        title: activity.title,
                        location: activity.location,
                        hostDate: activity.hostDate,
                        eventID: activity.id,
                        type: activity.type,
                        );
                  },
                  childCount: eventProvider.activities!.length,
                ),
              ),

              // SliverGrid(
              //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              //     crossAxisCount: 2,
              //     crossAxisSpacing: 10,
              //     mainAxisSpacing: 10,
              //     childAspectRatio: 0.7,
              //   ),
              //   delegate: SliverChildBuilderDelegate(
              //     (context, index) {
              //       Activity activity = eventProvider.activities![index];
              //       return CustomEventCard(
              //           imageUrl: activity.image,
              //           title: activity.title,
              //           location: activity.location,
              //           hostDate: activity.hostDate,
              //           eventID: activity.id,
              //           type: activity.type);
              //     },
              //     childCount: eventProvider.activities!.length,
              //   ),
              // )
          ],
        ),
      ),
    );
  }
}
