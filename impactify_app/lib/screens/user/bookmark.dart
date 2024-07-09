import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:impactify_app/providers/bookmark_provider.dart';
import 'package:impactify_app/theming/custom_themes.dart';
import 'package:impactify_app/widgets/custom_loading.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Bookmark extends StatefulWidget {
  const Bookmark({super.key});

  @override
  State<Bookmark> createState() => _BookmarkState();
}

class _BookmarkState extends State<Bookmark> {
  @override
  void initState() {
    super.initState();
    // Fetch events when the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BookmarkProvider>(context, listen: false)
          .fetchBookmarksAndEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bookmarkProvider = Provider.of<BookmarkProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: bookmarkProvider.isLoading
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

                    Expanded(
                      child: ListView.builder(
                        itemCount: bookmarkProvider.events.length,
                        itemBuilder: (context, index) {
                          final bookmark = bookmarkProvider.events[index];

                          DateTime date = bookmark.hostDate.toDate();
                          String formattedDate =
                              DateFormat('dd MMMM yyyy, HH:mm')
                                  .format(date)
                                  .toUpperCase();
                          return Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 2),
                                child: Slidable(
                                  key: Key(bookmark.title),
                                  startActionPane: ActionPane(
                                    extentRatio: 0.4,
                                    motion: BehindMotion(),
                                    children: [
                                      SlidableAction(
                                        onPressed: (context) {
                                          Navigator.pushNamed(
                                              context, '/eventDetail');
                                        },
                                        backgroundColor: AppColors.secondary,
                                        foregroundColor: Colors.white,
                                        icon: Icons.visibility_rounded,
                                        label: 'View More',
                                      ),
                                    ],
                                  ),
                                  endActionPane: ActionPane(
                                    extentRatio: 0.4,
                                    motion: ScrollMotion(),
                                    children: [
                                      SlidableAction(
                                        onPressed: (context) {
                                          // Handle delete action
                                        },
                                        backgroundColor: Colors.red,
                                        foregroundColor: Colors.white,
                                        icon: Icons.delete,
                                        label: 'Delete',
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Image.network(
                                        bookmark.eventImage,
                                        width: 100,
                                        fit: BoxFit.cover,
                                      ),
                                      SizedBox(width: 8),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            bookmark.title,
                                            style: GoogleFonts.nunito(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            formattedDate,
                                            style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              color: AppColors.placeholder,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Divider(
                                color: Colors.grey,
                                thickness: 1,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
