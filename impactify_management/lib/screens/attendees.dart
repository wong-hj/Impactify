import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:impactify_management/models/user.dart';
import 'package:impactify_management/theming/custom_themes.dart';
import 'package:impactify_management/widgets/custom_list.dart';

class Attendees extends StatelessWidget {
  const Attendees({super.key});

  @override
  Widget build(BuildContext context) {
    final List<User> attendees =
        ModalRoute.of(context)!.settings.arguments as List<User>;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Attendees (${attendees.length})', style: GoogleFonts.merriweather()),
        centerTitle: true,
      ),
      body: ListView.builder(
          itemCount: attendees.length,
          itemBuilder: (context, index) {
            final attendee = attendees[index];
            return CustomAttendeesList(user: attendee);
          }),
    );
  }
}
