import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:impactify_app/models/event.dart';
import 'package:impactify_app/models/post.dart';
import 'package:impactify_app/models/speech.dart';
import 'package:impactify_app/providers/bookmark_provider.dart';

import 'package:impactify_app/providers/event_provider.dart';
import 'package:impactify_app/providers/post_provider.dart';
import 'package:impactify_app/providers/speech_provider.dart';

import 'package:impactify_app/widgets/custom_details.dart';
import 'package:impactify_app/widgets/custom_loading.dart';

import 'package:provider/provider.dart';

class SpeechDetail extends StatefulWidget {
  const SpeechDetail({super.key});

  @override
  State<SpeechDetail> createState() => _SpeechDetailState();
}

class _SpeechDetailState extends State<SpeechDetail> {
  late GoogleMapController mapController;
  //String? bookmarkID; // State variable to store bookmarkID
  bool isSaved = false;
  bool isJoined = false;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> _toggleJoinStatus() async {
    setState(() {
      isJoined = !isJoined;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      
        _checkIfBookmarkedAndJoined();
      
    });
  }

  Future<void> _checkIfBookmarkedAndJoined() async {
    final bookmarkProvider =
        Provider.of<BookmarkProvider>(context, listen: false);
    final String speechID =
        ModalRoute.of(context)!.settings.arguments as String;

    bool saved = await bookmarkProvider.isSpeechBookmarked(speechID); //

    final eventProvider = Provider.of<EventProvider>(context, listen: false);

    bool joined = await eventProvider.isActivityJoined(speechID);

    setState(() {
      isSaved = saved;
      isJoined = joined;
    });
  }




  

  @override
  Widget build(BuildContext context) {
    final speechProvider = Provider.of<SpeechProvider>(context, listen: false);
    final String speechID = ModalRoute.of(context)!.settings.arguments as String;
    final postProvider = Provider.of<PostProvider>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: 
      //Text("hi")
      FutureBuilder<Speech?>(
        future: //postProvider.fetchPostByPostID(speechID),
         speechProvider.getSpeechByID(speechID),
        builder: (pageContext, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CustomLoading(text: 'Loading Details...'));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('Speech not found'));
          } else {
            Speech speech = snapshot.data!;
            
            return FutureBuilder<Map<String, String>>(
                future: speechProvider.fetchProjectIDAndName(speech.eventID),
                builder: (context, projectSnapshot) {
                  if (projectSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return SizedBox.shrink();
                  } else if (projectSnapshot.hasError) {
                    return Center(
                        child: Text('Error: ${projectSnapshot.error}'));
                  } else if (!projectSnapshot.hasData) {
                    return Center(child: Text('Speech not found'));
                  } else {
                    Map<String, String> project = projectSnapshot.data!;
                    
                    return CustomDetailScreen(
                      id: speech.speechID,
                      image: speech.image,
                      type: speech.type,
                      title: speech.title,
                      hoster: speech.organizer,
                      location: speech.location,
                      hostDate: speech.hostDate,
                      aboutDescription: speech.description,
                      marker: speechProvider.marker,
                      onMapCreated: _onMapCreated,
                      center: speechProvider.center,
                      onSaved: isSaved,
                      onBookmarkToggle: 
                      () => _saveOrDeleteBookmark(speechID),
                      recordingUrl: speech.recording ?? "",
                      eventID: project['projectID'],
                      eventTitle: project['title'],
                      parentContext: pageContext,
                      isJoined: isJoined,
                      toggleJoinStatus:_toggleJoinStatus,
                    );
                  }
                }
                );
          }
        },
      ),
    );
  }

  Future<void> _saveOrDeleteBookmark(String speechID) async {
    final bookmarkProvider =
        Provider.of<BookmarkProvider>(context, listen: false);

    if (!isSaved) {
      try {
        await bookmarkProvider.addSpeechBookmark(speechID);
        setState(() {
          isSaved = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Saved to Bookmark!'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        print('Error adding bookmark: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add bookmark'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      try {
        await bookmarkProvider.removeSpeechBookmark(speechID);
        setState(() {
          isSaved = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Removed Bookmark!'),
            backgroundColor: Colors.red,
          ),
        );
      } catch (e) {
        print('Error removing bookmark: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to remove bookmark'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
