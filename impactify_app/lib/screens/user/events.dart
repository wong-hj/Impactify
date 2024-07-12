import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:impactify_app/models/activity.dart';
import 'package:impactify_app/models/event.dart';
import 'package:impactify_app/providers/event_provider.dart';
import 'package:impactify_app/screens/user/filterOption.dart';
import 'package:impactify_app/theming/custom_themes.dart';
import 'package:impactify_app/widgets/custom_cards.dart';
import 'package:impactify_app/widgets/custom_loading.dart';
import 'package:provider/provider.dart';

class Events extends ConsumerStatefulWidget {
  Events({super.key});

  @override
  _EventsState createState() => _EventsState();
}

class _EventsState extends ConsumerState<Events> {
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
      ref.read(eventProvider.notifier).fetchAllActivities();
    });
  }

  String selectedFilter = 'All';
  List<String> selectedTags = [];

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return FilterOptions(
          onApplyFilters: (String filter, List<String> tags) {
            setState(() {
              selectedFilter = filter;
              selectedTags = tags;
            });
            // Fetch and update your list here based on the selected filters
          },
          selectedFilter: selectedFilter,
          selectedTags: selectedTags,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final eventState = ref.watch(eventProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              floating: true,
              pinned: true,
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
                    SizedBox(height: 20),
                    // Search Bar
                    TextField(
                      onChanged: (text) {
                        // Perform action when text changes
                        print('Text changed to: $text');
                      },
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
              expandedHeight: 80,
            ),
            eventState.isLoading
                ? SliverFillRemaining(
                    child: CustomLoading(text: 'Awesome Stuffs Coming In !'))
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (eventState.activities.isEmpty) {
                          
                        } else {
                          Activity activity = eventState.activities[index];
                          return CustomEventCard(
                            imageUrl: activity.image,
                            title: activity.title,
                            location: activity.location,
                            hostDate: activity.hostDate,
                            eventID: activity.id,
                            type: activity.type,
                          );
                        }
                        return null;
                      },
                      childCount: eventState.activities.length,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
