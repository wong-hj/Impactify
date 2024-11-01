import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:impactify_app/theming/custom_themes.dart';

class CustomList extends StatelessWidget {
  final String imageUrl;
  final String? eventID;
  final String? speechID;
  final String title;
  final String date;
  final String image;
  final void Function(BuildContext) onPressed;

  const CustomList({
    required this.imageUrl,
    this.eventID,
    this.speechID,
    required this.title,
    required this.date,
    required this.image,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Slidable(
            key: Key(title),
            endActionPane: ActionPane(
              extentRatio: 0.4,
              motion: ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: onPressed,
                  //(context) async {
                  //   try {
                  //     await bookmarkNotifier
                  //         .removeBookmark(
                  //             bookmark.eventID);
                  //   } catch (e) {
                  //     print(
                  //         'Error removing bookmark: $e');
                  //     ScaffoldMessenger.of(context)
                  //         .showSnackBar(
                  //       SnackBar(
                  //         content: Text(
                  //             'Failed to remove bookmark'),
                  //         backgroundColor:
                  //             Colors.red,
                  //       ),
                  //     );

                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'Delete',
                ),
              ],
            ),
            child: GestureDetector(
              onTap: () {
                eventID != null
                    ? Navigator.pushNamed(
                        context,
                        '/eventDetail',
                        arguments: eventID,
                      )
                    : Navigator.pushNamed(
                        context,
                        '/speechDetail',
                        arguments: speechID,
                      );
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    image,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.nunito(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        date,
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
        ),
        Divider(
          color: Colors.grey,
          thickness: 1,
        ),
      ],
    );
  }
}
