import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:impactify_management/models/speech.dart';
import 'package:impactify_management/providers/activity_provider.dart';
import 'package:impactify_management/widgets/custom_details.dart';
import 'package:impactify_management/widgets/custom_loading.dart';

import 'package:provider/provider.dart';

class SpeechDetail extends StatefulWidget {
  const SpeechDetail({super.key});

  @override
  State<SpeechDetail> createState() => _SpeechDetailState();
}

class _SpeechDetailState extends State<SpeechDetail> {
  late GoogleMapController mapController;
  //String? bookmarkID; // State variable to store bookmarkID
  bool isSaved = false; // State variable to track if the event is bookmarked
  bool isJoined = false;
  final ImagePicker _picker = ImagePicker();
  XFile? _videoFile;
  String videoName = '';

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    final activityProvider =
        Provider.of<ActivityProvider>(context, listen: false);
    final String speechID =
        ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: FutureBuilder<Speech?>(
        future: activityProvider.fetchSpeechByID(speechID),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CustomLoading(text: 'Fetching Speech Details...'));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('Speech not found'));
          } else {
            final speech = snapshot.data!;
            return CustomDetailScreen(
              id: speech.speechID,
              image: speech.image,
              type: speech.type,
              title: speech.title,
              hoster: speech.organizer,
              location: speech.location,
              hostDate: speech.hostDate,
              aboutDescription: speech.description,
              marker: activityProvider.marker,
              onMapCreated: _onMapCreated,
              center: activityProvider.center,
              attendees: activityProvider.attendees,
              recordingUrl: speech.recording,
              onPickVideo: _pickVideo,
              onUploadVideo: _uploadVideo,
              videoName: videoName,
            );
          }
        },
      ),
    );
  }

  Future<void> _pickVideo() async {
    final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
    if (video != null) {
      setState(() {
        _videoFile = video;
        videoName = video.name;
      });
    }
  }

  Future<void> _uploadVideo() async {
    final String speechID =
        ModalRoute.of(context)!.settings.arguments as String;
    final activityProvider =
        Provider.of<ActivityProvider>(context, listen: false);
    if (_videoFile == null) return;

    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 2),
          content: Text('Uploading Recording...'),
          backgroundColor: Colors.blue,
        ),
      );
      await activityProvider.uploadRecording(_videoFile, speechID);
      setState(() {
        
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Video uploaded successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to upload video: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
