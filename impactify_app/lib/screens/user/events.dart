import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:impactify_app/models/activity.dart';
import 'package:impactify_app/models/event.dart';
import 'package:impactify_app/providers/event_provider.dart';
import 'package:impactify_app/screens/user/filterOption.dart';
import 'package:impactify_app/theming/custom_themes.dart';
import 'package:impactify_app/widgets/custom_cards.dart';
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _requestLocationPermission();
      Provider.of<EventProvider>(context, listen: false).fetchAllActivities();
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

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return FilterOptions(
          onApplyFilters:
              (String filter, List<String> tags, List<String> tagIDs) {
            setState(() {
              selectedFilter = filter;
              selectedTags = tags;
              selectedTagIDs = tagIDs;
            });
            Provider.of<EventProvider>(context, listen: false)
                .fetchFilteredActivities(filter, tagIDs);
          },
          selectedFilter: selectedFilter,
          selectedTags: selectedTags,
          selectedTagIDs: selectedTagIDs,
        );
      },
    );
  }

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
                          style: GoogleFonts.nunito(
                              fontSize: 24,
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold),
                        ),
                        //Spacer(),
                        IconButton(
                          onPressed: _showFilterOptions,
                          icon: Icon(Icons.filter_list),
                          color: AppColors.primary,
                        ),
                        // GestureDetector(
                        //   onTap: _toggle,
                        //   child: Container(
                        //     padding: EdgeInsets.symmetric(
                        //         vertical: 8.0, horizontal: 5.0),
                        //     decoration: BoxDecoration(
                        //       color:
                        //           nearMe ? AppColors.tertiary : Colors.white,
                        //       border: Border.all(
                        //           color: nearMe
                        //               ? AppColors.tertiary
                        //               : Colors.black),
                        //       borderRadius: BorderRadius.circular(30),
                        //     ),
                        //     child: Row(
                        //       mainAxisSize: MainAxisSize.min,
                        //       children: [
                        //         Icon(
                        //           nearMe
                        //               ? Icons.location_on_outlined
                        //               : Icons.location_off_outlined,
                        //           size: 18,
                        //           color: nearMe
                        //               ? Colors.black
                        //               : AppColors.primary,
                        //         ),
                        //         SizedBox(width: 3),
                        //         Text(
                        //           'Near Me',
                        //           style: TextStyle(
                        //             fontSize: 14,
                        //             color: nearMe
                        //                 ? Colors.black
                        //                 : AppColors.primary,
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // )
                      ],
                    ),
                    SizedBox(height: 10),
                    // Search Bar
                    TextField(
                      onChanged: (text) {
                        _searchActivities(text);
                      },
                      onTapOutside: ((event) {
                        FocusScope.of(context).unfocus();
                      }),
                      decoration: InputDecoration(
                        hintText: 'Search',
                        prefixIcon: Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.white,
                        focusColor: AppColors.tertiary,
                        contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.primary),
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              expandedHeight: 70,
            ),
            if (eventProvider.isLoading)
              SliverFillRemaining(
                child: CustomLoading(text: 'Awesome Stuffs Coming In !'),
              )
            else if (eventProvider.activities!.isEmpty)
              SliverFillRemaining(
                  child: Center(
                child: Text("No Activities after Filtered.\nPlease try again.",
                    style: GoogleFonts.nunito(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary)),
              ))
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
                        type: activity.type);
                  },
                  childCount: eventProvider.activities!.length,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
// SizedBox(height: 10),
//                       // Filtering Pills
//                       Row(
//                         // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           FilterChip(
//                             elevation: 3,
//                             label: Text('All',
//                                 style: GoogleFonts.poppins(
//                                     color: _isSelected[0]
//                                         ? Colors.white
//                                         : Colors.black)),
//                             onSelected: (bool value) {
//                               setState(() {
//                                 _isSelected[0] = value;
//                               });
//                             },
//                             selected: _isSelected[0],
//                             checkmarkColor: Colors.white,
//                             backgroundColor: Colors.white,
//                             selectedColor: AppColors.primary,
//                           ),
//                           SizedBox(width: 5),

//                         ],
//                       ),

// FilterChip(
//                             elevation: 3,
//                             label: Text('Projects',
//                                 style: GoogleFonts.poppins(
//                                     color: _isSelected[1]
//                                         ? Colors.white
//                                         : Colors.black)),
//                             onSelected: (bool value) {
//                               setState(() {
//                                 _isSelected[1] = value;
//                               });
//                             },
//                             selected: _isSelected[1],
//                             checkmarkColor: Colors.white,
//                             backgroundColor: Colors.white,
//                             selectedColor: AppColors.primary,
//                           ),
//                           SizedBox(width: 5),
//                           FilterChip(
//                             elevation: 3,
//                             label: Text('Speech',
//                                 style: GoogleFonts.poppins(
//                                     color: _isSelected[2]
//                                         ? Colors.white
//                                         : Colors.black)),
//                             onSelected: (bool value) {
//                               setState(() {
//                                 _isSelected[2] = value;
//                               });
//                             },
//                             selected: _isSelected[2],
//                             checkmarkColor: Colors.white,
//                             backgroundColor: Colors.white,
//                             selectedColor: AppColors.primary,
//                           ),
