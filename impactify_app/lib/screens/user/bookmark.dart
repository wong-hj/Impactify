import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:impactify_app/theming/custom_themes.dart';

class Bookmark extends StatelessWidget {
  const Bookmark({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> bookmarks = [
      {
        'imageUrl': 'https://tinyurl.com/4ztj48vp',
        'title': 'Event 1',
        'date': '2024-09-11',
      },
      {
        'imageUrl': 'https://tinyurl.com/4ztj48vp',
        'title': 'Event 2',
        'date': '2024-10-01',
      },
      {
        'imageUrl': 'https://tinyurl.com/4ztj48vp',
        'title': 'Event 3',
        'date': '2024-11-05',
      },
      {
        'imageUrl': 'https://tinyurl.com/4ztj48vp',
        'title': 'Event 3',
        'date': '2024-11-05',
      },
      {
        'imageUrl': 'https://tinyurl.com/4ztj48vp',
        'title': 'Event 3',
        'date': '2024-11-05',
      },
      {
        'imageUrl': 'https://tinyurl.com/4ztj48vp',
        'title': 'Event 3',
        'date': '2024-11-05',
      },
      {
        'imageUrl': 'https://tinyurl.com/4ztj48vp',
        'title': 'Event 3',
        'date': '2024-11-05',
      },
      {
        'imageUrl': 'https://tinyurl.com/4ztj48vp',
        'title': 'Event 3',
        'date': '2024-11-05',
      },
      {
        'imageUrl': 'https://tinyurl.com/4ztj48vp',
        'title': 'Event 3',
        'date': '2024-11-05',
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
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
                  itemCount: bookmarks.length,
                  itemBuilder: (context, index) {
                    final bookmark = bookmarks[index];
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Slidable(
                            key: Key(bookmark['title']!),
                            startActionPane: ActionPane(
                              extentRatio: 0.4,
                              motion: BehindMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (context) {
                                    // Handle edit action
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
                            child: 
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.network(
                                      bookmark['imageUrl']!,
                                      width: 100,
                                      fit: BoxFit.cover,
                                    ),
                                    SizedBox(width: 8),
                                    
                                     Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            bookmark['title']!,
                                            style: GoogleFonts.nunito(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            bookmark['date']!,
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
