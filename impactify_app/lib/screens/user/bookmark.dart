import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:impactify_app/models/event.dart';
import 'package:impactify_app/models/speech.dart';
import 'package:impactify_app/providers/bookmark_provider.dart';
import 'package:impactify_app/theming/custom_themes.dart';
import 'package:impactify_app/widgets/custom_lists.dart';
import 'package:impactify_app/widgets/custom_loading.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Bookmark extends ConsumerStatefulWidget {
  Bookmark({super.key});

  @override
  _BookmarkState createState() => _BookmarkState();
}

class _BookmarkState extends ConsumerState<Bookmark>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // Fetch events when the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //ref.read(bookmarkProvider.notifier).fetchBookmarksAndEvents();
      ref.read(bookmarkProvider.notifier).fetchBookmarksAndProjects();
      ref.read(bookmarkProvider.notifier).fetchBookmarksAndSpeeches();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bookmarkState = ref.watch(bookmarkProvider);
    final bookmarkNotifier = ref.read(bookmarkProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: bookmarkState.isLoading
          ? Center(child: CustomLoading(text: 'Loading...'))
          : SafeArea(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Heading
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'My ',
                            style: GoogleFonts.nunito(fontSize: 24),
                          ),
                          TextSpan(
                            text: 'Bookmark',
                            style: GoogleFonts.nunito(
                                fontSize: 24,
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      height: 38.0,
                      child: TabBar(
                        splashFactory: NoSplash.splashFactory,
                        dividerColor: Colors.transparent,
                        controller: _tabController,
                        indicator: UnderlineTabIndicator(
                          borderSide:
                              BorderSide(width: 2.0, color: AppColors.primary),
                        ),
                        labelColor: AppColors.primary,
                        unselectedLabelColor: Colors.black,
                        labelStyle: GoogleFonts.poppins(),
                        unselectedLabelStyle: GoogleFonts.poppins(),
                        tabs: [
                          Tab(
                            child: Container(
                              width: double.infinity,
                              alignment: Alignment.center,
                              child: Text('Projects'),
                            ),
                          ),
                          Tab(
                            child: Container(
                              width: double.infinity,
                              alignment: Alignment.center,
                              child: Text('Speech'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          ProjectContent(),
                          SpeechContent()
                          //PostContent(),
                          //HistoryContent(),
                        ],
                      ),
                    ),
                    
                    // Expanded(
                    //   child: bookmarkState.bookmarks.isEmpty
                    //       ? Center(
                    //           child: Text('No Bookmark as of now.',
                    //               style: GoogleFonts.poppins(
                    //                   color: AppColors.primary, fontSize: 18)))
                    //       : ListView.builder(
                    //           itemCount: bookmarkState.bookmarks.length,
                    //           itemBuilder: (context, index) {
                    //             final bookmark = bookmarkState.bookmarks[index];

                    //             if (bookmark.eventID != null) {
                    //               final event = bookmarkState.events.firstWhere(
                    //                   (e) => e.eventID == bookmark.eventID,
                    //                   orElse: () => Event(eventID: '', title: '', description: '', location: '', organizer: '', hostDate: Timestamp.now(), createdAt: Timestamp.now(), impointsAdd: 0, sdg: '', status: '', type: '', image: ''),);
                    //               if (event != null) {
                    //                 return ListTile(
                    //                   title: Text(event.title),
                    //                   subtitle: Text(event.description),
                    //                 );
                    //               }
                    //             } else if (bookmark.speechID != null) {
                    //               final speech = bookmarkState.speeches
                    //                   .firstWhere(
                    //                       (s) =>
                    //                           s.speechID == bookmark.speechID,
                    //                       orElse: () => Speech(speechID: '', image: '', type: '', title: '', description: '', location: '', organizer: '', hostDate: Timestamp.now(), createdAt: Timestamp.now(), eventID: '', status: ''),);
                    //               if (speech != null) {
                    //                 return ListTile(
                    //                   title: Text(speech.title),
                    //                   subtitle: Text(speech.description),
                    //                 );
                    //               }
                    //             }
                    //             return null;
                    //             // DateTime date = bookmark.hostDate.toDate();
                    //             // String formattedDate =
                    //             //     DateFormat('dd MMMM yyyy, HH:mm')
                    //             //         .format(date)
                    //             //         .toUpperCase();
                    //           },
                    //         ),
                    // ),
                  ],
                ),
              ),
            ),
    );
  }
}

class ProjectContent extends ConsumerWidget {
  const ProjectContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarkState = ref.watch(bookmarkProvider);
    final bookmarkNotifier = ref.read(bookmarkProvider.notifier);
    
    return Column(
      children: [
        Expanded(
          child: bookmarkState.events.isEmpty
              ? Center(
                  child: Text('No Bookmark for Projects as of now.',
                      style: GoogleFonts.poppins(
                          color: AppColors.primary, fontSize: 18)))
              : ListView.builder(
                  itemCount: bookmarkState.events.length,
                  itemBuilder: (context, index) {
                    final bookmark = bookmarkState.events[index];
                    DateTime date = bookmark.hostDate.toDate();
                    String formattedDate = DateFormat('dd MMMM yyyy, HH:mm')
                        .format(date)
                        .toUpperCase();
                    return CustomList(
                      imageUrl: bookmark.image,
                      eventID: bookmark.eventID,
                      title: bookmark.title,
                      date: formattedDate,
                      image: bookmark.image,
                      onPressed: (context) async {
                        try {
                          await bookmarkNotifier.removeProjectBookmark(bookmark.eventID);
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
        ),
      ],
    );
  }
}

class SpeechContent extends ConsumerWidget {
  const SpeechContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarkState = ref.watch(bookmarkProvider);
    final bookmarkNotifier = ref.read(bookmarkProvider.notifier);
    //print(bookmarkState.events.toList());
    return Column(
      children: [
        Expanded(
          child: bookmarkState.speeches.isEmpty
              ? Center(
                  child: Text('No Bookmark for Projects as of now.',
                      style: GoogleFonts.poppins(
                          color: AppColors.primary, fontSize: 18)))
              : ListView.builder(
                  itemCount: bookmarkState.speeches.length,
                  itemBuilder: (context, index) {
                    final bookmark = bookmarkState.speeches[index];
                    DateTime date = bookmark.hostDate.toDate();
                    String formattedDate = DateFormat('dd MMMM yyyy, HH:mm')
                        .format(date)
                        .toUpperCase();
                    return CustomList(
                      imageUrl: bookmark.image,
                      speechID: bookmark.speechID,
                      title: bookmark.title,
                      date: formattedDate,
                      image: bookmark.image,
                      onPressed: (context) async {
                        try {
                          await bookmarkNotifier.removeSpeechBookmark(bookmark.speechID);
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
        ),
      ],
    );
  }
}

