import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:impactify_management/theming/custom_themes.dart';
import 'package:impactify_management/widgets/custom_text.dart';

class CustomList extends StatelessWidget {
  
  final String? eventID;
  final String? speechID;
  final String title;
  final String date;
  final String image;
  final String location;
  final void Function(BuildContext) onPressed;

  const CustomList({
    this.eventID,
    this.speechID,
    required this.title,
    required this.date,
    required this.image,
    required this.location,
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
            startActionPane: ActionPane(
              extentRatio: 0.4,
              motion: ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: onPressed,

                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'Delete',
                ),
              ],
            ),
            endActionPane: ActionPane(
              extentRatio: 0.4,
              motion: ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: onPressed,

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
                    width: 70,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.merriweather(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        CustomIconText(text: location, icon: Icons.pin_drop_outlined, size: 12, color: AppColors.primary),
                        SizedBox(height: 2),
                        CustomIconText(text: date, icon: Icons.calendar_month, size: 12, color: AppColors.primary),
                      ],
                    ),
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
