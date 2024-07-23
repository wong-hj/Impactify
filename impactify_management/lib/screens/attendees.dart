import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:impactify_management/models/user.dart';
import 'package:impactify_management/theming/custom_themes.dart';
import 'package:impactify_management/widgets/custom_buttons.dart';
import 'package:impactify_management/widgets/custom_list.dart';

class Attendees extends StatefulWidget {
  const Attendees({super.key});

  @override
  State<Attendees> createState() => _AttendeesState();
}

class _AttendeesState extends State<Attendees> {
  List<String> selectedEmails = [];
  bool isSelectMode = false;
  bool selectAll = false;

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final List<User> attendees = args['attendees'];
    // final String activityTitle = args['title'];
    // final String activityLocation = args['location'];
    // final Timestamp activityDate = args['hostDate'];
    // final String activityOrganizer = args['hoster'];

    void toggleSelectAll(bool value) {
      setState(() {
        selectAll = value;
        selectedEmails =
            value ? attendees.map((user) => user.email).toList() : [];
      });
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Attendees (${attendees.length})',
            style: GoogleFonts.merriweather()),
        actions: [
          if (isSelectMode)
            TextButton(
              onPressed: () {
                toggleSelectAll(!selectAll);
              },
              child: Text(
                selectAll ? 'Deselect All' : 'Select All',
                style: TextStyle(color: AppColors.primary),
              ),
            ),
          IconButton(
            icon: Icon(isSelectMode ? Icons.close : Icons.select_all),
            onPressed: () {
              setState(() {
                isSelectMode = !isSelectMode;
                if (!isSelectMode) {
                  selectedEmails.clear();
                  selectAll = false;
                }
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: attendees.length,
              itemBuilder: (context, index) {
                final attendee = attendees[index];
                return CustomAttendeesList(
                  user: attendee,
                  isSelectMode: isSelectMode,
                  isSelected: selectedEmails.contains(attendee.email),
                  onSelectChanged: (bool? selected) {
                    setState(() {
                      if (selected!) {
                        selectedEmails.add(attendee.email);
                      } else {
                        selectedEmails.remove(attendee.email);
                      }
                    });
                  },
                );
              },
            ),
          ),
          if (isSelectMode)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: selectedEmails.isNotEmpty ? _sendEmails : null,
                child: Text('Send Reminder to Attendees!'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: AppColors.primary, // Text color
                  textStyle: GoogleFonts.poppins(fontSize: 16),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5), // Border radius
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _sendEmails() async {
    // Your email sending logic goes here
    print('Sending email to: $selectedEmails');
    FlutterEmailSender.send(
      Email(
        body: 'I would like to request more information.',
        recipients: selectedEmails,
        subject: 'Information request',
        bcc: ['info@yournews.com'],
        cc: ['support@yournews.com'],
      ),
    ).then(
      (_) => ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            'The reminder email has been sent to attendees!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
